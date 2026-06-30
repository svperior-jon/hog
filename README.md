# Hog

Hog is a lightweight macOS menu bar utility that shows the top CPU-consuming processes.

It samples the process table every few seconds, excludes itself, and displays the top offender in the menu bar. The popover shows the top three processes, their CPU percentages, a manual refresh button, and a shortcut to Activity Monitor.

## Install

```sh
brew tap svperior-jon/hog https://github.com/svperior-jon/hog
brew trust --cask svperior-jon/hog/hog
brew install --cask svperior-jon/hog/hog
```

Homebrew 6 requires explicit trust for third-party cask taps. After the tap is trusted, updates can be installed with:

```sh
brew upgrade --cask svperior-jon/hog/hog
```

## Build and Run

```sh
./script/build_and_run.sh
```

The app is staged at:

```text
dist/Hog.app
```

## Package

```sh
./script/package.sh 0.1.5
```

This creates:

```text
dist/Hog-0.1.5.zip
```

The script prints the SHA-256 digest for use in a Homebrew Cask.

## Notarize

Create a notary profile once with your Apple Developer account:

```sh
xcrun notarytool store-credentials hog-notary \
  --apple-id "you@example.com" \
  --team-id "W9XJY8C57G"
```

When prompted, enter an app-specific password for that Apple ID.

Then notarize, staple, validate, and rebuild the caskable zip:

```sh
./script/notarize.sh 0.1.5
```

The notarization script uses the `hog-notary` Keychain profile by default. Override it with `HOG_NOTARY_PROFILE` if needed.

## Cask

The Homebrew Cask lives at `Casks/hog.rb` and installs the signed, notarized release zip from GitHub.
