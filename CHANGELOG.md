# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Bumped the `ameba` development dependency from `~> 1.6.0` to `~> 1.7.0` and
  fixed the newly reported lint violations (`Lint/SpecEqWithBoolOrNilLiteral`,
  `Style/HeredocIndent`, `Style/RedundantNilInControlExpression`,
  `Lint/WhitespaceAroundMacroExpression`, `Style/RedundantSelf`).
- Restructured CI into separate `lint` and `test` jobs (plus a macOS job that
  now also runs lint), and updated GitHub Actions to current versions
  (`actions/checkout@v4`, `actions/cache@v4`) with shards caching.

### Fixed

- Fixed the `lib/ameba/bin/ameba` Makefile rule, which only ran
  `shards install` and never compiled the `ameba` binary, so `make lint` and
  `make fix` could not actually run.
