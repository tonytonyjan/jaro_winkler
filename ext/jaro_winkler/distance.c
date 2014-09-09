#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "distance.h"

Option* option_new(){
  Option *opt = calloc(1, sizeof(Option));
  opt->ignore_case = 0;
  opt->weight = 0.1;
  opt->threshold = 0.7;
  return opt;
}

void unicode_hash(const char *str, unsigned long long *ret_hash, int *ret_length){
  unsigned char first_char = str[0];
  if(first_char >= 252) *ret_length = 6;      // 1111110x
  else if(first_char >= 248) *ret_length = 5; // 111110xx
  else if(first_char >= 240) *ret_length = 4; // 11110xxx
  else if(first_char >= 224) *ret_length = 3; // 1110xxxx
  else if(first_char >= 192) *ret_length = 2; // 110xxxxx
  else *ret_length = 1;
  memcpy(ret_hash, str, *ret_length);
}

static void codepoints(const char *str, int byte_len, unsigned long long **ret_ary, int *ret_len){
  *ret_ary = calloc(byte_len, sizeof(long long));
  int count = 0;
  for(int i = 0; i < byte_len;){
    int bytes_num;
    unicode_hash(str + i, *ret_ary + count, &bytes_num);
    count++;
    i += bytes_num;
  }
  *ret_len = count;
}

double c_distance(char *s1, int byte_len1, char *s2, int byte_len2, Option *opt){
  // set default option if NULL passed
  int free_opt_flag = 0;
  if(!opt){ free_opt_flag = 1; opt = option_new(); }

  int ary_1_len, ary_2_len;
  unsigned long long *ary_1, *ary_2;
  codepoints(s1, byte_len1, &ary_1, &ary_1_len);
  codepoints(s2, byte_len2, &ary_2, &ary_2_len);

  if(opt->ignore_case){
    for(int i = 0; i < ary_1_len; ++i) if(ary_1[i] < 256 && islower(ary_1[i])) ary_1[i] -= 32;
    for(int i = 0; i < ary_2_len; ++i) if(ary_2[i] < 256 && islower(ary_2[i])) ary_2[i] -= 32;
  }

  // Guarantee the order
  if(ary_1_len > ary_2_len){
    unsigned long long *tmp = ary_1; ary_1 = ary_2; ary_2 = tmp;
    int tmp2 = ary_1_len; ary_1_len = ary_2_len; ary_2_len = tmp2;
  }
  int window_size = ary_2_len / 2 - 1;
  if(window_size < 0) window_size = 0;
  double matches     = 0.0;
  int transpositions = 0;
  int previous_index = -1;
  int max_index      = ary_2_len - 1;
  for(int i = 0; i < ary_1_len; i++){
    int left  = i - window_size;
    int right = i + window_size;
    if(left  < 0) left = 0;
    if(right > max_index) right = max_index;
    char matched = 0, found = 0;
    for(int j = left; j <= right; j++){
      if(ary_1[i] == ary_2[j]){
        matched = 1;
        if(!found && j > previous_index){
          previous_index = j;
          found = 1;
        }
      } // if(ary_1[i] == ary_2[j]){
    } // for(int j = left; j <= right; j++){
    if(matched){
      matches++;
      if(!found) transpositions++;
    }
  } // for(int i = 0; i < ary_1_len; i++){

  // Don't divide transpositions by 2 since it's been counted directly by above code.
  double jaro_distance =  matches == 0 ? 0 : (matches / ary_1_len + matches / ary_2_len + (matches - transpositions) / matches) / 3.0;

  // calculate jaro-winkler distance
  double threshold = opt->threshold, weight = opt->weight;
  int prefix = 0;
  int max_length = ary_1_len > 4 ? 4 : ary_1_len;
  for(int i = 0; i < max_length; ++i){
    if(ary_1[i] == ary_2[i]) prefix++;
    else break;
  }
  free(ary_1); free(ary_2);
  if(free_opt_flag) free(opt);
  return jaro_distance < threshold ? jaro_distance : jaro_distance + ((prefix * weight) * (1 - jaro_distance));
}