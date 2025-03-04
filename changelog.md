# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

* * *

## [Unreleased]

## [4.2.1] - 2024-02-13

## [4.1.1] - 2024-02-13

### Fixed

- Using old `http` instead of `https` on download URL

## [4.1.1] - 2024-02-13

### Fixed

- Missed branch identifier in build process

## [4.1.0] - 2024-02-13

### Added

- Adobe 2023 Testing and Support
- New Github Actions
- New supporting files
- New `build/Docs.cfc` task for building the documentation using itself, before we where getting away with it because there was a previous DocBox version. Now we need to build the docs with the current version of DocBox.

### Fixed

- Build Versions and changelog
- Removal of `box.zip` in root from old scripts

## [4.0.0] - 2023-08-03

### BREAKING

- Dropped support for Adobe 2016. Adobe doesn't support ACF 16 anymore, so neither do we.

### NEW

- Added support for Adobe 2021
- Added support for `@myCustomTag` custom docblock tags on methods. (Already supported on components and properties, but missing on methods).
- Added GitHub Actions CI for automated testing, format checking, releases and more

### FIX

- Fixes support for Adobe 2018. (Mainly in the CommandBox strategy.)

## [3.0.0]

### Added

- New `json` output strategy for machine-readable documentation
- New `addStrategy()` method for multiple strategy support

### Changed

- Can configure strategy with "alias" name, like `strategy="HTML"`.

### Removed

- Removed HTML as the default strategy. You will need to explicitly pass this to the constructor or to `docbox.addStrategy( "HTML", props )` to set your desired output format.

### Fixed

- Fixed failing XMI strategy

* * *

## [2.2.1]

### Fixed

- Bug on DocBox tracing errors, left over a couple of `()`

* * *

## [2.2.0]

### Added

- Better output of trace commands for CLI integration
- Added `@throws` annotation to function definitions
- Added `@deprecated` annotation to function definitions

* * *

## [2.1.0]

### Fixed

- Varscoping issue to help with COMMANDBOX-399
- BUGFIX: Missing pound sign in ExpandPath(), added better wording for custom strategy path
- Fix cleanPath without a leading slash with regex updates

* * *

## [2.0.7]

### Fixed

- Build process messed up folder structure. Basically 2.0.6 was unusable

* * *

## [2.0.6]

### Fixed

- DOCBOX-1 - Extra slash breaks some links on S3-hosted docs

### Improved

- Updated build process

### Added

- Travis integration

* * *

## [2.0.5]

### Improved

- Moved CommandBox command to its own repo

* * *

## [2.0.4]

### Improved

- Update package directory and location for CommandBox command

* * *

## [2.0.3]

### Fixed

- FireFox location bug

* * *

## [2.0.2]

### Fixed

- Fixes on conversion to script

### Improved

- Updates on box.json for standalone installations

* * *

## [2.0.1]

### Fixed

- Fixes for ACF

* * *

## [2.0.0]

### Improved

- Updated to DocBox styles

[Unreleased]: https://github.com/Ortus-Solutions/DocBox/compare/v4.2.1...HEAD

[4.2.1]: https://github.com/Ortus-Solutions/DocBox/compare/v4.1.1...v4.2.1

[4.1.1]: https://github.com/Ortus-Solutions/DocBox/compare/v4.1.0...v4.1.1

[4.1.0]: https://github.com/Ortus-Solutions/DocBox/compare/e6d838c31f224f6a162e95612762f8fa9ee87280...v4.1.0
