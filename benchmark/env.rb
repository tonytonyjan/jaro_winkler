# frozen_string_literal: true

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'bundler'
Bundler.setup(:benchmark)
require 'samples'

def gem_name_with_version(gem)
  "#{gem} (#{Gem.loaded_specs[gem].version})"
end
