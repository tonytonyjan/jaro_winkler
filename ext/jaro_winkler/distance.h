#ifndef DISTANCE_H
#define DISTANCE_H 1

typedef struct{
  char case_match;
  double weight, threshold;
} Option;

double c_distance(char *s1, char *s2, Option *opt);
Option* option_new();

#endif /* DISTANCE_H */