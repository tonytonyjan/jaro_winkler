# encoding: utf-8
require 'jaro_winkler'
include JaroWinkler

shared_examples 'common' do |strategy|
  it 'works' do
    expect(send(strategy, 'henka','henkan')).to be_within(0.0001).of(0.9667)
    expect(send(strategy, 'al','al')).to be_within(0.0001).of(1.0)
    expect(send(strategy, 'martha','marhta')).to be_within(0.0001).of(0.9611)
    expect(send(strategy, 'jones','johnson')).to be_within(0.0001).of(0.8323)
    expect(send(strategy, 'abcvwxyz','cabvwxyz')).to be_within(0.0001).of(0.9583)
    expect(send(strategy, 'dwayne','duane')).to be_within(0.0001).of(0.8400)
    expect(send(strategy, 'dixon','dicksonx')).to be_within(0.0001).of(0.8133)
    expect(send(strategy, 'fvie','ten')).to be_within(0.0001).of(0.0)
    expect(send(strategy, 'tony','tony')).to be_within(0.0001).of(1.0)
    expect(send(strategy, 'tonytonyjan','tonytonyjan')).to be_within(0.0001).of(1.0)
    expect(send(strategy, 'x','x')).to be_within(0.0001).of(1.0)
    expect(send(strategy, '','')).to be_within(0.0001).of(0.0)
    expect(send(strategy, 'tony','')).to be_within(0.0001).of(0.0)
    expect(send(strategy, '','tony')).to be_within(0.0001).of(0.0)
    expect(send(strategy, 'tonytonyjan','tony')).to be_within(0.0001).of(0.8727)
    expect(send(strategy, 'tony','tonytonyjan')).to be_within(0.0001).of(0.8727)
  end

  it 'works with UTF-8' do
    expect(send(strategy, '變形金剛4:絕跡重生','變形金剛4: 絕跡重生')).to be_within(0.0001).of(0.9818)
    expect(send(strategy, '連勝文','連勝丼')).to be_within(0.0001).of(0.8222)
    expect(send(strategy, '馬英九','馬英丸')).to be_within(0.0001).of(0.8222)
    expect(send(strategy, '良い','いい')).to be_within(0.0001).of(0.6666)
  end

  it 'sets ignore_case' do
    expect(send(strategy, 'MARTHA', 'marhta', ignore_case: true)).to be_within(0.0001).of(0.9611)
  end

  it 'sets weight' do
    expect(send(strategy, 'MARTHA', 'MARHTA', weight: 0.2)).to be_within(0.0001).of(0.9778)
  end

  it 'sets threshold' do
    expect(send(strategy, 'MARTHA', 'MARHTA', threshold: 0.99)).to be_within(0.0001).of(0.9445)
  end


  it 'works with adjusting table' do
    expect(send(strategy, 'HENKA', 'HENKAN', adj_table: true)).to be_within(0.0001).of(0.9667) # m=5, t=0, s=0
    expect(send(strategy, 'AL', 'AL', adj_table: true)).to be_within(0.0001).of(1.0) # m=2, t=0, s=0
    expect(send(strategy, 'MARTHA', 'MARHTA', adj_table: true)).to be_within(0.0001).of(0.9611) # m=6, t=1, s=0
    expect(send(strategy, 'JONES', 'JOHNSON', adj_table: true)).to be_within(0.0001).of(0.8598) # m=4, t=0, s=3
    expect(send(strategy, 'ABCVWXYZ', 'CABVWXYZ', adj_table: true)).to be_within(0.0001).of(0.9583) # m=8, t=1, s=0
    expect(send(strategy, 'DWAYNE', 'DUANE', adj_table: true)).to be_within(0.0001).of(0.8730) # m=4, t=0, s=3
    expect(send(strategy, 'DIXON', 'DICKSONX', adj_table: true)).to be_within(0.0001).of(0.8393) # m=4, t=0, s=3
    expect(send(strategy, 'FVIE', 'TEN', adj_table: true)).to be_within(0.0001).of(0.0)
  end

  context 'with weight exceeding 0.25' do
    it 'throws exception' do
      expect{ send(strategy, 'MARTHA', 'MARHTA', weight: 0.26) }.to raise_error
    end
  end

  context 'long string' do
    it 'works without exception' do
      expect { send(strategy, 'haisai' * 1024, 'haisai' * 1024) }.not_to raise_error
    end
  end
end

describe 'Pure Ruby' do
  include_examples 'common', :r_distance
end

describe 'C extention' do
  include_examples 'common', :c_distance
end