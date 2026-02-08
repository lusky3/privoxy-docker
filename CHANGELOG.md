# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Fixed
- Fixed nightly builds by switching from git clone to tarball snapshot download with cookie authentication
- Added pcre2 dependencies for nightly builds (Privoxy 4.2.0+ requirement)

### Changed
- Updated to Privoxy 4.1.0 stable
- Updated README to reflect working nightly builds

### Added
- PR testing workflow to validate builds before merge
- Release workflow for creating GitHub releases
- This changelog

## [4.0.0] - 2025-03-26

### Added
- Initial release with Privoxy 4.0.0
- Multi-architecture support (amd64, arm64)
- Automated stable version updates
- Nightly builds from git repository
- Docker healthcheck
- GitHub Actions workflows
