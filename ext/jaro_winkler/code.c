#include <stdint.h>
#include <stdlib.h>
#include <string.h>

void utf_char_to_code(char *str, uint64_t *ret_code, size_t *ret_byte_length){
  unsigned char first_char = str[0];
  if(first_char >= 252) *ret_byte_length = 6;      // 1111110x
  else if(first_char >= 248) *ret_byte_length = 5; // 111110xx
  else if(first_char >= 240) *ret_byte_length = 4; // 11110xxx
  else if(first_char >= 224) *ret_byte_length = 3; // 1110xxxx
  else if(first_char >= 192) *ret_byte_length = 2; // 110xxxxx
  else *ret_byte_length = 1;
  *ret_code = 0;
  memcpy(ret_code, str, *ret_byte_length);
}

void string_to_codes(char *str, size_t length, uint64_t **ret_codes, size_t *ret_length){
  uint32_t code;
  char byte_length;

  *ret_codes = calloc(length, sizeof(long long));
  *ret_length = 0;

  for(size_t i = 0; i < length;){
    size_t byte_length;
    utf_char_to_code(&str[i], &(*ret_codes)[*ret_length], &byte_length);
    *ret_length += 1;
    i += byte_length;
  }
}
