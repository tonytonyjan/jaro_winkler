<a name="1.5.0"></a>
# [1.5.0](https://github.com/tonytonyjan/jaro_winkler/compare/v1.4.0...v1.5.0) (2017-10-02)


### Bug Fixes

* free codepoints before returning to prevent memory leak ([8babd4f](https://github.com/tonytonyjan/jaro_winkler/commit/8babd4f))
* remove module functions from JaroWinkler ([af249d5](https://github.com/tonytonyjan/jaro_winkler/commit/af249d5))


### Features

* support encodings other than utf-8 ([fe72ab4](https://github.com/tonytonyjan/jaro_winkler/commit/fe72ab4)), closes [#7](https://github.com/tonytonyjan/jaro_winkler/issues/7)
* support rubinius ([27090ff](https://github.com/tonytonyjan/jaro_winkler/commit/27090ff))


### Performance Improvements

The C implementation is 25% faster than that of v1.4.0.

* optimize single byte codepoints computation ([e0cdd51](https://github.com/tonytonyjan/jaro_winkler/commit/e0cdd51))


### BREAKING CHANGES

* JaroWinkler no longer supports mixin, use class methods instead, ex.
`JaroWinkler.distance`



<a name="1.4.0"></a>
# [1.4.0](https://github.com/tonytonyjan/jaro_winkler/compare/v1.3.7...v1.4.0) (2015-12-12)

* The pure Ruby version is about 2.5 times faster compared to 1.3.7
* Add `JaroWinkler.jaro_distance` for anyone who want to use jaro distance instead of jaro-winkler distance.
* Unify algorithms between C extensions and pure Ruby, especially, rewrote the pure Ruby version.
