require 'minitest/autorun'
require_relative 'tests'
require 'jaro_winkler/jaro_winkler_pure'

class TestJaroWinkler < Minitest::Test
  include Tests
end
