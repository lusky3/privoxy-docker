# Update Summary

## Changes Made

### 1. Fixed Nightly Builds (February 2026)
**Problem**: Privoxy's git repository added AI crawler protection requiring a
`Please_let_me_pass=1` cookie, causing `git clone` to fail. The nightly workflow
accumulated 100 consecutive failures before the schedule was silently skipped by GitHub.

**Solution**: Switched from `git clone` to downloading tarball snapshots with the
required cookie header:
```bash
curl -H "Cookie: Please_let_me_pass=1" \
    "https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=HEAD;sf=tgz" \
    -o privoxy.tar.gz
```
Verified locally: `Cookie: Please_let_me_pass=1` returns HTTP 200 and a valid 1.8 MB
gzip tarball.

### 2. Fixed Stable Build Not Triggering After Version Bump (August 2026)
**Problem**: `update-privoxy.yml` commits the Dockerfile via `GITHUB_TOKEN`. GitHub
deliberately suppresses `push` events from `GITHUB_TOKEN` commits as a security
guardrail, so `build-stable.yml` (triggered on `push: branches: main`) never fired.
Result: the 4.2.0 version bump landed on June 7, 2026 but no Docker image was ever built.

**Solution**: Added an explicit `gh workflow run build-stable.yml` step in
`update-privoxy.yml`, executed only when a version change was committed:
```yaml
- name: Trigger stable build
  if: steps.commit.outputs.updated == 'true'
  run: gh workflow run build-stable.yml --ref main
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 3. Updated Dependencies (February 2026)
- Added `pcre2-dev` to build dependencies (required for Privoxy 4.2.0+)
- Added `pcre2` to runtime dependencies

### 4. Version History
- 4.0.0 → 4.1.0 (January 2026, automated)
- 4.1.0 → 4.2.0 (June 2026, automated — Docker build pending until workflow fix)

### 5. Workflows Added (February 2026)

#### `.github/workflows/test-pr.yml`
- Tests both stable and nightly builds on PRs
- Prevents broken builds from being merged
- Runs on linux/amd64 for speed

#### `.github/workflows/release.yml`
- Manual workflow to create GitHub releases
- Tags releases with version numbers
- Generates release notes

### 6. Documentation Updates
- Updated README.md version references
- Added CHANGELOG.md for tracking changes
- This file updated to reflect August 2026 workflow fixes

## Testing Results

✅ **Stable Build (4.1.0)**: Successfully built and pushed (February 2026)
✅ **Nightly Build**: Cookie header verified locally; schedule re-triggered August 2026
✅ **Cookie format confirmed**: `curl -H "Cookie: Please_let_me_pass=1"` → HTTP 200
⏳ **Stable Build (4.2.0)**: Pending — will fire after workflow fix is merged
⏳ **Nightly Schedule**: Pending — manual trigger dispatched to reactivate

## Files Modified

1. `.github/workflows/update-privoxy.yml` - Added explicit stable build trigger step
2. `CHANGELOG.md` - Added 4.2.0 entry with workflow fix details
3. `UPDATE_SUMMARY.md` - This file

## Root Cause Summary

Two independent bugs:

| Issue | Root Cause | Fix |
|-------|-----------|-----|
| Stable 4.2.0 never built | `GITHUB_TOKEN` commits suppress `push` events | Add `gh workflow run` after bot push |
| Nightly not running | 100 failures → GitHub stopped scheduling; fix already in Dockerfile | Manual trigger to resume schedule |
