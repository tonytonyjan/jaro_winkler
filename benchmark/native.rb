require 'benchmark'
require 'jaro_winkler'
require 'fuzzystringmatch'
require 'hotwater'
require 'amatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 100000
Benchmark.bmbm do |x|
  x.report "jaro_winkler #{Gem.loaded_specs['jaro_winkler'].version}" do
    n.times{ ary.each{ |str1, str2| JaroWinkler.c_distance(str1, str2) } }
  end

  x.report "fuzzystringmatch #{Gem.loaded_specs['fuzzy-string-match'].version}" do
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end

  x.report "hotwater #{Gem.loaded_specs['hotwater'].version}" do
    n.times{ ary.each{ |str1, str2| Hotwater.jaro_winkler_distance(str1, str2) } }
  end

  x.report "amatch #{Gem.loaded_specs['amatch'].version}" do
    n.times{ ary.each{ |str1, str2| Amatch::Jaro.new(str1).match(str2) } }
  end
end
