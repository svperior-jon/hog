cask "hog" do
  version "0.1.0"
  sha256 "43e69abfb2eaf0c50ee83b1f73bcef9244d98a49bc9636f056dfdf4fbff2140b"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"
end
