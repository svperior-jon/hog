cask "hog" do
  version "0.1.0"
  sha256 "7b31cd45f6aa15fd30aae7beb75148fe6bc3cd4a6bbdee771d94d777fbed7c91"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"
end
