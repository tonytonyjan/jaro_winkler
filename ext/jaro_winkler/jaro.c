#include "jaro.h"
#include "code.h"
#include "adj_matrix.h"

#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define SWAP(x, y) do{ __typeof__(x) SWAP = x; x = y; y = SWAP; }while(0)

const LibJaroOption DEFAULT_OPT = {.weight = DEFAULT_WEIGHT, .threshold = DEFAULT_THRESHOLD, .ignore_case = 0, .adj_table = 0};

double jaro_distance_from_codes(uint64_t *codes1, size_t len1, uint64_t *codes2, size_t len2, LibJaroOption *opt);
double jaro_winkler_distance_from_codes(uint64_t *codes1, size_t len1, uint64_t *codes2, size_t len2, LibJaroOption *opt);

double jaro_distance(char* short_str, size_t short_str_len, char* long_str, size_t long_str_len, LibJaroOption *opt){
  if(!short_str_len || !long_str_len) return 0.0;

  uint64_t *short_codes, *long_codes;
  size_t short_codes_len, long_codes_len;
  string_to_codes(short_str, short_str_len, &short_codes, &short_codes_len);
  string_to_codes(long_str, long_str_len, &long_codes, &long_codes_len);

  double ret = jaro_distance_from_codes(short_codes, short_codes_len, long_codes, long_codes_len, opt);

  free(short_codes); free(long_codes);
  return ret;
}

double jaro_winkler_distance(char* short_str, size_t short_str_len, char* long_str, size_t long_str_len, LibJaroOption *opt){
  if(!short_str_len || !long_str_len) return 0.0;

  uint64_t *short_codes, *long_codes;
  size_t short_codes_len, long_codes_len;
  string_to_codes(short_str, short_str_len, &short_codes, &short_codes_len);
  string_to_codes(long_str, long_str_len, &long_codes, &long_codes_len);

  double ret = jaro_winkler_distance_from_codes(short_codes, short_codes_len, long_codes, long_codes_len, opt);

  free(short_codes); free(long_codes);
  return ret;
}

double jaro_distance_from_codes(uint64_t* short_codes, size_t short_codes_len, uint64_t* long_codes, size_t long_codes_len, LibJaroOption *opt){
  if(!short_codes_len || !long_codes_len) return 0.0;

  if(short_codes_len > long_codes_len){
    SWAP(short_codes, long_codes);
    SWAP(short_codes_len, long_codes_len);
  }

  if(opt->ignore_case){
    for(size_t i = 0; i < short_codes_len; i++) short_codes[i] = tolower(short_codes[i]);
    for(size_t i = 0; i < long_codes_len; i++) long_codes[i] = tolower(long_codes[i]);
  }

  int32_t window_size = long_codes_len/2 - 1;
  if(window_size < 0) window_size = 0;

  char short_codes_flag[short_codes_len];
  char long_codes_flag[long_codes_len];
  memset(short_codes_flag, 0, short_codes_len);
  memset(long_codes_flag, 0, long_codes_len);

  // count number of matching characters
  size_t match_count = 0;
  for(size_t i = 0; i < short_codes_len; i++){
    size_t left = (i >= window_size) ? i - window_size : 0;
    size_t right = (i + window_size <= long_codes_len - 1) ? (i + window_size) : (long_codes_len - 1);
    if(right > long_codes_len - 1) right = long_codes_len - 1;
    for(size_t j = left; j <= right; j++){
      if(!long_codes_flag[j] && short_codes[i] == long_codes[j]){
        short_codes_flag[i] = long_codes_flag[j] = 1;
        match_count++;
        break;
      }
    }
  }

  if(!match_count) return 0.0;

  // count number of transpositions
  size_t transposition_count = 0, j = 0, k = 0;
  for(size_t i = 0; i < short_codes_len; i++){
    if(short_codes_flag[i]){
      for(j = k; j < long_codes_len; j++){
        if(long_codes_flag[j]){
          k = j + 1;
          break;
        }
      }
      if(short_codes[i] != long_codes[j]) transposition_count++;
    }
  }

  // count similarities in nonmatched characters
  size_t similar_count = 0;
  if(opt->adj_table && short_codes_len > match_count)
    for(size_t i = 0; i < short_codes_len; i++)
      if(!short_codes_flag[i])
        for(size_t j = 0; j < long_codes_len; j++)
          if(!long_codes_flag[j])
            if(adj_matrix_find(adj_matrix_default(), short_codes[i], long_codes[j])){
              similar_count += 3;
              break;
            }

  double m = (double)match_count;
  double t = (double)(transposition_count/2);
  if(opt->adj_table) m = similar_count/10.0 + m;
  return (m/short_codes_len + m/long_codes_len + (m-t)/m) / 3;
}

double jaro_winkler_distance_from_codes(uint64_t* short_codes, size_t short_codes_len, uint64_t* long_codes, size_t long_codes_len, LibJaroOption *opt){
  double jaro_distance = jaro_distance_from_codes(short_codes, short_codes_len, long_codes, long_codes_len, opt);

  if(jaro_distance < opt->threshold) return jaro_distance;
  else{
    size_t prefix = 0;
    size_t max_4 = short_codes_len > 4 ? 4 : short_codes_len;
    for(prefix = 0; prefix < max_4 && short_codes[prefix] == long_codes[prefix]; prefix++);
    return jaro_distance + prefix*opt->weight*(1-jaro_distance);
  }
}
