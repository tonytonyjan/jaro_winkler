require 'benchmark'
require 'jaro_winkler'
require 'fuzzystringmatch'
require 'hotwater'
require 'amatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 100000
Benchmark.bmbm do |x|
  x.report 'jaro_winkler' do
    n.times{ ary.each{ |str1, str2| JaroWinkler.c_distance(str1, str2) } }
  end

  x.report 'fuzzystringmatch' do
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end

  x.report 'hotwater' do
    n.times{ ary.each{ |str1, str2| Hotwater.jaro_winkler_distance(str1, str2) } }
  end

  x.report 'amatch' do
    n.times{ ary.each{ |str1, str2| Amatch::Jaro.new(str1).match(str2) } }
  end
end

#                        user     system      total        real
# jaro_winkler       0.420000   0.000000   0.420000 (  0.426742)
# fuzzystringmatch   0.160000   0.000000   0.160000 (  0.160146)
# hotwater           0.300000   0.000000   0.300000 (  0.297350)
# amatch             0.980000   0.010000   0.990000 (  0.982874)