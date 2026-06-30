#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-0.1.0}"
APP_NAME="Hog"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
ARCHIVE="$DIST_DIR/$APP_NAME-$VERSION.zip"

SIGNING_IDENTITY="${HOG_SIGNING_IDENTITY:-}"

if [[ -z "$SIGNING_IDENTITY" ]]; then
  SIGNING_IDENTITY="$(
    security find-identity -v -p codesigning |
      awk -F '"' '/Developer ID Application/ { print $2; exit }'
  )"
fi

if [[ -z "$SIGNING_IDENTITY" ]]; then
  echo "No Developer ID Application signing identity found." >&2
  echo "Set HOG_SIGNING_IDENTITY to the signing identity name and try again." >&2
  exit 1
fi

BUILD_NUMBER="${HOG_BUILD_NUMBER:-${VERSION//./}}"

HOG_BUILD_CONFIGURATION=release \
  HOG_SIGNING_IDENTITY="$SIGNING_IDENTITY" \
  HOG_APP_VERSION="$VERSION" \
  HOG_BUILD_NUMBER="$BUILD_NUMBER" \
  "$ROOT_DIR/script/build_and_run.sh" --verify
pkill -x "$APP_NAME" >/dev/null 2>&1 || true

rm -f "$ARCHIVE"
ditto -c -k --keepParent "$DIST_DIR/$APP_NAME.app" "$ARCHIVE"

echo "Archive: $ARCHIVE"
echo "SHA256: $(shasum -a 256 "$ARCHIVE" | awk '{print $1}')"
