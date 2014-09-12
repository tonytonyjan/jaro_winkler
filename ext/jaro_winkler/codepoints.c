#include <string.h>
#include <stdlib.h>
#include "codepoints.h"

UnicodeHash unicode_hash_new(const char *str){
  UnicodeHash ret = {};
  unsigned char first_char = str[0];
  if(first_char >= 252) ret.byte_length = 6;      // 1111110x
  else if(first_char >= 248) ret.byte_length = 5; // 111110xx
  else if(first_char >= 240) ret.byte_length = 4; // 11110xxx
  else if(first_char >= 224) ret.byte_length = 3; // 1110xxxx
  else if(first_char >= 192) ret.byte_length = 2; // 110xxxxx
  else ret.byte_length = 1;
  memcpy(&ret.code, str, ret.byte_length);
  return ret;
}

Codepoints codepoints_new(const char *str, int byte_len){
  Codepoints ret = {};
  ret.ary = malloc(byte_len * sizeof(long long));
  ret.length = 0;
  for(int i = 0; i < byte_len;){
    UnicodeHash hash = unicode_hash_new(str + i);
    ret.ary[ret.length] = hash.code;
    ret.length++;
    i += hash.byte_length;
  }
  return ret;
}