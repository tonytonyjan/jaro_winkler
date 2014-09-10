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

![origin](https://chart.googleapis.com/chart?cht=tx&chl=%5Cbegin%7Bcases%7D%200%20%26%20m%3D0%20%5C%5C%20%5Cfrac%20%7B%201%20%7D%7B%203%20%7D%20(%5Cfrac%20%7B%20m%20%7D%7B%20%5Cleft%7C%20s1%20%5Cright%7C%20%20%7D%20%2B%5Cfrac%20%7B%20m%20%7D%7B%20%5Cleft%7C%20s2%20%5Cright%7C%20%20%7D%20%2B%5Cfrac%20%7B%20m-t%20%7D%7B%20m%20%7D%20)%20%26%20others%20%5Cend%7Bcases%7D)

where

- `m` is the number of matching characters.
- `t` is half the number of transpositions.

with adjusting table:

![adj](https://chart.googleapis.com/chart?cht=tx&chl=%5Cbegin%7Bcases%7D%200%20%26%20m%3D0%20%5C%5C%20%5Cfrac%20%7B%201%20%7D%7B%203%20%7D%20(%5Cfrac%20%7B%20%5Cfrac%20%7B%20s%20%7D%7B%2010%20%7D%20%2Bm%20%7D%7B%20%5Cleft%7C%20s1%20%5Cright%7C%20%20%7D%20%2B%5Cfrac%20%7B%20%5Cfrac%20%7B%20s%20%7D%7B%2010%20%7D%20%2Bm%20%7D%7B%20%5Cleft%7C%20s2%20%5Cright%7C%20%20%7D%20%2B%5Cfrac%20%7B%20m-t%20%7D%7B%20m%20%7D%20)%20%26%20others%20%5Cend%7Bcases%7D)

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
Speed           | Medium       | Fast             | Medium      | Slow
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

- Custom adjusting word table.
- If the adjusting table is ASCII encoded, use dense matrix instread of sparse matrix to speed up.
- Call by reference instead of call by value to enhance performance.
