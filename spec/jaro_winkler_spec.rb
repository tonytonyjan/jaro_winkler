require 'jaro_winkler'

describe JaroWinkler do
  it 'works' do
    expect(JaroWinkler.jaro_winkler_distance("MARTHA", "MARHTA")).to  be_within(0.0001).of(0.9611)
    expect(JaroWinkler.jaro_winkler_distance("DIXON", "DICKSONX")).to be_within(0.0001).of(0.8133)
    expect(JaroWinkler.jaro_winkler_distance("abcvwxyz", "cabvwxyz")).to be_within(0.0001).of(0.9583)
    expect(JaroWinkler.jaro_winkler_distance("DWAYNE", "DUANE")).to   eq 0.84
    expect(JaroWinkler.jaro_winkler_distance("tony", "tony")).to eq 1.0
    expect(JaroWinkler.jaro_winkler_distance("tonytonyjan", "tonytonyjan")).to eq 1.0
    expect(JaroWinkler.jaro_winkler_distance("", "")).to eq 0.0
    expect(JaroWinkler.jaro_winkler_distance("tony", "")).to eq 0.0
    expect(JaroWinkler.jaro_winkler_distance("", "tony")).to eq 0.0
  end
end