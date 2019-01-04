# encoding: utf-8
module Tests
  def test_distance
    assert_distance 0.9667, 'henka',       'henkan'
    assert_distance 1.0,    'al',          'al'
    assert_distance 0.9611, 'martha',      'marhta'
    assert_distance 0.8324, 'jones',       'johnson'
    assert_distance 0.9583, 'abcvwxyz',    'cabvwxyz'
    assert_distance 0.84,   'dwayne',      'duane'
    assert_distance 0.8133, 'dixon',       'dicksonx'
    assert_distance 0.0,    'fvie',        'ten'
    assert_distance 1.0,    'tony',        'tony'
    assert_distance 1.0,    'tonytonyjan', 'tonytonyjan'
    assert_distance 1.0,    'x',           'x'
    assert_distance 0.0,    '',            ''
    assert_distance 0.0,    'tony',        ''
    assert_distance 0.0,    '',            'tony'
    assert_distance 0.8727, 'tonytonyjan', 'tony'
    assert_distance 0.8727, 'tony',        'tonytonyjan'
    assert_distance 0.9407, 'necessary',   'nessecary'
    assert_distance 0.9067, 'does_exist',  'doesnt_exist'
    assert_distance 0.975,  '12345678',    '12345687'
    assert_distance 0.975,  '12345678',    '12345867'
    assert_distance 0.95,   '12345678',    '12348567'
  end

  def test_jaro_distance
    assert_jaro_distance 0.9444, 'henka',       'henkan'
    assert_jaro_distance 1.0,    'al',          'al'
    assert_jaro_distance 0.9444, 'martha',      'marhta'
    assert_jaro_distance 0.7905, 'jones',       'johnson'
    assert_jaro_distance 0.9583, 'abcvwxyz',    'cabvwxyz'
    assert_jaro_distance 0.8222, 'dwayne',      'duane'
    assert_jaro_distance 0.7667, 'dixon',       'dicksonx'
    assert_jaro_distance 0.0,    'fvie',        'ten'
    assert_jaro_distance 1.0,    'tony',        'tony'
    assert_jaro_distance 1.0,    'tonytonyjan', 'tonytonyjan'
    assert_jaro_distance 1.0,    'x',           'x'
    assert_jaro_distance 0.0,    '',            ''
    assert_jaro_distance 0.0,    'tony',        ''
    assert_jaro_distance 0.0,    '',            'tony'
    assert_jaro_distance 0.7879, 'tonytonyjan', 'tony'
    assert_jaro_distance 0.7879, 'tony',        'tonytonyjan'
    assert_jaro_distance 0.9259, 'necessary',   'nessecary'
    assert_jaro_distance 0.8444, 'does_exist',  'doesnt_exist'
    assert_jaro_distance 0.9583, '12345678',    '12345687'
    assert_jaro_distance 0.9583, '12345678',    '12345867'
    assert_jaro_distance 0.9167, '12345678',    '12348567'
    assert_jaro_distance 0.604,  'tonytonyjan', 'janjantony'
  end

  def test_unicode
    assert_distance 0.9818, '變形金剛4:絕跡重生', '變形金剛4: 絕跡重生'
    assert_distance 0.8222, '連勝文',             '連勝丼'
    assert_distance 0.8222, '馬英九',             '馬英丸'
    assert_distance 0.6667, '良い',               'いい'
  end

  def test_ignore_case
    assert_distance 0.9611, 'MARTHA', 'marhta', ignore_case: true
  end

  def test_weight
    assert_distance 0.9778, 'MARTHA', 'MARHTA', weight: 0.2
  end

  def test_threshold
    assert_distance 0.9444, 'MARTHA', 'MARHTA', threshold: 0.99
  end


  def test_adjusting_table
    assert_distance 0.9667, 'HENKA',    'HENKAN',   adj_table: true
    assert_distance 1.0,    'AL',       'AL',       adj_table: true
    assert_distance 0.9611, 'MARTHA',   'MARHTA',   adj_table: true
    assert_distance 0.8598, 'JONES',    'JOHNSON',  adj_table: true
    assert_distance 0.9583, 'ABCVWXYZ', 'CABVWXYZ', adj_table: true
    assert_distance 0.8730, 'DWAYNE',   'DUANE',    adj_table: true
    assert_distance 0.8393, 'DIXON',    'DICKSONX', adj_table: true
    assert_distance 0.0,    'FVIE',     'TEN',      adj_table: true
  end

  def test_error
    assert_raises JaroWinkler::InvalidWeightError do
      JaroWinkler.distance 'MARTHA', 'MARHTA', weight: 0.26
    end
  end

  def test_long_string
    JaroWinkler.distance 'haisai' * 20, 'haisai' * 20
  end

  def test_encoding
    assert_encoding '焦玟綾', '焦紋綾', Encoding::Big5
    assert_encoding '簡煒航', '簡偉航', Encoding::Big5_HKSCS
    assert_encoding '西島之', '西鳥志', Encoding::EUCJP
    assert_encoding '松本行弘', '枩本行弘', Encoding::Shift_JIS
    assert_distance 1.0, "\xe8".force_encoding('iso8859-1'), 'è'
  end

private

  def assert_distance score, str1, str2, options={}
    assert_in_delta score, JaroWinkler.distance(str1, str2, options)
  end

  def assert_encoding str1, str2, encoding, options={}
    assert_distance JaroWinkler.distance(str1, str2), str1.encode(encoding), str2.encode(encoding)
  end

  def assert_jaro_distance score, str1, str2, options={}
    assert_in_delta score, JaroWinkler.jaro_distance(str1, str2, options)
  end
end