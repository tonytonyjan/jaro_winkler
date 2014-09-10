#ifndef DISTANCE_H
#define DISTANCE_H 1

typedef struct{
  double weight, threshold;
  char ignore_case, adj_table;
} Option;

double      c_distance(char *s1, int s1_byte_len, char *s2, int s2_byte_len, Option opt);
Option      option_new();

#endif /* DISTANCE_H */
