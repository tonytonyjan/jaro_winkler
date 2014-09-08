# encoding: utf-8
require 'jaro_winkler'
include JaroWinkler
describe JaroWinkler do
  it 'works' do
    ary = [
      ['henka'       , 'henkan'      , 0.9667] ,
      ['al'          , 'al'          , 1.0]    ,
      ['martha'      , 'marhta'      , 0.9611] ,
      ['jones'       , 'johnson'     , 0.8323] ,
      ['abcvwxyz'    , 'cabvwxyz'    , 0.9583] ,
      ['dwayne'      , 'duane'       , 0.8400] ,
      ['dixon'       , 'dicksonx'    , 0.8133] ,
      ['fvie'        , 'ten'         , 0.0]    ,
      ['tony'        , 'tony'        , 1.0]    ,
      ['tonytonyjan' , 'tonytonyjan' , 1.0]    ,
      ['x'           , 'x'           , 1.0]    ,
      [''            , ''            , 0.0]    ,
      ['tony'        , ''            , 0.0]    ,
      [''            , 'tony'        , 0.0]    ,
      ['tonytonyjan' , 'tony'        , 0.8727] ,
      ['tony'        , 'tonytonyjan' , 0.8727]
    ]
    ary.each do |s1, s2, ans|
      expect(r_distance(s1, s2)).to be_within(0.0001).of(ans)
      expect(c_distance(s1, s2)).to be_within(0.0001).of(ans)
    end
  end

  it 'works with UTF-8' do
    ary = [
      ['變形金剛4:絕跡重生' , '變形金剛4: 絕跡重生' , 0.9818] ,
      ['連勝文'             , '連勝丼'              , 0.8222] ,
      ['馬英九'             , '馬英丸'              , 0.8222] ,
      ['良い'               , 'いい'                , 0.6666] ,
    ]
    ary.each do |s1, s2, ans|
      expect(r_distance(s1, s2)).to be_within(0.0001).of(ans)
      expect(c_distance(s1, s2)).to be_within(0.0001).of(ans)
    end
  end

  it 'sets ignore_case' do
    params = 'MARTHA', 'marhta', {ignore_case: true}
    expect(r_distance(*params)).to be_within(0.0001).of(0.9611)
    expect(c_distance(*params)).to be_within(0.0001).of(0.9611)
  end

  it 'sets weight' do
    params = 'MARTHA', 'MARHTA', {weight: 0.2}
    expect(r_distance(*params)).to be_within(0.0001).of(0.9778)
    expect(c_distance(*params)).to be_within(0.0001).of(0.9778)
  end

  it 'sets threshold' do
    params = 'MARTHA', 'MARHTA', {threshold: 0.99}
    expect(r_distance(*params)).to be_within(0.0001).of(0.9445)
    expect(c_distance(*params)).to be_within(0.0001).of(0.9445)
  end

  it 'throws exception when weight exceeding 0.25' do
    params = 'MARTHA', 'MARHTA', {weight: 0.26}
    expect{ r_distance(*params) }.to raise_error
    expect{ c_distance(*params) }.to raise_error
  end

  it 'works with adjusting table' do
    ary = [
      ['HENKA'       , 'HENKAN'      , 0.9667] , # m=5, t=0, s=0
      ['AL'          , 'AL'          , 1.0]  , # m=2, t=0, s=0
      ['MARTHA'      , 'MARHTA'      , 0.9611] , # m=6, t=1, s=0
      ['JONES'       , 'JOHNSON'     , 0.8598] , # m=4, t=0, s=3
      ['ABCVWXYZ'    , 'CABVWXYZ'    , 0.9583] , # m=8, t=1, s=0
      ['DWAYNE'      , 'DUANE'       , 0.8730] , # m=4, t=0, s=3
      ['DIXON'       , 'DICKSONX'    , 0.8393] , # m=4, t=0, s=3
      ['FVIE'        , 'TEN'         , 0.0]
    ]
    ary.each do |s1, s2, ans|
      expect(r_distance(s1, s2, adj_table: true)).to be_within(0.0001).of(ans)
      expect(c_distance(s1, s2, adj_table: true)).to be_within(0.0001).of(ans)
    end
  end
end