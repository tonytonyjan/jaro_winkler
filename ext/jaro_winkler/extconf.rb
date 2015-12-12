unless RUBY_PLATFORM == 'java'
  require 'mkmf'
  $CFLAGS << ' -std=c99 '
  create_makefile('jaro_winkler/jaro_winkler_ext')
else
  dummy_makefile = open('Makefile', 'wb')
  dummy_makefile.puts '.PHONY: install'
  dummy_makefile.puts 'install:'
  dummy_makefile.puts "\t" + '@echo "C extension is not installed, fall back to pure Ruby version instead."'
  dummy_makefile.close
end