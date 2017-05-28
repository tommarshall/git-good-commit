# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

* Add multiple verbs to the imperative mood blacklist.

### Fixed

* Avoid hanging when run non-interactively (@ssbarnea).
* Avoid validating lines after the verbose cut line marker (@walle).

## [v0.6.1] - 2017-01-04

### Fixed

* A bug with the edit action introduced in [v0.6.0].

## [v0.6.0] - 2017-01-03

### Changed

* Mirror Git's approach for editor config, instead of just using `$EDITOR`.

## [v0.5.0] - 2016-11-22

### Changed

* Only check the first word of the subject for imperative mood.

## [v0.4.0] - 2016-11-03

### Changed

* Ignore `fixup!` and `squash!` autosquash flags.

## [v0.3.0] - 2016-10-28

### Added

* Add `hooks.goodcommit.color` config.

## [v0.2.0] - 2016-09-29

### Fixed

* Ignore trailing whitespace in commit messages.

## v0.1.0 - 2016-08-31

### Added

* Initial version.

[Unreleased]: https://github.com/tommarshall/git-good-commit/compare/v0.6.1...HEAD
[v0.6.1]: https://github.com/tommarshall/git-good-commit/compare/v0.6.0...v0.6.1
[v0.6.0]: https://github.com/tommarshall/git-good-commit/compare/v0.5.0...v0.6.0
[v0.5.0]: https://github.com/tommarshall/git-good-commit/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/tommarshall/git-good-commit/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/tommarshall/git-good-commit/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/tommarshall/git-good-commit/compare/v0.1.0...v0.2.0
