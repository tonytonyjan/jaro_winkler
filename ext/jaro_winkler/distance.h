#ifndef DISTANCE_H
#define DISTANCE_H 1

typedef struct{
  char ignore_case;
  double weight, threshold;
} Option;

double      c_distance(char *s1, int byte_len1, char *s2, int byte_len2, Option opt);
Option      option_new();

#endif /* DISTANCE_H */
