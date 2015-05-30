#include <string.h>
#include <stdlib.h>
#include "codepoints.h"

/**
 * Convert a single UTF-8 character (possiblity in multiple bytes
 * to a single UTF-16 character. This implementation is based
 * on the following article: http://en.wikipedia.org/wiki/UTF-8.
 * According to RFC 3629 UTF-8 maps into U+0000..U+10FFFF,
 * the UTF-16 compatible characters, and it can only have up
 * to 4 UTF-8 bytes per UTF-16 character.
 */
UnicodeHash unicode_hash_new(const char *str){
  UnicodeHash ret = { 0u, 0u };
  const unsigned char first_char = (unsigned char)str[0];
  if ((first_char & 0x80) && (first_char & 0x40)) {
    if (first_char & 0x20) {
      if (first_char & 0x10) { // four bytes
	ret.code = ((str[1] & 0x3f) << 12) | ((str[2] & 0x3f) << 6) | (str[3] & 0x3f);
	ret.byte_length = 4;
      }
      else {
	ret.code = ((first_char & 0x0f) << 12) | ((str[1] & 0x3f) << 6) | (str[2] & 0x3f);
	ret.byte_length = 3;
      }
    }
    else {
      ret.code = ((first_char & 0x1f) << 6) | (str[1] & 0x3f);
      ret.byte_length = 2;
    }
  }
  else {
    ret.code = first_char & 0X7f;
    ret.byte_length = 1;
  }
  return ret;
}

/**
 * Convert a string in UTF-8 to an equivalent string in UTF-16.
 */
Codepoints codepoints_new(const char *str, int byte_len){
  Codepoints ret = {};
  ret.ary = malloc(byte_len * sizeof(UnicodeCharCode)); /* conservative */
  ret.length = 0;
  for(int i = 0; i < byte_len;){
    UnicodeHash hash = unicode_hash_new(str + i);
    ret.ary[ret.length] = hash.code;
    ++ret.length;
    i += hash.byte_length;
  }
  return ret;
}
