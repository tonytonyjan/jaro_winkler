require "bundler/gem_tasks"

require "rake/extensiontask"

Rake::ExtensionTask.new("jaro_winkler") do |ext|
  ext.lib_dir = "lib/jaro_winkler"
end

task :benchmark do
  ROOT_PATH = File.expand_path('..', __FILE__)
  LIB_PATH = File.join(ROOT_PATH, 'lib')
  BENCHMARK_PATH = File.join(ROOT_PATH, 'benchmark')
  Dir[File.join(BENCHMARK_PATH, '*.rb')].each do |path|
    output_path = File.join(BENCHMARK_PATH, File.basename(path, '*.rb').sub('.rb', '.txt'))
    cmd = "RUBYLIB=#{LIB_PATH} ruby #{path} > #{output_path}"
    puts cmd
    system(cmd)
  end
end