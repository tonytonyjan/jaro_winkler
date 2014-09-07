#include "jaro_winkler.h"
#define MAX(X,Y) ((X) < (Y) ? (Y) : (X))
VALUE rb_mJaroWinkler;

static VALUE distance(VALUE self, VALUE s1, VALUE s2){
  Check_Type(s1, T_STRING); Check_Type(s2, T_STRING);
  // Check encoding
  VALUE s1_ascii_only = TYPE(rb_funcall(s1, rb_intern("ascii_only?"), 0));
  VALUE s2_ascii_only = TYPE(rb_funcall(s2, rb_intern("ascii_only?"), 0));
  if(s1_ascii_only == T_FALSE || s2_ascii_only == T_FALSE) printf("WARNING: Non-ASCII string detected.\n");

  VALUE *s1_ptr = &s1, *s2_ptr = &s2;
  // guarantee the length of s1_ptr is less than or equal to that of s2_ptr
  if(RSTRING_LEN(s1) > RSTRING_LEN(s2)){ VALUE *tmp = s1_ptr; s1_ptr = s2_ptr; s2_ptr = tmp; }
  int min_length = RSTRING_LEN(*s1_ptr), max_length   = RSTRING_LEN(*s2_ptr);
  char *c_s1_ptr = StringValuePtr(*s1_ptr), *c_s2_ptr = StringValuePtr(*s2_ptr);
  int opt[] = {1, 0};
  if(min_length != max_length){
    // padding spaces
    char buf[max_length];
    for(int i = min_length; i < max_length; ++i) buf[i] = ' ';
    memcpy(buf, c_s1_ptr, min_length);
    c_s1_ptr = buf;
    return rb_float_new(strcmp95(c_s1_ptr, c_s2_ptr, max_length, opt));
  }
  return rb_float_new(strcmp95(c_s1_ptr, c_s2_ptr, max_length, opt));
}

void Init_jaro_winkler(void){
  rb_mJaroWinkler = rb_define_module("JaroWinkler");
  rb_define_module_function(rb_mJaroWinkler, "c_distance", distance, 2);
}
