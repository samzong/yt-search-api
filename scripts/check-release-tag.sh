#!/usr/bin/env bash
set -euo pipefail

if [[ ! "${RELEASE_TAG:-}" =~ ^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-(alpha|beta|rc)\.(0|[1-9][0-9]*))?$ ]]; then
  echo "::error::Invalid SemVer release tag: ${RELEASE_TAG:-}"
  exit 1
fi
version="${RELEASE_TAG#v}"
pkg_version="$(node -p 'require("./package.json").version')"
if [[ "$pkg_version" != "$version" ]]; then
  echo "::error::package.json version $pkg_version does not match tag version $version"
  exit 1
fi
if [[ "$(git rev-parse HEAD)" != "$(git rev-parse "refs/tags/$RELEASE_TAG^{commit}")" ]]; then
  echo "::error::Checked out commit does not match tag $RELEASE_TAG"
  exit 1
fi
is_prerelease=false
if [[ "$version" == *-* ]]; then
  is_prerelease=true
fi
printf 'version=%s\nis_prerelease=%s\n' "$version" "$is_prerelease" >> "$GITHUB_OUTPUT"
