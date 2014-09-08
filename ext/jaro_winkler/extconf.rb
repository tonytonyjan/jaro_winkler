require "mkmf"
$CFLAGS << ' -std=gnu99' if Gem.win_platform?
create_makefile("jaro_winkler/jaro_winkler")
