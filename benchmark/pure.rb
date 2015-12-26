require 'jaro_winkler/jaro_winkler_pure'
require 'jaro_winkler/version'
require 'benchmark'
require 'fuzzystringmatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 10000
Benchmark.bmbm do |x|
  x.report "jaro_winkler #{JaroWinkler::VERSION}" do
    n.times{ ary.each{ |str1, str2| JaroWinkler.distance(str1, str2) } }
  end

  x.report "fuzzystringmatch #{Gem.loaded_specs['fuzzy-string-match'].version}" do
    jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end
end
