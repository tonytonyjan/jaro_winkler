# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jaro_winkler/version'

Gem::Specification.new do |spec|
  spec.name = 'jaro_winkler'
  spec.version = JaroWinkler::VERSION
  spec.authors = ['Jian Weihang']
  spec.email = 'tonytonyjan@gmail.com'
  spec.extensions = ['ext/jaro_winkler/extconf.rb']
  spec.summary = 'An implementation of Jaro-Winkler distance algorithm written \
  in C extension which supports any kind of string encoding.'
  spec.description = 'jaro_winkler is an implementation of Jaro-Winkler \
  distance algorithm which is written in C extension and will fallback to pure \
  Ruby version in platforms other than MRI/KRI like JRuby or Rubinius. Both of \
  C and Ruby implementation support any kind of string encoding, such as \
  UTF-8, EUC-JP, Big5, etc.'
  spec.homepage = 'https://github.com/tonytonyjan/jaro_winkler'
  spec.license = 'MIT'
  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/tonytonyjan/jaro_winkler/issues',
    'changelog_uri' => "https://github.com/tonytonyjan/jaro_winkler/blob/v#{spec.version}/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/jaro_winkler/#{spec.version}",
    'source_code_uri' => "https://github.com/tonytonyjan/jaro_winkler/tree/v#{spec.version}",
  }
  spec.files = Dir['lib/**/*.rb', 'ext/**/*.{h,c}', 'LICENSE.txt']
  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'minitest'
end
