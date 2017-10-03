# frozen_string_literal: true

require File.expand_path('../env', __FILE__)
require 'jaro_winkler'
require 'benchmark'
require 'csv'

csv = CSV.new($stdout)
n = 100_000

jobs = case JaroWinkler::VERSION
when /\A1\.1/
  {
    ascii: -> { n.times { SAMPLES[:ascii].each { |str1, str2| JaroWinkler.c_distance(str1, str2) } } }
  }
when /\A1\.[2-3]/
  {
    ascii: -> { n.times { SAMPLES[:ascii].each { |str1, str2| JaroWinkler.c_distance(str1, str2) } } },
    utf8: -> { n.times { SAMPLES[:utf8].each { |str1, str2| JaroWinkler.c_distance(str1, str2) } } }
  }
else
  {
    ascii: -> { n.times { SAMPLES[:ascii].each { |str1, str2| JaroWinkler.distance(str1, str2) } } },
    utf8: -> { n.times { SAMPLES[:utf8].each { |str1, str2| JaroWinkler.distance(str1, str2) } } }
  }
end

# rehearsal

jobs.each { |label, job| Benchmark.measure(label, &job) }

# take

jobs.each do |label, job|
  GC.start
  tms = Benchmark.measure(label, &job)
  # version,label,utime,stime,cutime,cstime,real
  csv << [JaroWinkler::VERSION, *tms.to_a]
end
