#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "ruby.h"
#include "ruby/encoding.h"
#include "code.h"

void codepoints_init(CodePoints *codepoints, VALUE str){
  int32_t n;
  uint32_t c;
  const char *ptr, *end;
  rb_encoding *enc;

  codepoints->length = 0;
  codepoints->size = 32;
  codepoints->data = malloc(codepoints->size * sizeof(*codepoints->data));
  str = rb_str_new_frozen(str);
  ptr = RSTRING_PTR(str);
  end = RSTRING_END(str);
  enc = rb_enc_get(str);

  while (ptr < end) {
  	c = rb_enc_codepoint_len(ptr, end, &n, enc);
    if(codepoints->length == codepoints->size) {
      codepoints->size *= 2;
      codepoints->data = realloc(codepoints->data, sizeof(*codepoints->data) * codepoints->size);
    }
    codepoints->data[codepoints->length++] = c;
  	ptr += n;
  }
  RB_GC_GUARD(str);
}


void codepoints_free(CodePoints *codepoints) {
  free(codepoints->data);
}
