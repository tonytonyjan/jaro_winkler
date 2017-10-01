# frozen_string_literal: true

require File.expand_path('../env', __FILE__)
require 'benchmark'
require 'jaro_winkler/jaro_winkler_pure'
require 'fuzzystringmatch'

ary = [
  %w[al al], %w[martha marhta], %w[jones johnson], %w[abcvwxyz cabvwxyz],
  %w[dwayne duane], %w[dixon dicksonx], %w[fvie ten]
]

n = 10_000

Benchmark.bmbm do |x|
  x.report "jaro_winkler (#{`git rev-parse --short HEAD`.chop!})" do
    n.times { ary.each { |str1, str2| JaroWinkler.distance(str1, str2) } }
  end

  x.report gem_name_with_version('fuzzy-string-match') do
    jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    n.times { ary.each { |str1, str2| jarow.getDistance(str1, str2) } }
  end
end
