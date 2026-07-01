cask "hog" do
  version "0.1.9"
  sha256 "b1e050326cc737c7251b0576421c01f7cc3a3942bd0b453c18963fb812b10487"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"

  postflight do
    system_command "/usr/bin/open", args: ["#{appdir}/Hog.app"]
  end
end
