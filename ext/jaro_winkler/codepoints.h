#pragma once
#include <stdint.h>
#include <stddef.h>
#include "ruby.h"

typedef struct {
  uint32_t *data;
  size_t length;
  size_t size;
} CodePoints;

void codepoints_init(CodePoints*, VALUE str);
void codepoints_free(CodePoints*);
