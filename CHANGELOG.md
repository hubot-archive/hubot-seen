# `hubot-seen` changelog

`hubot-seen` follows [Semantic Versioning][1] 2.0.

## 2.0.0 - future

### Added

* Add a test suite

### Changed

* Dependency upgrades

### Breaking

* Switch to a more modern timeago implementation, which uses slightly different strings
* Drop support for Node 6 and Node 8

## 1.0.1 - 2017-03-15

### Fixed

* Revert a dependency upgrade that caused `TypeError: $.extend is not a function`

## 1.0.0 - 2017-03-15

### Added

* Data is now saved to Hubot's brain when it changes

### Changed

* Dependency upgrades

### Breaking

* timeago-formatted times are now used by default (set `HUBOT_SEEN_TIMEAGO=false` to restore the old behavior)

## 0.2.3 - 2015-06-19

### Fixed

* The Hubot logger is now used to send debug messages instead of `console.log`

## 0.2.2 - 2014-12-18

### Fixed

* All valid IRC nickname characters are now correctly accepted

## 0.2.1 - 2014-11-06

### Fixed

* Fix the main command not being recognized without another word following it

## 0.2.0 - 2014-07-07

### Added

* Add a command to list users seen in the last 24 hours

## 0.1.1 - 2014-05-03

### Fixed

* Fix a syntax error

## 0.1.0 - 2014-05-01

### Added

* Add timeago functionality and accompanying environment variable

## 0.0.1 - 2014-04-30

### Added

* Initial release

 [1]: https://semver.org/
