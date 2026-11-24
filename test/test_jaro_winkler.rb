require 'minitest/autorun'
require_relative 'tests'
require 'jaro_winkler/jaro_winkler_ext'

class TestJaroWinkler < Minitest::Test
  include Tests

  # The match buffers used to be stack-allocated (alloca) with a size taken
  # from the input length, so a long enough string would overflow the small
  # native stack of a Thread or Fiber. They are now heap-allocated, so stack
  # usage stays constant. Use an asymmetric input (one tiny string) to keep
  # the comparison fast while the combined length far exceeds a Thread's
  # ~1 MiB native stack.
  def test_long_input_does_not_overflow_native_stack
    long = 'b' * 4_000_000
    result = Thread.new { JaroWinkler.jaro_similarity('a', long) }.value
    assert_in_delta 0.0, result
  end
end
