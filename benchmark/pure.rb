require 'benchmark'
require 'jaro_winkler'
require 'fuzzystringmatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 100000
Benchmark.bmbm do |x|
  x.report 'jaro_winkler' do
    n.times{ ary.each{ |str1, str2| JaroWinkler.r_distance(str1, str2) } }
  end

  x.report 'fuzzystringmatch' do
    jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end
end

#                        user     system      total        real
# jaro_winkler      12.480000   0.010000  12.490000 ( 12.497828)
# fuzzystringmatch  14.990000   0.010000  15.000000 ( 15.014898)