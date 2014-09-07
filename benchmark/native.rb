require 'benchmark'
require 'jaro_winkler'
require 'fuzzystringmatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 100000
Benchmark.bmbm do |x|
  x.report '#c_distance(s1, s2)' do
    n.times{ ary.each{ |str1, str2| JaroWinkler.c_distance(str1, str2) } }
  end

  x.report '#distance(s1, s2, native: true)' do
    n.times{ ary.each{ |str1, str2| JaroWinkler.distance(str1, str2, native: true) } }
  end

  x.report 'fuzzystringmatch' do
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end
end

#                                       user     system      total        real
# #c_distance(s1, s2)               0.350000   0.000000   0.350000 (  0.349109)
# #distance(s1, s2, native: true)   2.480000   0.050000   2.530000 (  2.526027)
# fuzzystringmatch                  0.160000   0.000000   0.160000 (  0.155539)