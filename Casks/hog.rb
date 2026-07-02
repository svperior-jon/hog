cask "hog" do
  version "0.1.10"
  sha256 "d98ea7e9a957b1f1dc1869f578d90a7bdd58d1415469ec32cea1b10c0b06db2a"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"

  postflight do
    system_command "/usr/bin/open", args: ["#{appdir}/Hog.app"]
  end
end
