require 'jaro_winkler'
include JaroWinkler
describe JaroWinkler do
  before(:all) do
    @ary = [
      ['henka', 'henkan', 0.9667],
      ['al', 'al', 1.0],
      ['martha', 'marhta', 0.9611],
      ['jones', 'johnson', 0.8323],
      ['abcvwxyz', 'cabvwxyz', 0.9583],
      ['dwayne', 'duane', 0.8400],
      ['dixon', 'dicksonx', 0.8133],
      ['fvie', 'ten', 0.0],
      ['tony', 'tony', 1.0],
      ['tonytonyjan', 'tonytonyjan', 1.0],
      ['', '', 0.0],
      ['tony', '', 0.0],
      ['', 'tony', 0.0]
    ]
  end

  it 'works' do
    @ary.each do |s1, s2, ans|
      expect(jaro_winkler_distance(s1, s2)).to be_within(0.0001).of(ans)
    end
  end

  it 'supports C extension' do
    @ary.each do |s1, s2, ans|
      expect(distance(s1, s2)).to be_within(0.0001).of(ans)
    end
  end

  it 'can ignore case' do
    expect(jaro_winkler_distance('MARTHA', 'marhta', case_match: true)).to be_within(0.0001).of(0.9611)
  end

  it 'can set weight' do
    expect(jaro_winkler_distance('MARTHA', 'MARHTA', weight: 0.2)).to be_within(0.0001).of(0.9778)
    expect{ jaro_winkler_distance('MARTHA', 'MARHTA', weight: 0.26) }.to raise_error
  end
end