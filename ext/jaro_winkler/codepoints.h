#ifndef CODEPOINTS_H
#define CODEPOINTS_H 1

#include <stdint.h>

typedef uint16_t UnicodeCharCode;

typedef struct{
  UnicodeCharCode code;		/* UTF-16 representation of a unicode character */
  unsigned int byte_length;	/* how many bytes of UTF-8 encoding it came from */
} UnicodeHash;

typedef struct{
  UnicodeCharCode *ary;
  int length;
} Codepoints;

/**
 * Convert a single UTF-8 character into its UTF-16
 * equivalent. The UTF-8 representation of one
 * UTF-16 character can take 1-4 bytes.
 */
UnicodeHash unicode_hash_new(const char *str);

/**
 * Convert str in UTF-8 encoding to a string in UTF-16 encoding.
 */ 
Codepoints  codepoints_new  (const char *str, int byte_len);

#endif /* CODEPOINTS_H */
