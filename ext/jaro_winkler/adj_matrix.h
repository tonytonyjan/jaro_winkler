#ifndef ADJ_MATRIX_H
#define ADJ_MATRIX_H 1
#include "codepoints.h"
#define ADJ_MATRIX_DEFAULT_LENGTH 958
#define ADJ_MATRIX_SEED 9527

typedef struct _node{
  struct _node *next;
  UnicodeCharCode x, y;
} Node;

typedef struct{
  Node ***table;
  unsigned int length;
} AdjMatrix;

AdjMatrix* adj_matrix_new    (unsigned int length);
void       adj_matrix_add    (AdjMatrix *matrix, UnicodeCharCode x, UnicodeCharCode y);
char       adj_matrix_find   (AdjMatrix *matrix, UnicodeCharCode x, UnicodeCharCode y);
void       adj_matrix_free   (AdjMatrix *matrix);
AdjMatrix* adj_matrix_default();

#endif /* ADJ_MATRIX_H */
