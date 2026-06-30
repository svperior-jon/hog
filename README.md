# Hog

Hog is a lightweight macOS menu bar utility that shows the top CPU-consuming processes.

It samples the process table every few seconds, excludes itself, and displays the top offender in the menu bar. The popover shows the top three processes, their CPU percentages, a manual refresh button, and a shortcut to Activity Monitor.

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
./script/package.sh 0.1.0
```

This creates:

```text
dist/Hog-0.1.0.zip
```

The script prints the SHA-256 digest for use in a Homebrew Cask.

## Cask

`Casks/hog.rb` is a template. Replace the GitHub owner, repo, and SHA-256 after publishing the zip as a release asset.
