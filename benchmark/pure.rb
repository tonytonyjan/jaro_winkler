require 'benchmark'
require 'jaro_winkler'
require 'fuzzystringmatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 100000
Benchmark.bm do |x|
  x.report 'jaro_winkler    ' do
    n.times{ ary.each{ |str1, str2| JaroWinkler.distance(str1, str2) } }
  end

  x.report 'fuzzystringmatch' do
    jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end
end

#        user     system      total        real
# jaro_winkler     13.090000   0.020000  13.110000 ( 13.132467)
# fuzzystringmatch 15.040000   0.010000  15.050000 ( 15.054266)