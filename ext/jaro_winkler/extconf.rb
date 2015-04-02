unless RUBY_PLATFORM == 'java'
  require "mkmf"
  $CFLAGS << ' -std=c99 '
  create_makefile("jaro_winkler/jaro_winkler")
else
  dummy_makefile = open("Makefile", "wb")
  dummy_makefile.puts '.PHONY: install'
  dummy_makefile.puts 'install:'
  dummy_makefile.puts "\t" + '@echo "Extensions not installed, falling back to pure Ruby version."'
  dummy_makefile.close
end