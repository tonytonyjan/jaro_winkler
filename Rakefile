require "bundler/gem_tasks"
require "rake/extensiontask"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
Rake::ExtensionTask.new("jaro_winkler") do |ext|
  ext.lib_dir = "lib/jaro_winkler"
end

task default: :spec

desc 'type can be "native" or "pure"'
task :benchmark, :type do |t, args|
  args.with_defaults(type: :all)
  ROOT_PATH = File.expand_path('..', __FILE__)
  LIB_PATH = File.join(ROOT_PATH, 'lib')
  BENCHMARK_PATH = File.join(ROOT_PATH, 'benchmark')

  files = File.join(BENCHMARK_PATH, args[:type] == :all ? '*.rb' : "#{args[:type]}.rb")
  Dir[files].each do |path|
    output_path = File.join(BENCHMARK_PATH, File.basename(path, '*.rb').sub('.rb', '.txt'))
    cmd = "RUBYLIB=#{LIB_PATH} ruby #{path}"
    puts cmd
    output = `#{cmd}`
    File.write(output_path, output)
  end
end

task :compare do
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