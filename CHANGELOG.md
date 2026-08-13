# Changelog

## Unreleased

### Changed

- Rework copyright headers

### Fixed

- Cleanup copy right headers. Update to dart 3.13. Auto fixes.

## 3.0.1 - 2026-08-11

### Changed

- Provide gg via npm
- Fix shell changes

## 3.0.0 - 2026-08-08

### Changed

- Allow to pass custom options to exec of dir commands.

## 2.2.0 - 2026-08-03

### Changed

- Replace ✅ by ✓ and ❌ by ✗

## 2.1.0 - 2026-08-02

### Changed

- Report unknown sub commands also if option -h is given
- \#gg: changed references to git
- \#gg: changed references to pub.dev

## 2.0.5 - 2026-07-29

### Changed

- Update to latest SDK
- GgCommandRunner: forward to main command even if an argument equals its name

## 2.0.4 - 2024-04-13

### Removed

- dependency pana

## 2.0.3 - 2024-04-13

### Added

- defaultReaction for dir command mocks

### Removed

- dependency to gg_install_gg, remove ./check script

## 2.0.2 - 2024-04-12

### Added

- improved error handling

## 2.0.1 - 2024-04-11

### Changed

- print result only if not null

## 2.0.0 - 2024-04-11

### Changed

- BREAKING CHANGE: Change the way commands are defined

## 1.1.17 - 2024-04-11

### Added

- Generalized mocks

## 1.1.16 - 2024-04-11

### Changed

- finetune class hierarchy

## 1.1.15 - 2024-04-11

### Added

- extend mocked messages

## 1.1.14 - 2024-04-11

### Changed

- MockDirCommand does print the name of the mocked class

## 1.1.13 - 2024-04-11

### Added

- MockDirCommand

## 1.1.12 - 2024-04-10

### Removed

- 'Pipline: Disable cache'

## 1.1.11 - 2024-04-09

### Changed

- Rework changelog
- 'Github Actions Pipeline'
- 'Github Actions Pipeline: Add SDK file containing flutter into .github/workflows to make github installing flutter and not dart SDK'
- Update version

## 1.1.10 - 2024-01-01

- Set exitCode 1 on error

## 1.1.9 - 2024-01-01

- Set back meta to version 1.11.0

## 1.1.8 - 2024-01-01

- Update GgConsoleColors

## 1.1.7 - 2024-01-01

- Use GgLog

## 1.1.5 - 2024-01-01

- Add mandatory `exec(directory, ggLog)` method

## 1.1.4 - 2024-01-01

- Add `GgLog`

## 1.1.3 - 2024-01-01

- Rework DirCommand

## 1.1.2 - 2024-01-01

- Allow to set inputDir after initialization

## 1.1.1 - 2024-01-01

- `DirCommand`: Input directory can also be specified via constructor.

## 1.0.8 - 2024-01-01

- Add `additionalSubCommands` to arguments of `missingSubCommands`

## 1.0.7 - 2024-01-01

- Rename `inputDir` into `inputDirRelative`
- Rename `inputDirAbsolute` into `inputDir`

## 1.0.6 - 2024-01-01

- Turn `inputDir` into `Directory`
- Add `inputDirAbsolute`

## 1.0.5 - 2024-01-01

- Add `missingSubCommand()`

## 1.0.4 - 2024-01-01

- Initial version.
