cask "nextcloud" do
  on_monterey :or_newer do
    version "3.13.0"
    sha256 "b7d5adbfa8d7c4b80c9b5f3391b1b42f887aa8a188d27c57f8ed1979c92f3497"

    livecheck do
      url :url
      regex(/^Nextcloud[._-]v?(\d+(?:\.\d+)+)-macOS-vfs\.pkg$/i)
      strategy :github_latest do |json, regex|
        json["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end
    end
  end

  url "https://github.com/nextcloud-releases/desktop/releases/download/v#{version}/Nextcloud-#{version}-macOS-vfs.pkg",
      verified: "github.com/nextcloud-releases/desktop/"
  name "Nextcloud with VFS"
  desc "Desktop sync client for Nextcloud software products"
  homepage "https://nextcloud.com/"

  auto_updates true

  pkg "Nextcloud-#{version}-macOS-vfs.pkg"
  binary "/Applications/Nextcloud.app/Contents/MacOS/nextcloudcmd"

  uninstall launchctl: "com.nextcloud.desktopclient",
            quit:      "com.nextcloud.desktopclient",
            pkgutil:   "com.nextcloud.desktopclient",
            delete:    "/Applications/Nextcloud.app"

  zap trash: [
    "~/Library/Application Scripts/com.nextcloud.desktopclient.FinderSyncExt",
    "~/Library/Application Support/Nextcloud",
    "~/Library/Caches/Nextcloud",
    "~/Library/Containers/com.nextcloud.desktopclient.FinderSyncExt",
    "~/Library/Group Containers/com.nextcloud.desktopclient",
    "~/Library/Preferences/com.nextcloud.desktopclient.plist",
    "~/Library/Preferences/Nextcloud",
  ]
end
