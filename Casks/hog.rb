cask "hog" do
  version "0.1.5"
  sha256 "4e5e8eb1148f1ac483f4ddd93a966ff5cdbba7fdcb42af4a11495ed233a41e70"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"

  postflight do
    system_command "/usr/bin/open", args: ["#{appdir}/Hog.app"]
  end
end
