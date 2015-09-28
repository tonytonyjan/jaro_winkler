#ifndef LIBJARO_JARO_H
#define LIBJARO_JARO_H

#define SWAP(x, y) do{ __typeof__(x) SWAP = x; x = y; y = SWAP; }while(0)
#define DEFAULT_WEIGHT 0.1
#define DEFAULT_THRESHOLD 0.7

typedef struct LibJaroOption{
  double weight, threshold;
  char ignore_case, adj_table;
} LibJaroOption;

double jaro_winkler_distance(char *str1, int len1, char *str2, int len2, LibJaroOption *opt);

#endif