#pragma once
#include <stdint.h>
#include <stddef.h>

void utf_char_to_code(char *str, uint64_t *ret_code, size_t *ret_byte_length);
void string_to_codes(char *str, size_t length, uint64_t **ret_codes, size_t *ret_length);
