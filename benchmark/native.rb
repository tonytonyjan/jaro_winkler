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
# jaro_winkler       0.370000   0.000000   0.370000 (  0.370106)
# fuzzystringmatch   0.140000   0.000000   0.140000 (  0.147716)
# hotwater           0.280000   0.000000   0.280000 (  0.284125)
# amatch             0.950000   0.000000   0.950000 (  0.958045)