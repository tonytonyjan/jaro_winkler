#include "ruby.h"
#include "jaro.h"

VALUE rb_mJaroWinkler,
      rb_eError,
      rb_eInvalidWeightError;

VALUE rb_jaro_winkler_distance(int argc, VALUE *argv, VALUE self);
VALUE rb_jaro_distance(int argc, VALUE *argv, VALUE self);
VALUE distance(int argc, VALUE *argv, VALUE self, double (*distance_fn)(char *str1, int len1, char *str2, int len2, LibJaroOption *opt));

void Init_jaro_winkler_ext(void){
  rb_mJaroWinkler = rb_define_module("JaroWinkler");
  rb_eError = rb_define_class_under(rb_mJaroWinkler, "Error", rb_eRuntimeError);
  rb_eInvalidWeightError = rb_define_class_under(rb_mJaroWinkler, "InvalidWeightError", rb_eError);
  rb_define_singleton_method(rb_mJaroWinkler, "distance", rb_jaro_winkler_distance, -1);
  rb_define_singleton_method(rb_mJaroWinkler, "jaro_distance", rb_jaro_distance, -1);
}


VALUE distance(int argc, VALUE *argv, VALUE self, double (*distance_fn)(char *str1, int len1, char *str2, int len2, LibJaroOption *opt)){
  VALUE s1, s2, opt;
  rb_scan_args(argc, argv, "2:", &s1, &s2, &opt);
  LibJaroOption c_opt = DEFAULT_OPT;
  if(TYPE(opt) == T_HASH){
    VALUE weight = rb_hash_aref(opt, ID2SYM(rb_intern("weight"))),
          threshold = rb_hash_aref(opt, ID2SYM(rb_intern("threshold"))),
          ignore_case = rb_hash_aref(opt, ID2SYM(rb_intern("ignore_case"))),
          adj_table = rb_hash_aref(opt, ID2SYM(rb_intern("adj_table")));
    if(!NIL_P(weight)) c_opt.weight = NUM2DBL(weight);
    if(c_opt.weight > 0.25) rb_raise(rb_eInvalidWeightError, "Scaling factor should not exceed 0.25, otherwise the distance can become larger than 1.");
    if(!NIL_P(threshold)) c_opt.threshold = NUM2DBL(threshold);
    if(!NIL_P(ignore_case)) c_opt.ignore_case = (TYPE(ignore_case) == T_FALSE || NIL_P(ignore_case)) ? 0 : 1;
    if(!NIL_P(adj_table)) c_opt.adj_table = (TYPE(adj_table) == T_FALSE || NIL_P(adj_table)) ? 0 : 1;
  }
  return rb_float_new((*distance_fn)(StringValuePtr(s1), RSTRING_LEN(s1), StringValuePtr(s2), RSTRING_LEN(s2), &c_opt));
}

VALUE rb_jaro_distance(int argc, VALUE *argv, VALUE self){
  return distance(argc, argv, self, jaro_distance);
}

VALUE rb_jaro_winkler_distance(int argc, VALUE *argv, VALUE self){
  return distance(argc, argv, self, jaro_winkler_distance);
}
