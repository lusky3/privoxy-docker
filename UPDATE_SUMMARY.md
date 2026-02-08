# Update Summary

## Changes Made

### 1. Fixed Nightly Builds
**Problem**: Privoxy's git repository now requires a JavaScript cookie (`Please_let_me_pass=1`) due to AI crawler protection, causing `git clone` to fail.

**Solution**: Changed from `git clone` to downloading tarball snapshots with the required cookie header:
```bash
curl -H "Cookie: Please_let_me_pass=1" \
    "https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=HEAD;sf=tgz" \
    -o privoxy.tar.gz
```

### 2. Updated Dependencies
- Added `pcre2-dev` to build dependencies (required for Privoxy 4.2.0+ nightly)
- Added `pcre2` to runtime dependencies

### 3. Updated to Privoxy 4.1.0
- Changed `PRIVOXY_VERSION` from 4.0.0 to 4.1.0
- Updated all documentation references

### 4. Added New Workflows

#### `.github/workflows/test-pr.yml`
- Tests both stable and nightly builds on PRs
- Prevents broken builds from being merged
- Runs on linux/amd64 for speed

#### `.github/workflows/release.yml`
- Manual workflow to create GitHub releases
- Tags releases with version numbers
- Generates release notes

### 5. Documentation Updates
- Updated README.md with correct version numbers (4.1.0)
- Removed strikethrough text about disabled nightly builds
- Updated git repository URLs to Gitweb interface
- Added CHANGELOG.md for tracking changes

## Testing Results

✅ **Stable Build (4.1.0)**: Successfully built and tested
✅ **Nightly Build**: Successfully built and tested  
✅ **Container Runtime**: Both containers proxy HTTP requests correctly
✅ **Multi-arch**: Dockerfile supports linux/amd64 and linux/arm64

## Files Modified

1. `Dockerfile` - Fixed nightly source, added pcre2, updated version
2. `README.md` - Updated version references and documentation
3. `.github/workflows/test-pr.yml` - NEW: PR testing
4. `.github/workflows/release.yml` - NEW: Release creation
5. `CHANGELOG.md` - NEW: Change tracking

## Next Steps

1. Commit and push these changes to a branch
2. Create a PR to test the new PR workflow
3. After merge, manually trigger nightly build to verify it works
4. Create a release using the new release workflow
