# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [Unreleased]

### Changed
- Updated all GitHub Actions to latest versions (resolves Node.js 20 deprecation warnings):
  - `actions/checkout`: v4 → v7
  - `docker/setup-qemu-action`: v3 → v4
  - `docker/setup-buildx-action`: v3 → v4
  - `docker/login-action`: v3 → v4
  - `docker/metadata-action`: v5 → v6
  - `docker/build-push-action`: v6 → v7
- Replaced deprecated `actions/create-release@v1` (abandoned 2020) with `gh release create` CLI in `release.yml`

## [4.2.0] - 2026-08-09

### Fixed
- `update-privoxy.yml` bot commits pushed via `GITHUB_TOKEN` no longer trigger downstream
  `push` events due to a GitHub security guardrail; added an explicit `gh workflow run
  build-stable.yml` step so the stable Docker image build fires after every version bump.
- Nightly schedule was silently skipped after the February 2026 Dockerfile fix because the
  workflow had accumulated 100 consecutive failures (pre-fix) and GitHub had stopped
  scheduling it; manually re-triggered to resume the daily cadence.

### Changed
- Updated to Privoxy 4.2.0 stable

## [4.0.0] - 2025-03-26

### Added
- Initial release with Privoxy 4.0.0
- Multi-architecture support (amd64, arm64)
- Automated stable version updates
- Nightly builds from git repository
- Docker healthcheck
- GitHub Actions workflows
