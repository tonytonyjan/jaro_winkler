require "mkmf"
if Gem.win_platform?
  $CFLAGS << ' -std=gnu99 '
else
  $CFLAGS << ' -std=c99 '
end
create_makefile("jaro_winkler/jaro_winkler")
