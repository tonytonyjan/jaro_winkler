#ifndef CODEPOINTS_H
#define CODEPOINTS_H 1

typedef struct{
  unsigned long long code;
  unsigned int byte_length;
} UnicodeHash;

typedef struct{
  unsigned long long *ary;
  int length;
} Codepoints;

UnicodeHash unicode_hash_new(const char *str);
Codepoints  codepoints_new  (const char *str, int byte_len);

#endif /* CODEPOINTS_H */
