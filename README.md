# About

It's a implementation of [Jaro-Winkler distance](http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) algorithm, it uses C extension and will fallback to pure Ruby version in JRuby. Both implementation supports UTF-8 string.

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
case_match  | boolean | false   | All lower case characters are converted to upper case prior to the comparison.
weight      | number  | 0.1     | A constant scaling factor for how much the score is adjusted upwards for having common prefixes.
threshold   | number  | 0.7     | The prefix bonus is only added when the compared strings have a Jaro distance above the threshold.

# Why This?

There is also another gem named [fuzzy-string-match](https://github.com/kiyoka/fuzzy-string-match), it uses the same algorithm and both provides C and Ruby implementation.

I reinvent this wheel because of the naming in `fuzzy-string-match` such as `getDistance` breaks convention, and some weird code like `a1 = s1.split( // )` (`s1.chars` could be better), furthermore, it's bugged (see table below).

# Compare with other gems

             | jaro_winkler | fuzzystringmatch | hotwater | amatch
------------ | ------------ | ---------------- | -------- | ------
UTF-8 Suport | Yes          | Pure Ruby only   |          |
Native       | Yes          | Yes              | Yes      | Yes
Pure Ruby    | Yes          | Yes              |          |
Speed        | Medium       | Fast             | Medium   | Low
Bug Found    |              | Yes              |          | Yes

For `Bug Found`, I made a rake task to build the table below, the source code is in `Rakefile`:

str_1      | str_2      | origin       | jaro_winkler | fuzzystringmatch | hotwater | amatch
---        | ---        | ---          | ---          | ---              | ---      | ---
"henka"    | "henkan"   | 0.9667       | 0.9667       | **0.9722**           | 0.9667   | **0.9444**
"al"       | "al"       | 1.0          | 1.0          | 1.0              | 1.0      | 1.0
"martha"   | "marhta"   | 0.9611       | 0.9611       | 0.9611           | 0.9611   | **0.9444**
"jones"    | "johnson"  | 0.8324       | 0.8324       | 0.8324           | 0.8324   | **0.7905**
"abcvwxyz" | "cabvwxyz" | 0.9583       | 0.9583       | 0.9583           | 0.9583   | 0.9583
"dwayne"   | "duane"    | 0.84         | 0.84         | 0.84             | 0.84     | **0.8222**
"dixon"    | "dicksonx" | 0.8133       | 0.8133       | 0.8133           | 0.8133   | **0.7667**
"fvie"     | "ten"      | 0.0          | 0.0          | 0.0              | 0.0      | 0.0

- The origin result is from the [original C implementation by the author of the algorithm](http://web.archive.org/web/20100227020019/http://www.census.gov/geo/msb/stand/strcmp.c).
- Test data are borrowed from [fuzzy-string-match's rspec file](https://github.com/kiyoka/fuzzy-string-match/blob/master/test/basic_pure_spec.rb).

## Benchmark

### Pure Ruby

                 | user      | system   | total     | real
---------------- | --------- | -------- | --------- | ------------
jaro_winkler     | 12.750000 | 0.030000 | 12.780000 | ( 12.782842)
fuzzystringmatch | 16.240000 | 0.030000 | 16.270000 | ( 16.287380)

- jaro_winkler (1.2.3)
- fuzzy-string-match (0.9.6)

### Native

                 | user     | system   | total    | real
---------------- | -------- | -------- | -------- | ------------
jaro_winkler     | 0.390000 | 0.000000 | 0.390000 | (  0.392408)
fuzzystringmatch | 0.150000 | 0.000000 | 0.150000 | (  0.151552)
hotwater         | 0.320000 | 0.000000 | 0.320000 | (  0.317740)
amatch           | 0.960000 | 0.010000 | 0.970000 | (  0.964803)

- jaro_winkler (1.2.3)
- fuzzy-string-match (0.9.6)
- hotwater (0.1.2)
- amatch (0.3.0)

# Todo

- Make it faster
- Adjusting word table (Reference to original C implementation.)