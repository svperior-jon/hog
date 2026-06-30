cask "hog" do
  version "0.1.0"
  sha256 "cd0e52df2500172bae355d6fa3d37d3158d90997d8a515eb7f76d98b0cebcec5"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"
end
