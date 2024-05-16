# frozen_string_literal: true

require File.expand_path('../samples', __FILE__)
gem 'jaro_winkler', ENV['JARO_WINKLER_VERSION'] || ARGV[0] || raise('missing ENV["JARO_WINKLER_VERSION"]')
require 'benchmark'
require 'csv'

csv = CSV.new($stdout)
n = 100_000
version = Gem::Version.new(Gem.loaded_specs["jaro_winkler"].version)

if version >= Gem::Version.new('1.1.0') && version < Gem::Version.new('1.2.4')
  require 'jaro_winkler.bundle'
else
  require 'jaro_winkler'
end

jobs = {
  ascii: -> { n.times { SAMPLES[:ascii].each { |str1, str2| JaroWinkler.jaro_winkler_distance(str1, str2) } } }
}

if version >= Gem::Version.new('1.1.0')
  jobs[:ascii] = -> { n.times { SAMPLES[:ascii].each { |str1, str2| JaroWinkler.c_distance(str1, str2) } } }
end

if version >= Gem::Version.new('1.2.0')
  jobs[:utf8] = -> { n.times { SAMPLES[:utf8].each { |str1, str2| JaroWinkler.c_distance(str1, str2) } } }
end

if version >= Gem::Version.new('1.4.0')
  jobs[:ascii] = -> { n.times { SAMPLES[:ascii].each { |str1, str2| JaroWinkler.similarity(str1, str2) } } }
  jobs[:utf8] = -> { n.times { SAMPLES[:utf8].each { |str1, str2| JaroWinkler.similarity(str1, str2) } } }
end

# rehearsal

jobs.each { |label, job| Benchmark.measure(label, &job) }

# take

jobs.each do |label, job|
  GC.start
  tms = Benchmark.measure(label, &job)
  # version,label,utime,stime,cutime,cstime,real
  csv << [version, *tms.to_a]
end
