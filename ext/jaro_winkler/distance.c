#include <string.h>
#include <stdlib.h>
#include "distance.h"

static int char_bytes_num(char first_char){
  unsigned char c = first_char;
  if(c >= 252) return 6;      // 1111110x
  else if(c >= 248) return 5; // 111110xx
  else if(c >= 240) return 4; // 11110xxx
  else if(c >= 224) return 3; // 1110xxxx
  else if(c >= 192) return 2; // 110xxxxx
  else return 1;
}

static unsigned long* codepoints(const char *str, int *ret_len){
  int str_len = strlen(str);
  unsigned long *ret = calloc(str_len, sizeof(long));
  int count = 0;
  for(int i = 0; i < str_len;){
    int bytes_num = char_bytes_num(str[i]);
    memcpy(&ret[count], &str[i], bytes_num);
    count++;
    i += bytes_num;
  }
  *ret_len = count;
  return ret;
}

double c_distance(char *s1, char *s2){
  int ary_1_len, ary_2_len;
  unsigned long *ary_1 = codepoints(s1, &ary_1_len), *ary_2 = codepoints(s2, &ary_2_len);
  // Guarantee the order
  if(ary_1_len > ary_2_len){
    unsigned long *tmp = ary_1; ary_1 = ary_2; ary_2 = tmp;
    int tmp2 = ary_1_len; ary_1_len = ary_2_len; ary_2_len = tmp2;
  }
  int window_size = ary_2_len / 2 - 1;
  double matches = 0.0;
  int transpositions = 0;
  int previous_index = -1;
  int max_index = ary_2_len - 1;
  for(int i = 0; i < ary_1_len; i++){
    int left  = i - window_size;
    int right = i + window_size;
    if(left  < 0) left = 0;
    if(right > max_index) right = max_index;
    char matched   = 0;
    char found     = 0;
    for(int j = left; j <= right; j++){
      if(ary_1[i] == ary_2[j]){
        matched = 1;
        if(!found){
          if(j > previous_index){
            previous_index = j;
            found = 1;
          }
        } // if(!found){
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
  double threshold = 0.7, weight = 0.1;
  int prefix = 0;
  int max_length = ary_1_len > 4 ? 4 : ary_1_len;
  for(int i = 0; i < max_length; ++i){
    if(ary_1[i] == ary_2[i]) prefix++;
    else break;
  }
  free(ary_1); free(ary_2);
  return jaro_distance < threshold ? jaro_distance : jaro_distance + ((prefix * weight) * (1 - jaro_distance));
}