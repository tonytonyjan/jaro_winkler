#include <stdlib.h>
#include <ctype.h>
#include "distance.h"
#include "codepoints.h"
#include "adj_matrix.h"

Option option_new(){
  Option opt;
  opt.ignore_case = opt.adj_table = 0;
  opt.weight = 0.1;
  opt.threshold = 0.7;
  return opt;
}

double distance(char *s1, int s1_byte_len, char *s2, int s2_byte_len, Option opt){
  Codepoints code_ary_1 = codepoints_new(s1, s1_byte_len),
             code_ary_2 = codepoints_new(s2, s2_byte_len);

  if(opt.ignore_case){
    for(int i = 0; i < code_ary_1.length; ++i) if(code_ary_1.ary[i] < 256u && islower(code_ary_1.ary[i])) code_ary_1.ary[i] -= 32u;
    for(int i = 0; i < code_ary_2.length; ++i) if(code_ary_2.ary[i] < 256u && islower(code_ary_2.ary[i])) code_ary_2.ary[i] -= 32u;
  }

  // Guarantee the order
  if(code_ary_1.length > code_ary_2.length){
    UnicodeCharCode *tmp = code_ary_1.ary; 
    int tmp2 = code_ary_1.length; 
    code_ary_1.ary = code_ary_2.ary; code_ary_2.ary = tmp;
    code_ary_1.length = code_ary_2.length; code_ary_2.length = tmp2;
  }

  // Compute jaro distance
  int window_size = code_ary_2.length / 2 - 1;
  if(window_size < 0) window_size = 0;
  double matches     = 0.0,
         sim_matches = 0.0;
  int transpositions = 0,
      previous_index = -1,
      max_index      = code_ary_2.length - 1;
  for(int i = 0; i < code_ary_1.length; i++){
    int left  = i - window_size;
    int right = i + window_size;
    if(left  < 0) left = 0;
    if(right > max_index) right = max_index;
    char matched     = 0,
         found       = 0,
         sim_matched = 0;
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
