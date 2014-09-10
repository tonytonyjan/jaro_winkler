#include "jaro_winkler.h"
#include "distance.h"

VALUE rb_mJaroWinkler;

void Init_jaro_winkler(void){
  rb_mJaroWinkler = rb_define_module("JaroWinkler");
  rb_define_module_function(rb_mJaroWinkler, "c_distance", rb_distance, -1);
}

VALUE rb_distance(int argc, VALUE *argv, VALUE self){
  VALUE s1, s2, opt;
  rb_scan_args(argc, argv, "2:", &s1, &s2, &opt);
  Option c_opt = option_new();
  if(TYPE(opt) == T_HASH){
    VALUE weight      = rb_hash_aref(opt, ID2SYM(rb_intern("weight")));
    VALUE threshold   = rb_hash_aref(opt, ID2SYM(rb_intern("threshold")));
    VALUE ignore_case = rb_hash_aref(opt, ID2SYM(rb_intern("ignore_case")));
    VALUE adj_table   = rb_hash_aref(opt, ID2SYM(rb_intern("adj_table")));
    if(!NIL_P(weight)) c_opt.weight = NUM2DBL(weight);
    if(c_opt.weight > 0.25) rb_raise(rb_eRuntimeError, "Scaling factor should not exceed 0.25, otherwise the distance can become larger than 1.");
    if(!NIL_P(threshold)) c_opt.threshold     = NUM2DBL(threshold);
    if(!NIL_P(ignore_case)) c_opt.ignore_case = (TYPE(ignore_case)  == T_FALSE || NIL_P(ignore_case)) ? 0 : 1;
    if(!NIL_P(adj_table)) c_opt.adj_table     = (TYPE(adj_table)    == T_FALSE || NIL_P(adj_table))   ? 0 : 1;
  }
  return rb_float_new(c_distance(StringValuePtr(s1), RSTRING_LEN(s1), StringValuePtr(s2), RSTRING_LEN(s2), c_opt));
}