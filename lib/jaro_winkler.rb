# frozen_string_literal: true

require 'jaro_winkler/version'

case RUBY_PLATFORM
when 'java'
  require 'jaro_winkler/jaro_winkler_pure'
else
  require 'jaro_winkler/jaro_winkler_ext'
end
