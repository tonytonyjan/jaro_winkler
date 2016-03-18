#pragma once
#define ADJ_MATRIX_DEFAULT_LENGTH 958
#define ADJ_MATRIX_SEED 9527

typedef struct _node{
  struct _node *next;
  unsigned long long x, y;
} Node;

typedef struct{
  Node ***table;
  unsigned int length;
} AdjMatrix;

AdjMatrix* adj_matrix_new    (unsigned int length);
void       adj_matrix_add    (AdjMatrix *matrix, unsigned long long x, unsigned long long y);
char       adj_matrix_find   (AdjMatrix *matrix, unsigned long long x, unsigned long long y);
void       adj_matrix_free   (AdjMatrix *matrix);
AdjMatrix* adj_matrix_default();