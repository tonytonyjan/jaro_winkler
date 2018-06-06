# frozen_string_literal: true

if RUBY_ENGINE == 'ruby'
  require 'mkmf'
  $CFLAGS << ' -std=c99 '
  create_makefile('jaro_winkler/jaro_winkler_ext')
else
  open('Makefile', 'wb') do |file|
    file.write <<-MAKEFILE
.PHONY: install
install:
\techo "Cannot compile C Extension, fall back to pure Ruby version."
clean:
    MAKEFILE
  end
end
