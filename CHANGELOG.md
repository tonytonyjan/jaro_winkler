## 1.6.1 (2025-05-11)

* chore: use "similarity" methods over deprecated "distance" methods for rake tasks ([b8bbec0](https://github.com/tonytonyjan/jaro_winkler/commit/b8bbec0))
* ci: update strategy matrix ([8e4b0ef](https://github.com/tonytonyjan/jaro_winkler/commit/8e4b0ef))
* feat: Use `append_cflags` instead of `CFLAGS` environment varaible ([f8f13a0](https://github.com/tonytonyjan/jaro_winkler/commit/f8f13a0))

## <small>1.6.0 (2024-08-28)</small>

* chore: chore: bump version to v1.6.0 ([483e7ca](https://github.com/tonytonyjan/jaro_winkler/commit/483e7ca))
* fix: add "similarity" methods and deprecate "distance" methods ([1682f94](https://github.com/tonytonyjan/jaro_winkler/commit/1682f94))
* fix: use `rb_warn` over `rb_category_warn` for Ruby 2.7 ([0fd7b5d](https://github.com/tonytonyjan/jaro_winkler/commit/0fd7b5d))
* test: reduce deprecation warnings ([9ada77e](https://github.com/tonytonyjan/jaro_winkler/commit/9ada77e))
* docs: use "similarity" over "distance" in README ([97c9cbc](https://github.com/tonytonyjan/jaro_winkler/commit/97c9cbc))



## <small>1.5.6 (2023-05-29)</small>

* chore: bump version to v1.5.6 ([1327330](https://github.com/tonytonyjan/jaro_winkler/commit/1327330))
* ractor safe ([240d42d](https://github.com/tonytonyjan/jaro_winkler/commit/240d42d))



## <small>1.5.5 (2023-05-22)</small>

* chore: update changelog ([ecf1b26](https://github.com/tonytonyjan/jaro_winkler/commit/ecf1b26))
* chore(release): bump version to v1.5.5 ([4abbfc5](https://github.com/tonytonyjan/jaro_winkler/commit/4abbfc5))
* ci: add ruby 3 to ci ([886be74](https://github.com/tonytonyjan/jaro_winkler/commit/886be74))
* ci: replace travis with github action ([5701ef7](https://github.com/tonytonyjan/jaro_winkler/commit/5701ef7))
* ci: support windows and refine matrix ([84f3a42](https://github.com/tonytonyjan/jaro_winkler/commit/84f3a42))
* fix: Update argc type from size_t to int ([4c6ed4f](https://github.com/tonytonyjan/jaro_winkler/commit/4c6ed4f))
* Add project metadata to the gemspec ([6591989](https://github.com/tonytonyjan/jaro_winkler/commit/6591989))
* Create GitHub Actions workflow, remove dups from Travis ([7821e9d](https://github.com/tonytonyjan/jaro_winkler/commit/7821e9d))



## <small>1.5.4 (2019-10-30)</small>

* chore: package license file ([dd98482](https://github.com/tonytonyjan/jaro_winkler/commit/dd98482))
* chore(release): bump version to 1.5.4 ([50990da](https://github.com/tonytonyjan/jaro_winkler/commit/50990da)), closes [#33](https://github.com/tonytonyjan/jaro_winkler/issues/33)
* Add the license to the gem for packaging. ([46b9359](https://github.com/tonytonyjan/jaro_winkler/commit/46b9359))



## <small>1.5.3 (2019-06-25)</small>

* chore(release): bump version to v1.5.3 ([cb9b69e](https://github.com/tonytonyjan/jaro_winkler/commit/cb9b69e))
* Fall back to pure ruby implementation on LoadError ([49f811e](https://github.com/tonytonyjan/jaro_winkler/commit/49f811e))
* Rename Rake tasks for test ([42e0a36](https://github.com/tonytonyjan/jaro_winkler/commit/42e0a36))
* Update Rakefile ([1c05793](https://github.com/tonytonyjan/jaro_winkler/commit/1c05793))



## <small>1.5.2 (2019-01-04)</small>

* chore: fix benchmark ([4508599](https://github.com/tonytonyjan/jaro_winkler/commit/4508599))
* chore(release): bump version to v1.5.2 ([aa4be61](https://github.com/tonytonyjan/jaro_winkler/commit/aa4be61))
* fix: raises TypeError when input type is not string ([c146491](https://github.com/tonytonyjan/jaro_winkler/commit/c146491)), closes [#24](https://github.com/tonytonyjan/jaro_winkler/issues/24)
* fix(memory): make sure codepoints will be allocated/freed after rb_raise to prevent memory leak ([fe9d784](https://github.com/tonytonyjan/jaro_winkler/commit/fe9d784)), closes [#20](https://github.com/tonytonyjan/jaro_winkler/issues/20)
* ci: fix travis ci ([e1b9add](https://github.com/tonytonyjan/jaro_winkler/commit/e1b9add))
* build: build cross platform gems ([eb091bf](https://github.com/tonytonyjan/jaro_winkler/commit/eb091bf))
* test: test both native and pure ruby implementation ([2ecb24b](https://github.com/tonytonyjan/jaro_winkler/commit/2ecb24b))



## <small>1.5.1 (2018-06-06)</small>

* chore: add a rake task to measure performance of each version ([6368e2d](https://github.com/tonytonyjan/jaro_winkler/commit/6368e2d))
* chore: remove outdated benchmark output files ([7d590dc](https://github.com/tonytonyjan/jaro_winkler/commit/7d590dc))
* chore(benchmark): dry up benchmark codes ([5ebd36d](https://github.com/tonytonyjan/jaro_winkler/commit/5ebd36d))
* chore(benchmark): enhance the codes for measuring performance between each version ([4b05c43](https://github.com/tonytonyjan/jaro_winkler/commit/4b05c43))
* chore(release): bump version to 1.5.1 ([5d38f8e](https://github.com/tonytonyjan/jaro_winkler/commit/5d38f8e))
* build: build c extension only on MRI platform, and make a dummy Makefile for other platforms ([7e66cbf](https://github.com/tonytonyjan/jaro_winkler/commit/7e66cbf)), closes [#19](https://github.com/tonytonyjan/jaro_winkler/issues/19)
* build: update ci ([868609a](https://github.com/tonytonyjan/jaro_winkler/commit/868609a))
* build: update gems ([536e667](https://github.com/tonytonyjan/jaro_winkler/commit/536e667))
* refactor: convert types explicitly ([2db63d9](https://github.com/tonytonyjan/jaro_winkler/commit/2db63d9))
* style: remote unused variables ([64dd5cc](https://github.com/tonytonyjan/jaro_winkler/commit/64dd5cc))



## 1.5.0 (2017-10-02)

* chore: add a rake task to generate changelog automatically ([a8069f9](https://github.com/tonytonyjan/jaro_winkler/commit/a8069f9))
* chore: ignore tag file ([0ac7fce](https://github.com/tonytonyjan/jaro_winkler/commit/0ac7fce))
* chore: refine benchmark ([e6b93fb](https://github.com/tonytonyjan/jaro_winkler/commit/e6b93fb))
* chore: remove print_time task ([01e1cea](https://github.com/tonytonyjan/jaro_winkler/commit/01e1cea))
* chore(release): bump version to v1.5.0 ([f0e27a4](https://github.com/tonytonyjan/jaro_winkler/commit/f0e27a4))
* docs: fix table format ([fba1b2e](https://github.com/tonytonyjan/jaro_winkler/commit/fba1b2e))
* docs: update benchmark table ([f6f09d2](https://github.com/tonytonyjan/jaro_winkler/commit/f6f09d2))
* docs: update gemspec description ([3054a3e](https://github.com/tonytonyjan/jaro_winkler/commit/3054a3e))
* docs: update README.md ([a6ef904](https://github.com/tonytonyjan/jaro_winkler/commit/a6ef904))
* perf: optimize single byte codepoints computation ([e0cdd51](https://github.com/tonytonyjan/jaro_winkler/commit/e0cdd51))
* feat: support encodings other than utf-8 ([fe72ab4](https://github.com/tonytonyjan/jaro_winkler/commit/fe72ab4)), closes [#7](https://github.com/tonytonyjan/jaro_winkler/issues/7)
* feat: support rubinius ([27090ff](https://github.com/tonytonyjan/jaro_winkler/commit/27090ff))
* ci: add linux and osx to travis ci ([814418e](https://github.com/tonytonyjan/jaro_winkler/commit/814418e))
* ci: refine .travis.yml, update ruby versions ([330e368](https://github.com/tonytonyjan/jaro_winkler/commit/330e368))
* style: normalize codeing style with clang-format ([20865f4](https://github.com/tonytonyjan/jaro_winkler/commit/20865f4))
* style: normalize coding styles with rubocop ([3864897](https://github.com/tonytonyjan/jaro_winkler/commit/3864897))
* fix: free codepoints before returning to prevent memory leak ([8babd4f](https://github.com/tonytonyjan/jaro_winkler/commit/8babd4f))
* fix: remove module functions from JaroWinkler ([af249d5](https://github.com/tonytonyjan/jaro_winkler/commit/af249d5))
* refactor: declare DEFAULT_OPT as a global variable ([554f4cf](https://github.com/tonytonyjan/jaro_winkler/commit/554f4cf))
* refactor: prefer sizeof(variable) over sizeof(type) ([1a37c7e](https://github.com/tonytonyjan/jaro_winkler/commit/1a37c7e))
* refactor: rename code.h to codepoints.h ([106da9c](https://github.com/tonytonyjan/jaro_winkler/commit/106da9c))
* refactor: rename functions, variables and arguments to make them more sense ([71f9e95](https://github.com/tonytonyjan/jaro_winkler/commit/71f9e95))
* refactor: stop using char or int or short or long or unsigned, use int8_t, int16_t, int32_t, int64_t ([ba2b936](https://github.com/tonytonyjan/jaro_winkler/commit/ba2b936))
* refactor: use ruby's built-in hash function ([16883ce](https://github.com/tonytonyjan/jaro_winkler/commit/16883ce)), closes [#14](https://github.com/tonytonyjan/jaro_winkler/issues/14)
* test: use assert_in_delta for comparing floats ([feca1a5](https://github.com/tonytonyjan/jaro_winkler/commit/feca1a5))
* add changelog [ci skip] ([de15eba](https://github.com/tonytonyjan/jaro_winkler/commit/de15eba))
* Add JRuby 9.0.4.0 to the Travis CLI tests ([29fe873](https://github.com/tonytonyjan/jaro_winkler/commit/29fe873))
* add ruby 2.3 test ([bb3fed8](https://github.com/tonytonyjan/jaro_winkler/commit/bb3fed8))
* Add ruby 2.4.0 to .travis.yml ([b49f202](https://github.com/tonytonyjan/jaro_winkler/commit/b49f202))
* fix ci ([f2b959f](https://github.com/tonytonyjan/jaro_winkler/commit/f2b959f))
* fix ci ([71bbdc9](https://github.com/tonytonyjan/jaro_winkler/commit/71bbdc9))
* fix rakefile ([f5cd294](https://github.com/tonytonyjan/jaro_winkler/commit/f5cd294))
* refine adj table ([104c1af](https://github.com/tonytonyjan/jaro_winkler/commit/104c1af))
* support jruby19 ([84c85a9](https://github.com/tonytonyjan/jaro_winkler/commit/84c85a9))
* there has been gem for java platform since 1.4.0 [ci skip] ([093bd09](https://github.com/tonytonyjan/jaro_winkler/commit/093bd09))
* typo ([6b8be41](https://github.com/tonytonyjan/jaro_winkler/commit/6b8be41))
* update benchmark ([ce27575](https://github.com/tonytonyjan/jaro_winkler/commit/ce27575))
* update README ([46e3137](https://github.com/tonytonyjan/jaro_winkler/commit/46e3137))
* update README [ci skip] ([d88d73e](https://github.com/tonytonyjan/jaro_winkler/commit/d88d73e))
* Update ruby version in .travis.yml to 2.3.3/2.2.6/2.1.10 ([6d11b55](https://github.com/tonytonyjan/jaro_winkler/commit/6d11b55))
* use `pragma once` instead of `include guard`, it's been ([2d7f43e](https://github.com/tonytonyjan/jaro_winkler/commit/2d7f43e))


### BREAKING CHANGE

* JaroWinkler no longer supports mixin, use class methods instead, ex.
`JaroWinkler.distance`


## 1.4.0 (2015-12-12)

* add JaroWinkler.jaro_distance ([7347807](https://github.com/tonytonyjan/jaro_winkler/commit/7347807))
* add jruby to ci ([c46d208](https://github.com/tonytonyjan/jaro_winkler/commit/c46d208))
* correct wording ([ead6367](https://github.com/tonytonyjan/jaro_winkler/commit/ead6367))
* fix benchmark ([72e64ca](https://github.com/tonytonyjan/jaro_winkler/commit/72e64ca))
* gems that are used in benchmark should not be defined in gemspec. ([8fd870e](https://github.com/tonytonyjan/jaro_winkler/commit/8fd870e))
* indent ([609a56d](https://github.com/tonytonyjan/jaro_winkler/commit/609a56d))
* more test ([5c9f8b6](https://github.com/tonytonyjan/jaro_winkler/commit/5c9f8b6))
* prevent warning from rspec ([0a94fcb](https://github.com/tonytonyjan/jaro_winkler/commit/0a94fcb))
* reimplement pure ruby version ([8c63b8a](https://github.com/tonytonyjan/jaro_winkler/commit/8c63b8a))
* replace rspec with minitest ([accc6eb](https://github.com/tonytonyjan/jaro_winkler/commit/accc6eb))
* use rake gem packaging tasks instead of bundler ([871c0d7](https://github.com/tonytonyjan/jaro_winkler/commit/871c0d7))



