require 'rubygems/package_task'
require 'rake/extensiontask'
require 'rake/testtask'

task default: [:compile, :test]

task benchmark: %w[benchmark:native benchmark:pure]

task :print_time do
  puts Time.now.utc
  puts
end

namespace :benchmark do
  task :native => :print_time do |t, args|
    puts '# C Extension'
    load File.expand_path("../benchmark/native.rb", __FILE__)
    puts
  end

  task :pure => :print_time do |t, args|
    puts '# Pure Ruby'
    load File.expand_path("../benchmark/pure.rb", __FILE__)
    puts
  end
end

task compare: :compile do
  require 'jaro_winkler'
  require 'fuzzystringmatch'
  require 'hotwater'
  require 'amatch'
  @ary = [['henka', 'henkan'], ['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten'], ['San Francisco', 'Santa Monica']]
  table = []
  table << %w[str_1 str_2 jaro_winkler fuzzystringmatch hotwater amatch]
  table << %w[--- --- --- --- --- ---]
  jarow = FuzzyStringMatch::JaroWinkler.create(:native)
  @ary.each do |str_1, str_2|
    table << ["\"#{str_1}\"", "\"#{str_2}\"", JaroWinkler.distance(str_1, str_2).round(4), jarow.getDistance(str_1, str_2).round(4), Hotwater.jaro_winkler_distance(str_1, str_2).round(4), Amatch::Jaro.new(str_1).match(str_2).round(4)]
  end
  col_len = []
  table.first.length.times{ |i| col_len << table.map{ |row| row[i].to_s.length }.max }
  table.first.each_with_index{ |title, i| "%-#{col_len[i]}s" % title }
  table.each_with_index do |row|
    row.each_with_index do |col, i|
      row[i] = "%-#{col_len[i]}s" % col.to_s
    end
  end
  table.each{|row| puts row.join(' | ')}
end

if RUBY_PLATFORM == 'java'
  task :compile do
    puts 'Can not compile C extension, fallback to pure Ruby version.'
  end
else
  Rake::ExtensionTask.new 'jaro_winkler_ext' do |ext|
    ext.lib_dir = 'lib/jaro_winkler'
    ext.ext_dir = 'ext/jaro_winkler'
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

spec = Gem::Specification.load(File.expand_path('../jaro_winkler.gemspec', __FILE__))
Gem::PackageTask.new(spec).define
