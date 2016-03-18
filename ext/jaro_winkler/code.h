#pragma once

void utf_char_to_code(char *str, unsigned long long *ret_code, int *ret_byte_length);
void string_to_codes(char *str, int length, unsigned long long **ret_codes, int *ret_length);