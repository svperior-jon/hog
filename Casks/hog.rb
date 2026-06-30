cask "hog" do
  version "0.1.3"
  sha256 "d3e788386aeabdc11384c884c678ead7bcf0e6b59890cc9a666c90bd8a530785"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"

  postflight do
    system_command "/usr/bin/open", args: ["#{appdir}/Hog.app"]
  end
end
