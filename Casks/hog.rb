cask "hog" do
  version "0.1.6"
  sha256 "9d1cae1b1f542cb7cf7801062ce59dcce0fe50ae8f0c2b8739627bde34d069c7"

  url "https://github.com/svperior-jon/hog/releases/download/v#{version}/Hog-#{version}.zip"
  name "Hog"
  desc "Lightweight menu bar monitor for the top CPU-consuming processes"
  homepage "https://github.com/svperior-jon/hog"

  app "Hog.app"

  postflight do
    system_command "/usr/bin/open", args: ["#{appdir}/Hog.app"]
  end
end
