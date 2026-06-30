cask "hog" do
  version "0.1.4"
  sha256 "f64522b965866e6f077f12ba5a4f4c868f4133a2df96c5f5a12b02c06d523468"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"

  postflight do
    system_command "/usr/bin/open", args: ["#{appdir}/Hog.app"]
  end
end
