cask "hog" do
  version "0.1.2"
  sha256 "fed42a125912cc19b5a8a4be2d90815c5f1f150c1b70ed29bad7d3bce98015f7"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"

  postflight do
    system_command "/usr/bin/open", args: ["#{appdir}/Hog.app"]
  end
end
