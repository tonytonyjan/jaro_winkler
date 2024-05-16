# frozen_string_literal: true

require File.expand_path('../env', __FILE__)
require 'benchmark'
require 'jaro_winkler/jaro_winkler_ext'
require 'fuzzystringmatch'
require 'hotwater'
require 'amatch'

n = 100_000

Benchmark.bmbm do |x|
  x.report "jaro_winkler (#{`git rev-parse --short HEAD`.chop!})" do
    n.times { SAMPLES[:ascii].each { |str1, str2| JaroWinkler.similarity(str1, str2) } }
  end

  x.report gem_name_with_version('fuzzy-string-match') do
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    n.times { SAMPLES[:ascii].each { |str1, str2| jarow.getDistance(str1, str2) } }
  end

  x.report gem_name_with_version('hotwater') do
    n.times { SAMPLES[:ascii].each { |str1, str2| Hotwater.jaro_winkler_distance(str1, str2) } }
  end

  x.report gem_name_with_version('amatch') do
    n.times { SAMPLES[:ascii].each { |str1, str2| Amatch::Jaro.new(str1).match(str2) } }
  end
end
