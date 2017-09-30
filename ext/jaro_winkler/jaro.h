#pragma once

#include <stddef.h>
#include <stdint.h>

typedef struct LibJaroOption{
  double weight, threshold;
  char ignore_case, adj_table;
} LibJaroOption;

extern const LibJaroOption DEFAULT_OPT;

double jaro_distance_from_codes(uint32_t* short_codes, size_t short_codes_len, uint32_t* long_codes, size_t long_codes_len, LibJaroOption *opt);
double jaro_winkler_distance_from_codes(uint32_t* short_codes, size_t short_codes_len, uint32_t* long_codes, size_t long_codes_len, LibJaroOption *opt);
