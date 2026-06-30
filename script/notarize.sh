#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-0.1.0}"
PROFILE="${HOG_NOTARY_PROFILE:-hog-notary}"
APP_NAME="Hog"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
SUBMISSION_ARCHIVE="$DIST_DIR/$APP_NAME-$VERSION-notary-submit.zip"
RELEASE_ARCHIVE="$DIST_DIR/$APP_NAME-$VERSION.zip"

cd "$ROOT_DIR"

"$ROOT_DIR/script/package.sh" "$VERSION"

rm -f "$SUBMISSION_ARCHIVE"
ditto -c -k --keepParent "$APP_BUNDLE" "$SUBMISSION_ARCHIVE"

xcrun notarytool submit "$SUBMISSION_ARCHIVE" \
  --keychain-profile "$PROFILE" \
  --wait

xcrun stapler staple "$APP_BUNDLE"
xcrun stapler validate "$APP_BUNDLE"
spctl -a -vvv -t exec "$APP_BUNDLE"

rm -f "$RELEASE_ARCHIVE"
ditto -c -k --keepParent "$APP_BUNDLE" "$RELEASE_ARCHIVE"
rm -f "$SUBMISSION_ARCHIVE"

echo "Archive: $RELEASE_ARCHIVE"
echo "SHA256: $(shasum -a 256 "$RELEASE_ARCHIVE" | awk '{print $1}')"
