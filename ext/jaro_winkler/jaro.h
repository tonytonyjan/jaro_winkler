#pragma once

#include <stddef.h>

#define DEFAULT_WEIGHT 0.1
#define DEFAULT_THRESHOLD 0.7

typedef struct LibJaroOption{
  double weight, threshold;
  char ignore_case, adj_table;
} LibJaroOption;


static const LibJaroOption DEFAULT_OPT = {.weight = DEFAULT_WEIGHT, .threshold = DEFAULT_THRESHOLD, .ignore_case = 0, .adj_table = 0};
double jaro_distance(char *str1, size_t len1, char *str2, size_t len2, LibJaroOption *opt);
double jaro_winkler_distance(char *str1, size_t len1, char *str2, size_t len2, LibJaroOption *opt);
