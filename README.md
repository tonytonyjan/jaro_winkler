[![Build Status](https://travis-ci.org/tonytonyjan/jaro_winkler.svg?branch=master)](https://travis-ci.org/tonytonyjan/jaro_winkler)

An implementation of [Jaro-Winkler distance](http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) algorithm, it's a C extension and will fallback to pure Ruby version in JRuby. **Both of them supports UTF-8 string.**

# Installation

```
gem install jaro_winkler
```

# Usage

```ruby
require 'jaro_winkler'

# Jaro Winkler Distance

JaroWinkler.distance "MARTHA", "MARHTA"
# => 0.9611
JaroWinkler.distance "MARTHA", "marhta", ignore_case: true
# => 0.9611
JaroWinkler.distance "MARTHA", "MARHTA", weight: 0.2
# => 0.9778

# Jaro Distance

JaroWinkler.jaro_distance "MARTHA", "MARHTA"
# => 0.9444444444444445
```

There is no `JaroWinkler.jaro_winkler_distance`, it's tediously long.

## Options

Name        | Type    | Default | Note
----------- | ------  | ------- | ------------------------------------------------------------------------------------------------------------
ignore_case | boolean | false   | All lower case characters are converted to upper case prior to the comparison.
weight      | number  | 0.1     | A constant scaling factor for how much the score is adjusted upwards for having common prefixes.
threshold   | number  | 0.7     | The prefix bonus is only added when the compared strings have a Jaro distance above the threshold.
adj_table   | boolean | false   | The option is used to give partial credit for characters that may be errors due to known phonetic or character recognition errors. A typical example is to match the letter "O" with the number "0".

# Adjusting Table

## Default Table

```
['A', 'E'], ['A', 'I'], ['A', 'O'], ['A', 'U'], ['B', 'V'], ['E', 'I'], ['E', 'O'], ['E', 'U'], ['I', 'O'], ['I', 'U'],
['O', 'U'], ['I', 'Y'], ['E', 'Y'], ['C', 'G'], ['E', 'F'], ['W', 'U'], ['W', 'V'], ['X', 'K'], ['S', 'Z'], ['X', 'S'],
['Q', 'C'], ['U', 'V'], ['M', 'N'], ['L', 'I'], ['Q', 'O'], ['P', 'R'], ['I', 'J'], ['2', 'Z'], ['5', 'S'], ['8', 'B'],
['1', 'I'], ['1', 'L'], ['0', 'O'], ['0', 'Q'], ['C', 'K'], ['G', 'J'], ['E', ' '], ['Y', ' '], ['S', ' ']
```

## How it works?

Original Formula:

![origin](https://chart.googleapis.com/chart?cht=tx&chs&chl=%5Cbegin%7Bcases%7D0%26%7B%5Ctext%7Bif%20%7Dm%3D0%7D%5C%5C%5Cfrac%7B1%7D%7B3%7D(%5Cfrac%7Bm%7D%7B%5Cleft%7Cs1%5Cright%7C%7D%2B%5Cfrac%7Bm%7D%7B%5Cleft%7Cs2%5Cright%7C%7D%2B%5Cfrac%7Bm-t%7D%7Bm%7D)%26%5Ctext%7Bothers%7D%5Cend%7Bcases%7D)

where

- `m` is the number of matching characters.
- `t` is half the number of transpositions.

With Adjusting Table:

![adj](https://chart.googleapis.com/chart?cht=tx&chs&chl=%5Cbegin%7Bcases%7D0%26%5Ctext%7Bif%20%7Dm%3D0%5C%5C%5Cfrac%7B1%7D%7B3%7D(%5Cfrac%7B%5Cfrac%7Bs%7D%7B10%7D%2Bm%7D%7B%5Cleft%7Cs1%5Cright%7C%7D%2B%5Cfrac%7B%5Cfrac%7Bs%7D%7B10%7D%2Bm%7D%7B%5Cleft%7Cs2%5Cright%7C%7D%2B%5Cfrac%7Bm-t%7D%7Bm%7D)%26%5Ctext%7Bothers%7D%5Cend%7Bcases%7D)

where

- `s` is the number of nonmatching but similar characters.

# Why This?

There is also another similar gem named [fuzzy-string-match](https://github.com/kiyoka/fuzzy-string-match) which both provides C and Ruby version as well.

I reinvent this wheel because of the naming in `fuzzy-string-match` such as `getDistance` breaks convention, and some weird code like `a1 = s1.split( // )` (`s1.chars` could be better), furthermore, it's bugged (see tables below).

# Compare with other gems

                | jaro_winkler | fuzzystringmatch | hotwater    | amatch
--------------- | ------------ | ---------------- | --------    | ------
UTF-8 Suport    | **Yes**      | Pure Ruby only   | No          | No
Windows Support | **Yes**      |                  | No          | **Yes**
Adjusting Table | **Yes**      | No               | No          | No
Native          | **Yes**      | **Yes**          | **Yes**     | **Yes**
Pure Ruby       | **Yes**      | **Yes**          | No          | No
Speed           | Medium       | **Fast**         | Medium      | Slow

I made a table below to compare accuracy between each gem:

str_1      | str_2      | origin | jaro_winkler | fuzzystringmatch | hotwater | amatch
---        | ---        | ---    | ---          | ---              | ---      | ---
"henka"    | "henkan"   | 0.9667 | 0.9667       | **0.9722**       | 0.9667   | **0.9444**
"al"       | "al"       | 1.0    | 1.0          | 1.0              | 1.0      | 1.0
"martha"   | "marhta"   | 0.9611 | 0.9611       | 0.9611           | 0.9611   | **0.9444**
"jones"    | "johnson"  | 0.8324 | 0.8324       | 0.8324           | 0.8324   | **0.7905**
"abcvwxyz" | "cabvwxyz" | 0.9583 | 0.9583       | 0.9583           | 0.9583   | 0.9583
"dwayne"   | "duane"    | 0.84   | 0.84         | 0.84             | 0.84     | **0.8222**
"dixon"    | "dicksonx" | 0.8133 | 0.8133       | 0.8133           | 0.8133   | **0.7667**
"fvie"     | "ten"      | 0.0    | 0.0          | 0.0              | 0.0      | 0.0

- The "origin" result is from the [original C implementation by the author of the algorithm](http://web.archive.org/web/20100227020019/http://www.census.gov/geo/msb/stand/strcmp.c).
- Test data are borrowed from [fuzzy-string-match's rspec file](https://github.com/kiyoka/fuzzy-string-match/blob/master/test/basic_pure_spec.rb).

# Benchmark

```
$ bundle exec rake benchmark
2015-12-12 20:37:34 UTC

# C Extension
Rehearsal ----------------------------------------------------------
jaro_winkler 1.4.0       0.340000   0.000000   0.340000 (  0.345071)
fuzzystringmatch 0.9.7   0.470000   0.000000   0.470000 (  0.467571)
hotwater 0.1.2           0.380000   0.000000   0.380000 (  0.382495)
amatch 0.3.0             1.020000   0.010000   1.030000 (  1.032459)
------------------------------------------------- total: 2.220000sec

                             user     system      total        real
jaro_winkler 1.4.0       0.350000   0.000000   0.350000 (  0.354300)
fuzzystringmatch 0.9.7   0.480000   0.000000   0.480000 (  0.480397)
hotwater 0.1.2           0.400000   0.000000   0.400000 (  0.396380)
amatch 0.3.0             1.030000   0.000000   1.030000 (  1.028923)

# Pure Ruby
Rehearsal ----------------------------------------------------------
jaro_winkler 1.4.0       0.680000   0.010000   0.690000 (  0.690518)
fuzzystringmatch 0.9.7   1.610000   0.000000   1.610000 (  1.608468)
------------------------------------------------- total: 2.300000sec

                             user     system      total        real
jaro_winkler 1.4.0       0.620000   0.000000   0.620000 (  0.619257)
fuzzystringmatch 0.9.7   1.600000   0.010000   1.610000 (  1.597612)
```

# Todo

- Custom adjusting word table.