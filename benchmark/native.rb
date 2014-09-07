require 'benchmark'
require 'jaro_winkler'
require 'fuzzystringmatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 1000000
Benchmark.bm do |x|
  x.report 'jaro_winkler    ' do
    n.times{ ary.each{ |str1, str2| JaroWinkler.c_distance(str1, str2) } }
  end

  x.report 'fuzzystringmatch' do
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end
end

#        user     system      total        real
# jaro_winkler      2.770000   0.000000   2.770000 (  2.769094)
# fuzzystringmatch  1.610000   0.020000   1.630000 (  1.639039)