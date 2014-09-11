# About

It's an implementation of [Jaro-Winkler distance](http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) algorithm, it uses C extension and will fallback to pure Ruby version in JRuby. Both of them supports UTF-8 string.

# Installation

```
gem install jaro_winkler
```

# Usage

```ruby
require 'jaro_winkler'
JaroWinkler.distance "MARTHA", "MARHTA"
# => 0.9611
JaroWinkler.distance "MARTHA", "marhta", ignore_case: true
# => 0.9611
JaroWinkler.distance "MARTHA", "MARHTA", weight: 0.2
# => 0.9778

# Force the strategy
JaroWinkler.c_distance "MARTHA", "MARHTA" # C extension
JaroWinkler.r_distance "MARTHA", "MARHTA" # Pure Ruby
```

## Options

Name        | Type    | Default | Note
----------- | ------  | ------- | ------------------------------------------------------------------------------------------------------------
ignore_case | boolean | false   | All lower case characters are converted to upper case prior to the comparison.
weight      | number  | 0.1     | A constant scaling factor for how much the score is adjusted upwards for having common prefixes.
threshold   | number  | 0.7     | The prefix bonus is only added when the compared strings have a Jaro distance above the threshold.
adj_table   | boolean | false   | The option is used to give partial credit for characters that may be errors due to known phonetic or character recognition errors. A typical example is to match the letter "O" with the number "0".

## Default Adjusting Table

```
['A', 'E'], ['A', 'I'], ['A', 'O'], ['A', 'U'], ['B', 'V'], ['E', 'I'], ['E', 'O'], ['E', 'U'], ['I', 'O'], ['I', 'U'],
['O', 'U'], ['I', 'Y'], ['E', 'Y'], ['C', 'G'], ['E', 'F'], ['W', 'U'], ['W', 'V'], ['X', 'K'], ['S', 'Z'], ['X', 'S'],
['Q', 'C'], ['U', 'V'], ['M', 'N'], ['L', 'I'], ['Q', 'O'], ['P', 'R'], ['I', 'J'], ['2', 'Z'], ['5', 'S'], ['8', 'B'],
['1', 'I'], ['1', 'L'], ['0', 'O'], ['0', 'Q'], ['C', 'K'], ['G', 'J'], ['E', ' '], ['Y', ' '], ['S', ' ']
```

## How Adjusting Table Work

origin formula:

![origin](https://chart.googleapis.com/chart?cht=tx&chs&chl=%5Cbegin%7Bcases%7D0%26%7B%5Ctext%7Bif%20%7Dm%3D0%7D%5C%5C%5Cfrac%7B1%7D%7B3%7D(%5Cfrac%7Bm%7D%7B%5Cleft%7Cs1%5Cright%7C%7D%2B%5Cfrac%7Bm%7D%7B%5Cleft%7Cs2%5Cright%7C%7D%2B%5Cfrac%7Bm-t%7D%7Bm%7D)%26%5Ctext%7Bothers%7D%5Cend%7Bcases%7D)

where

- `m` is the number of matching characters.
- `t` is half the number of transpositions.

with adjusting table:

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
Bug Found       | **Not Yet**  | Yes              | **Not Yet** | Yes

For `Bug Found`, I made a rake task to build the table below, the source code is in `Rakefile`:

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

- The origin result is from the [original C implementation by the author of the algorithm](http://web.archive.org/web/20100227020019/http://www.census.gov/geo/msb/stand/strcmp.c).
- Test data are borrowed from [fuzzy-string-match's rspec file](https://github.com/kiyoka/fuzzy-string-match/blob/master/test/basic_pure_spec.rb).

## Benchmark

### Pure Ruby

                 | user     | system   | total    | real
---------------- | -------- | -------- | -------- | ------------
jaro_winkler     | 1.300000 | 0.000000 | 1.300000 | (  1.299802)
fuzzystringmatch | 1.510000 | 0.000000 | 1.510000 | (  1.510136)

- jaro_winkler (1.3.1)
- fuzzy-string-match (0.9.6)

### Native

                 | user     | system   | total    | real
---------------- | -------- | -------- | -------- | ------------
jaro_winkler     | 0.350000 | 0.010000 | 0.360000 | (  0.345293)
fuzzystringmatch | 0.140000 | 0.000000 | 0.140000 | (  0.138711)
hotwater         | 0.310000 | 0.000000 | 0.310000 | (  0.306498)
amatch           | 0.960000 | 0.000000 | 0.960000 | (  0.961509)

- jaro_winkler (1.3.1)
- fuzzy-string-match (0.9.6)
- hotwater (0.1.2)
- amatch (0.3.0)

# Todo

- Custom adjusting word table.
- If the adjusting table is ASCII encoded, use dense matrix instread of sparse matrix to speed up performance (or just use a good hash function).