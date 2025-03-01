$software_categories = @{
    "Browsers" = @{
        "Firefox" = @{
            "names" = @("Mozilla Firefox")
            "info" = "https://www.mozilla.org/"
            "winget_id" = "Mozilla.Firefox"
        }
        "Chrome" = @{
            "names" = @("Google Chrome")
            "info" = "https://www.google.com/chrome"
            "winget_id" = "Google.Chrome"
        }
        "Vivaldi" = @{
            "names" = @("Vivaldi")
            "info" = "https://vivaldi.com/"
            "winget_id" = "Vivaldi.Vivaldi"
        }
        "Brave" = @{
            "names" = @("Brave")
            "info" = "https://brave.com/"
            "winget_id" = "Brave.Brave"
        }
        "Edge" = @{
            "names" = @("Microsoft Edge")
            "info" = "https://www.microsoft.com/en-us/edge/download?form=MA13FJ"
            "winget_id" = "Microsoft.Edge"
        }
        "Floorp" = @{
            "names" = @("Ablaze Floorp (x64 en-US)")
            "info" = "https://floorp.app/en"
            "winget_id" = "Ablaze.Floorp"
        }
        "Arc" = @{
            "names" = @("Arc")
            "info" = "https://arc.net/"
            "winget_id" = "TheBrowserCompany.Arc"
        }
        "Opera" = @{
            "names" = @("Opera")
            "info" = "https://www.opera.com/"
            "winget_id" = "Opera.Opera"
        }
        "OperaGX" = @{
            "names" = @("Opera GX")
            "info" = "https://www.opera.com/gx"
            "winget_id" = "Opera.OperaGX"
        }
    }
    "Communications" = @{
        "Discord" = @{
            "names" = @("Discord")
            "info" = "https://discord.com/"
            "winget_id" = "Discord.Discord"
        }
        "Messenger" = @{
            "names" = @("Facebook Messenger")
            "info" = "https://www.messenger.com/"
            "winget_id" = "9WZDNCRF0083"
        }
        "Signal" = @{
            "names" = @("OpenWhisperSystems Signal")
            "info" = "https://signal.org/"
            "winget_id" = "OpenWhisperSystems.Signal"
        }
        "Telegram" = @{
            "names" = @("Telegram")
            "info" = "https://telegram.org/"
            "winget_id" = "Telegram.TelegramDesktop"
        }
        "Whatsapp" = @{
            "names" = @("Whatsapp")
            "info" = "https://www.whatsapp.com/"
            "winget_id" = "9NKSQGP7F2NH"
        }
        "Slack" = @{
            "names" = @("Slack")
            "info" = "https://slack.com/"
            "winget_id" = "SlackTechnologies.Slack"
        }
        "Zoom" = @{
            "names" = @("Zoom")
            "info" = "https://zoom.us/"
            "winget_id" = "Zoom.Zoom"
        }
        "Wire" = @{
            "names" = @("Wire")
            "info" = "https://wire.com/en/"
            "winget_id" = "wire.wire"
        }
    }
    "Gaming" = @{
        "Steam" = @{
            "names" = @("Steam")
            "info" = "https://store.steampowered.com/"
            "winget_id" = "Valve.Steam"
        }
        "BattleNet" = @{
            "names" = @("Battle.net")
            "info" = "https://us.shop.battle.net/"
            "InstallerUrl" = "https://downloader.battle.net/download/getInstallerForGame?os=win&gameProgram=BATTLENET_APP&      version=Live"
            "InstallerFileName" = "battlenet_installer_latest.exe"
            "installerLocation" = "$env:TEMP\battlenet_installer_latest.exe"
        }
        "Epic Games" = @{
            "names" = @("Epic Games Launcher")
            "info" = "https://store.epicgames.com/"
            "winget_id" = "+"
        }
        "Ubisoft Connect" = @{
            "names" = @("Ubisoft Connect")
            "info" = "https://www.ubisoft.com/"
            "winget_id" = "Ubisoft.UbisoftConnect"
        }
        "Prism Launcher" = @{
            "names" = @("Prism Launcher")
            "info" = "https://prismlauncher.org/"
            "winget_id" = "PrismLauncher.PrismLauncher"
        }
        "Heroic Games" = @{
            "names" = @("Heroic Games")
            "info" = "https://heroicgameslauncher.com/"
            "winget_id" = "HeroicGameslauncher.HeroicGameslauncher"
        }
        "GOG Galaxy" = @{
            "names" = @("GOG galaxy")
            "info" = "https://www.gog.com/"
            "winget_id" = "GOG.Galaxy"
        }
    }
    "Utilities" = @{
        "Advanced Renamer" = @{
            "names" = @("Advanced Renamer")
            "info" = "https://www.advancedrenamer.com/"
            "winget_id" = "HulubuluSoftware.AdvancedRenamer"
        }
        "7-Zip" = @{
            "names" = @("7-Zip")
            "info" = "https://www.7-zip.org/"
            "winget_id" = "7zip.7zip"
        }
        "Notepad++" = @{
            "names" = @("Notepad++")
            "info" = "https://notepad-plus-plus.org/"
            "winget_id" = "Notepad++.Notepad++"
        }
        "qBittorrent" = @{
            "names" = @("qBittorrent")
            "info" = "https://www.qbittorrent.org/"
            "winget_id" = "qBittorrent.qBittorrent"
        }
        "ShareX" = @{
            "names" = @("ShareX")
            "info" = "https://getsharex.com/"
            "winget_id" = "ShareX.ShareX"
        }
        "SubtitleEdit" = @{
            "names" = @("Subtitle Edit")
            "info" = "https://www.nikse.dk/subtitleedit"
            "winget_id" = "Nikse.SubtitleEdit"
        }
        "WinSCP" = @{
            "names" = @("WinSCP")
            "info" = "https://winscp.net/"
            "winget_id" = "WinSCP.WinSCP"
        }
        "WinRAR" = @{
            "names" = @("WinRAR")
            "info" = "https://www.win-rar.com/"
            "winget_id" = "RARLab.WinRAR"
        }
        "Team Viewer" = @{
            "names" = @("Team Viewer")
            "info" = "https://www.teamviewer.com/"
            "winget_id" = "TeamViewer.TeamViewer"
        }
        "WinDirStat" = @{
            "names" = @("WinDirStat")
            "info" = "https://windirstat.net/"
            "winget_id" = "WinDirStat.WinDirStat"
        }
        "Glary Utilities" = @{
            "names" = @("Glary Utilities")
            "info" = "https://www.glarysoft.com/"
            "winget_id" = "Glarysoft.GlaryUtilities"
        }
        "Snappy Driver Origin" = @{
            "names" = @("Snappy Driver Origin")
            "info" = "https://www.snappy-driver-installer.org/"
            "winget_id" = "GlennDelahoy.SnappyDriverInstallerOrigin"
        }
        "Iobit Driver Booster" = @{
            "names" = @("Driver Booster")
            "info" = "https://www.iobit.com/"
            "winget_id" = "IObit.DriverBooster"
        }
    }
    "Media Tools" = @{
        "Media Player Classic" = @{
            "names" = @("MPC-HC 2.3.4 (64-bit)")
            "info" = "https://github.com/clsid2/mpc-hc"
            "winget_id" = "clsid2.mpc-hc"
        }
        "HandBrake" = @{
            "names" = @("HandBrake")
            "info" = "https://handbrake.fr/"
            "winget_id" = "HandBrake.HandBrake"
        }
        "EarTrumpet" = @{
            "names" = @("EarTrumpet")
            "info" = "https://eartrumpet.app/"
            "winget_id" = "File-New-Project.EarTrumpet"
        }
        "Jellyfin Server" = @{
            "names" = @("Jellyfin Server")
            "info" = "https://jellyfin.org/"
            "winget_id" = "Jellyfin.Server"
        }
        "Spotify" = @{
            "names" = @("Spotify")
            "info" = "https://www.spotify.com/"
            "winget_id" = "Spotify.Spotify"
        }
        "OBS Studio" = @{
            "names" = @("OBS Studio")
            "info" = "https://obsproject.com/"
            "winget_id" = "OBSProject.OBSStudio"
        }
        "VLC" = @{
            "names" = @("VLC")
            "info" = "https://www.videolan.org/"
            "winget_id" = "VideoLAN.VLC"
        }
        "Foobar2000" = @{
            "names" = @("Foobar2000")
            "info" = "https://www.foobar2000.org/"
            "winget_id" = "PeterPawlowski.foobar2000"
        }
        "MusicBee" = @{
            "names" = @("MusicBee")
            "info" = "https://www.getmusicbee.com/"
            "winget_id" = "MusicBee.MusicBee"
        }
        "AIMP" = @{
            "names" = @("AIMP")
            "info" = "https://www.aimp.ru/"
            "winget_id" = "AIMP.AIMP"
        }
    }
    "Documents" = @{
        "LibreOffice" = @{
            "names" = @("LibreOffice")
            "info" = "https://www.libreoffice.org/"
            "winget_id" = "TheDocumentFoundation.LibreOffice"
        }
        "Foxit PDF Reader" = @{
            "names" = @("FoxitPDFReader")
            "info" = "https://www.foxit.com/"
            "winget_id" = "Foxit.FoxitReader"
        }
        "FreeOffice" = @{
            "names" = @("FreeOffice")
            "info" = "https://www.freeoffice.com/"
            "winget_id" = "SoftMaker.FreeOffice.2024"
        }
        "WPS Office" = @{
            "names" = @("WPS Office")
            "info" = "https://www.wps.com/"
            "winget_id" = "Kingsoft.WPSOffice"
        }
    }
    "Developer" = @{
        "Python3" = @{
            "names" = @("Python3")
            "info" = "https://www.python.org/"
            "winget_id" = "Python.Python.3.7"
        }
        "AdoptOpenJDK 15" = @{
            "names" = @("AdoptOpenJDk")
            "info" = "https://adoptium.net/"
            "winget_id" = "AdoptOpenJDK."
        }
        "AdoptOpenJDK 8" = @{
            "names" = @("AdoptOpenJDk")
            "info" = "https://adoptium.net/"
            "winget_id" = "AdoptOpenJDK."
        }
        "Blender" = @{
            "names" = @("Blender")
            "info" = "https://www.blender.org/"
            "winget_id" = "BlenderFoundation.Blender"
        }
        "Eclipse" = @{
            "names" = @("Eclipse")
            "info" = "https://eclipseide.org/"
            "winget_id" = "eclipse"
            "installer" = "choco"
        }
        "AmazonCorreto 8" = @{
            "names" = @("AmazonCorretto")
            "info" = "https://aws.amazon.com/corretto/"
            "winget_id" = "Amazon.Corretto.8.JDK"
        }
        "AmazonCorreto 22" = @{
            "names" = @("AmazonCorretto")
            "info" = "https://aws.amazon.com/corretto/"
            "winget_id" = "Amazon.Corretto.22.JDK"
        }
        "Visual Studio Code" = @{
            "names" = @("VSCode")
            "info" = "https://code.visualstudio.com/"
            "winget_id" = "Microsoft.VisualStudioCode"
        }
    }
    "Editing" = @{
        "Kdenlive" = @{
            "names" = @("kdenlive")
            "info" = "https://kdenlive.org/en/"
            "winget_id" = "KDE.Kdenlive"
        }
        "GIMP" = @{
            "names" = @("GIMP")
            "info" = "https://www.gimp.org/"
            "winget_id" = "GIMP.GIMP"
        }
        "Paint.Net" = @{
            "names" = @("Paint.net")
            "info" = "https://www.getpaint.net/"
            "winget_id" = "dotPDN.PaintDotNet"
        }
        "Krita" = @{
            "names" = @("Krita")
            "info" = "https://krita.org/"
            "winget_id" = "KDE.KritaShellExtension"
        }
    }
    "Security" = @{
        "Malwarebytes" = @{
            "names" = @("Essentials")
            "info" = "https://www.malwarebytes.com/"
            "winget_id" = "Malwarebytes.Malwarebytes"
        }
        "Avira" = @{
            "names" = @("Avira")
            "info" = "https://www.avira.com/"
            "winget_id" = "XPFD23M0L795KD"
        }
        "Avast" = @{
            "names" = @("Avast")
            "info" = "https://www.avast.com/"
            "winget_id" = "XPDNZJFNCR1B07"
        }
        "AVG" = @{
            "names" = @("AVG")
            "info" = "https://www.avg.com/"
            "winget_id" = "XP8BX2DWV7TF50"
        }
    }
}