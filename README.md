# About

It's a pure Ruby implementation of [Jaro-Winkler distance](http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) algorithm.

## Installation

```
gem install jaro_winkler
```

## Usage

```ruby
require 'jaro_winkler'
JaroWinkler.jaro_winkler_distance "MARTHA", "MARHTA"
# => 0.9611
JaroWinkler.jaro_winkler_distance "MARTHA", "marhta", case_match: true
# => 0.9611
JaroWinkler.jaro_winkler_distance "MARTHA", "MARHTA", weight: 0.2
# => 0.9778
```

## Options

Name        | Type    | Default | Note
----------- | ------  | ------- | ------------------------------------------------------------------------------------------------------------
case_match  | boolean | false   | All upper case characters are converted to lower case prior to the comparison.
weight      | number  | 0.1     | A constant scaling factor for how much the score is adjusted upwards for having common prefixes.
threshold   | number  | 0.7     | The prefix bonus is only added when the compared strings have a Jaro distance above a this.