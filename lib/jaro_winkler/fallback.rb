module JaroWinkler
  module_function
  def fallback?
    # TODO: Make windows compilable.
    RUBY_PLATFORM == 'java' || RUBY_PLATFORM == /cygwin|mswin|mingw|bccwin|wince|emx/
  end
end