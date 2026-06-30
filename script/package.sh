#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-0.1.0}"
APP_NAME="Hog"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
ARCHIVE="$DIST_DIR/$APP_NAME-$VERSION.zip"

SIGNING_IDENTITY="${HOG_SIGNING_IDENTITY:-Developer ID Application: Superior Digital Partners, LLC (W9XJY8C57G)}"

HOG_BUILD_CONFIGURATION=release HOG_SIGNING_IDENTITY="$SIGNING_IDENTITY" "$ROOT_DIR/script/build_and_run.sh" --verify
pkill -x "$APP_NAME" >/dev/null 2>&1 || true

rm -f "$ARCHIVE"
ditto -c -k --keepParent "$DIST_DIR/$APP_NAME.app" "$ARCHIVE"

echo "Archive: $ARCHIVE"
echo "SHA256: $(shasum -a 256 "$ARCHIVE" | awk '{print $1}')"
