# spec/adjusting_table_spec.rb
require 'jaro_winkler'

describe JaroWinkler::DEFAULT_ADJ_TABLE do
  it 'should not be empty' do
    expect(JaroWinkler::DEFAULT_ADJ_TABLE).not_to be_empty
  end
end
