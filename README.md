# About

It's a implementation of [Jaro-Winkler distance](http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) algorithm, it uses C extension and will fallback to pure Ruby version in JRuby.

# Installation

```
gem install jaro_winkler
```

# Usage

```ruby
require 'jaro_winkler'
JaroWinkler.distance "MARTHA", "MARHTA"
# => 0.9611
JaroWinkler.distance "MARTHA", "marhta", case_match: true
# => 0.9611
JaroWinkler.distance "MARTHA", "MARHTA", weight: 0.2
# => 0.9778

# Force the strategy
JaroWinkler.c_distance "MARTHA", "MARHTA" # C extension
JaroWinkler.r_distance "MARTHA", "MARHTA" # Pure Ruby
```

**Both implementations support UTF-8 string.**

## Options

Name        | Type    | Default | Note
----------- | ------  | ------- | ------------------------------------------------------------------------------------------------------------
case_match  | boolean | false   | All upper case characters are converted to lower case prior to the comparison.
weight      | number  | 0.1     | A constant scaling factor for how much the score is adjusted upwards for having common prefixes.
threshold   | number  | 0.7     | The prefix bonus is only added when the compared strings have a Jaro distance above the threshold.

# Why This?

There is also another gem named [fuzzy-string-match](https://github.com/kiyoka/fuzzy-string-match), it uses the same algorithm and both provides C and Ruby implementation.

I reinvent this wheel because of the naming in `fuzzy-string-match` such as `getDistance` breaks convention, and some weird code like `a1 = s1.split( // )` (`s1.chars` could be better), furthermore, it's bugged:

string 1   | string 2   | origin   | fuzzy-string-match | jaro_winkler
---------- | ---------- | -------- | ------------------ | ------------------
"henka"    | "henkan"   | 0.966667 | 0.9722 (wrong)     | 0.9666666666666667
"al"       | "al"       | 1.000000 | 1.0                | 1.0
"martha"   | "marhta"   | 0.961111 | 0.9611             | 0.9611111111111111
"jones"    | "johnson"  | 0.832381 | 0.8323             | 0.8323809523809523
"abcvwxyz" | "cabvwxyz" | 0.958333 | 0.9583             | 0.9583333333333333
"dwayne"   | "duane"    | 0.840000 | 0.8400             | 0.84
"dixon"    | "dicksonx" | 0.813333 | 0.8133             | 0.8133333333333332
"fvie"     | "ten"      | 0.000000 | 0.0                | 0

- The origin result is from the [original C implementation by the author of the algorithm](http://web.archive.org/web/20100227020019/http://www.census.gov/geo/msb/stand/strcmp.c).
- Test data are borrowed from [fuzzy-string-match's rspec file](https://github.com/kiyoka/fuzzy-string-match/blob/master/test/basic_pure_spec.rb).

## Benchmark

- jaro_winkler (1.0.1)
- fuzzy-string-match (0.9.6)

```ruby
require 'benchmark'
require 'jaro_winkler'
require 'fuzzystringmatch'
ary = [['al', 'al'], ['martha', 'marhta'], ['jones', 'johnson'], ['abcvwxyz', 'cabvwxyz'], ['dwayne', 'duane'], ['dixon', 'dicksonx'], ['fvie', 'ten']]

n = 100000
Benchmark.bmbm do |x|
  x.report 'jaro_winkler    ' do
    n.times{ ary.each{ |str1, str2| JaroWinkler.distance(str1, str2) } }
  end

  x.report 'fuzzystringmatch' do
    jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    n.times{ ary.each{ |str1, str2| jarow.getDistance(str1, str2) } }
  end
end

#                        user     system      total        real
# jaro_winkler      12.480000   0.010000  12.490000 ( 12.497828)
# fuzzystringmatch  14.990000   0.010000  15.000000 ( 15.014898)
```

# Todo

- Adjusting word table (Reference to original C implementation.)