#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "distance.h"
#include "adj_matrix.h"

typedef struct{
  unsigned long long code;
  unsigned int byte_length;
} UnicodeHash;

typedef struct{
  unsigned long long *ary;
  int length;
} Codepoints;

const char *DEFAULT_ADJ_TABLE[] = {
  "A","E", "A","I", "A","O", "A","U", "B","V", "E","I", "E","O", "E","U", "I","O", "I","U", "O","U",
  "I","Y", "E","Y", "C","G", "E","F", "W","U", "W","V", "X","K", "S","Z", "X","S", "Q","C", "U","V",
  "M","N", "L","I", "Q","O", "P","R", "I","J", "2","Z", "5","S", "8","B", "1","I", "1","L", "0","O",
  "0","Q", "C","K", "G","J", "E"," ", "Y"," ", "S"," "
};

static UnicodeHash unicode_hash_new(const char *str);
static Codepoints codepoints_new(const char *str, int byte_len);
static AdjMatrix* adj_matrix_default();

Option option_new(){
  Option opt;
  opt.ignore_case = opt.adj_table = 0;
  opt.weight = 0.1;
  opt.threshold = 0.7;
  return opt;
}

double c_distance(char *s1, int s1_byte_len, char *s2, int s2_byte_len, Option opt){
  // set default option if NULL passed
  int free_opt_flag = 0;

  Codepoints code_ary_1 = codepoints_new(s1, s1_byte_len);
  Codepoints code_ary_2 = codepoints_new(s2, s2_byte_len);

  if(opt.ignore_case){
    for(int i = 0; i < code_ary_1.length; ++i) if(code_ary_1.ary[i] < 256 && islower(code_ary_1.ary[i])) code_ary_1.ary[i] -= 32;
    for(int i = 0; i < code_ary_2.length; ++i) if(code_ary_2.ary[i] < 256 && islower(code_ary_2.ary[i])) code_ary_2.ary[i] -= 32;
  }

  // Guarantee the order
  if(code_ary_1.length > code_ary_2.length){
    unsigned long long *tmp = code_ary_1.ary; code_ary_1.ary = code_ary_2.ary; code_ary_2.ary = tmp;
    int tmp2 = code_ary_1.length; code_ary_1.length = code_ary_2.length; code_ary_2.length = tmp2;
  }

  // Compute jaro distance
  int window_size = code_ary_2.length / 2 - 1;
  if(window_size < 0) window_size = 0;
  double matches     = 0.0;
  double sim_matches = 0.0;
  int transpositions = 0;
  int previous_index = -1;
  int max_index      = code_ary_2.length - 1;
  for(int i = 0; i < code_ary_1.length; i++){
    int left  = i - window_size;
    int right = i + window_size;
    if(left  < 0) left = 0;
    if(right > max_index) right = max_index;
    char matched     = 0;
    char found       = 0;
    char sim_matched = 0;
    for(int j = left; j <= right; j++){
      if(code_ary_1.ary[i] == code_ary_2.ary[j]){
        matched = 1;
        if(!found && j > previous_index){
          previous_index = j;
          found = 1;
        }
      }else if(opt.adj_table && adj_matrix_find(adj_matrix_default(), code_ary_1.ary[i], code_ary_2.ary[j])) sim_matched = 1;
    } // for(int j = left; j <= right; j++){
    if(matched){
      matches++;
      if(!found) transpositions++;
    }else if(sim_matched) sim_matches += 3;
  } // for(int i = 0; i < code_ary_1.length; i++){

  // Don't divide transpositions by 2 since it's been counted directly by above code.
  double similarity = matches;
  if(opt.adj_table) similarity += sim_matches / 10;
  double jaro_distance = matches == 0 ? 0 : (similarity / code_ary_1.length + similarity / code_ary_2.length + (matches - transpositions) / matches) / 3.0;

  // calculate jaro-winkler distance
  double threshold = opt.threshold, weight = opt.weight;
  int prefix = 0;
  int max_length = code_ary_1.length > 4 ? 4 : code_ary_1.length;
  for(int i = 0; i < max_length; ++i){
    if(code_ary_1.ary[i] == code_ary_2.ary[i]) prefix++;
    else break;
  }
  free(code_ary_1.ary); free(code_ary_2.ary);
  return jaro_distance < threshold ? jaro_distance : jaro_distance + ((prefix * weight) * (1 - jaro_distance));
}

static UnicodeHash unicode_hash_new(const char *str){
  UnicodeHash ret = {};
  unsigned char first_char = str[0];
  if(first_char >= 252) ret.byte_length = 6;      // 1111110x
  else if(first_char >= 248) ret.byte_length = 5; // 111110xx
  else if(first_char >= 240) ret.byte_length = 4; // 11110xxx
  else if(first_char >= 224) ret.byte_length = 3; // 1110xxxx
  else if(first_char >= 192) ret.byte_length = 2; // 110xxxxx
  else ret.byte_length = 1;
  memcpy(&ret.code, str, ret.byte_length);
  return ret;
}

static Codepoints codepoints_new(const char *str, int byte_len){
  Codepoints ret = {};
  ret.ary = calloc(byte_len, sizeof(long long));
  int count = 0;
  for(int i = 0; i < byte_len;){
    UnicodeHash hash = unicode_hash_new(str + i);
    ret.ary[count] = hash.code;
    count++;
    i += hash.byte_length;
  }
  ret.length += count;
  return ret;
}

static AdjMatrix* adj_matrix_default(){
  static char first_time = 1;
  static AdjMatrix *ret_matrix;
  if(first_time){
    ret_matrix = adj_matrix_new(ADJ_MATRIX_DEFAULT_LENGTH);
    for(int i = 0; i < 78; i += 2){
      UnicodeHash h1 = unicode_hash_new(DEFAULT_ADJ_TABLE[i]), h2 = unicode_hash_new(DEFAULT_ADJ_TABLE[i + 1]);
      adj_matrix_add(ret_matrix, h1.code, h2.code);
    }
    first_time = 0;
  }
  return ret_matrix;
}