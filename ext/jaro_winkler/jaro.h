#pragma once

#include <stddef.h>

#define DEFAULT_WEIGHT 0.1
#define DEFAULT_THRESHOLD 0.7

typedef struct LibJaroOption{
  double weight, threshold;
  char ignore_case, adj_table;
} LibJaroOption;


extern const LibJaroOption DEFAULT_OPT;
double jaro_distance(char *str1, size_t len1, char *str2, size_t len2, LibJaroOption *opt);
double jaro_winkler_distance(char *str1, size_t len1, char *str2, size_t len2, LibJaroOption *opt);
