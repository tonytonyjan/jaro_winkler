module JaroWinkler
  module_function
  def fallback?
    RUBY_PLATFORM == 'java'
  end
end