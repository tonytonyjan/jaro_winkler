require "mkmf"
$CFLAGS << ' -std=gnu99' if RUBY_PLATFORM['win']
create_makefile("jaro_winkler/jaro_winkler")
