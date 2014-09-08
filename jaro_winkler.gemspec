# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jaro_winkler/fallback'
require 'jaro_winkler/version'

Gem::Specification.new do |spec|
  spec.name          = "jaro_winkler"
  spec.version       = JaroWinkler::VERSION
  spec.authors       = ["Jian Weihang"]
  spec.email         = ["tonytonyjan@gmail.com"]
  spec.extensions    = ["ext/jaro_winkler/extconf.rb"] unless JaroWinkler.fallback?
  spec.summary       = %q{Ruby & C implementation of Jaro-Winkler distance algorithm which both support UTF-8 string.}
  spec.description   = %q{It's a implementation of Jaro-Winkler distance algorithm, it uses C extension and will fallback to pure Ruby version in JRuby. Both implementation supports UTF-8 string.}
  spec.homepage      = "https://github.com/tonytonyjan/jaro_winkler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
end
