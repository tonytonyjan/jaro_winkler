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
      ['x', 'x', 1.0],
      ['', '', 0.0],
      ['tony', '', 0.0],
      ['', 'tony', 0.0],
      ['tonytonyjan', 'tony', 0.8727],
      ['tony', 'tonytonyjan', 0.8727]
    ]
  end

  it 'works' do
    @ary.each do |s1, s2, ans|
      expect(distance(s1, s2)).to be_within(0.0001).of(ans)
    end
  end

  it 'supports C extension' do
    @ary.each do |s1, s2, ans|
      expect(distance(s1, s2, native: true)).to be_within(0.0001).of(ans)
    end
  end

  it 'works with UTF-8' do
    expect(distance('變形金剛4:絕跡重生', '變形金剛4: 絕跡重生')).to eq c_distance('0123456789', '01234x56789')
  end

  it 'can ignore case' do
    expect(distance('MARTHA', 'marhta', case_match: true)).to be_within(0.0001).of(0.9611)
  end

  it 'can set weight' do
    expect(distance('MARTHA', 'MARHTA', weight: 0.2)).to be_within(0.0001).of(0.9778)
    expect{ distance('MARTHA', 'MARHTA', weight: 0.26) }.to raise_error
  end
end