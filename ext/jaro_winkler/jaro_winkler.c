#include "jaro_winkler.h"
#include "distance.h"

VALUE rb_mJaroWinkler;

void Init_jaro_winkler(void){
  rb_mJaroWinkler = rb_define_module("JaroWinkler");
  rb_define_module_function(rb_mJaroWinkler, "c_distance", rb_distance, -1);
}

static VALUE rb_distance(int argc, VALUE *argv, VALUE self){
  VALUE s1, s2, opt;
  rb_scan_args(argc, argv, "2:", &s1, &s2, &opt);
  // RSTRING_LEN
  return rb_float_new(c_distance(StringValueCStr(s1), StringValueCStr(s2)));
}