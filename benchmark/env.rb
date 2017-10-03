# frozen_string_literal: true

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'bundler'
Bundler.setup(:benchmark)

SAMPLES = {
  ascii: [
    %w[al al], %w[martha marhta], %w[jones johnson], %w[abcvwxyz cabvwxyz],
    %w[dwayne duane], %w[dixon dicksonx], %w[fvie ten]
  ].freeze,
  utf8: [
    %w[馬英九 馬英丸], %w[蔡英文 蔡中文], %w[簡煒航 簡偉航], %w[焦玟綾 焦紋綾],
    %w[眼球中央電視台 眼球中英電視台], %w[床前明月光 床前日月光],
    %w[海水退了就知道誰沒穿褲子 海水退了就知道誰沒穿襪子],
    %w[阿里山的姑娘美如水 阿里山的姑娘沒乳水]
  ].freeze
}.freeze

def gem_name_with_version(gem)
  "#{gem} (#{Gem.loaded_specs[gem].version})"
end
