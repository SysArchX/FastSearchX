# FastSearchX

**Chrome-style browser with a built-in downloader for video (MP4), music (MP3) and any file, on Android and Linux.**

<p align="center">
  <img src="data/icons/fastsearchx-256.png" width="160" alt="FastSearchX icon">
</p>

<p align="center">
  <a href="https://github.com/SysArchX/FastSearchX/releases/latest">
    <img alt="Latest release" src="https://img.shields.io/github/v/release/SysArchX/FastSearchX?label=release&color=e53935">
  </a>
  <a href="https://github.com/SysArchX/FastSearchX/releases">
    <img alt="Downloads" src="https://img.shields.io/github/downloads/SysArchX/FastSearchX/total?label=downloads&color=43a047">
  </a>
  <a href="LICENSE">
    <img alt="MIT license" src="https://img.shields.io/github/license/SysArchX/FastSearchX?label=license&color=blue">
  </a>
  <img alt="Android 7.0+" src="https://img.shields.io/badge/Android-7.0%2B-3ddc84?logo=android&logoColor=white">
  <img alt="Linux x86_64" src="https://img.shields.io/badge/Linux-x86__64-fcc624?logo=linux&logoColor=black">
</p>

**FastSearchX** is a free browser with a built-in downloader. There are two versions:

- **Android**: a full browser that can be set as your default browser, downloads
  **any file** (including LocalSend links) and detects videos and audio from any
  site, including HLS/DASH streams.
- **Linux (GTK 3)**: a Chrome-style **tabbed** browser (WebKit2GTK) with an
  address bar, Google search, downloads and a button that downloads the page's
  video/audio with the bundled [yt-dlp](https://github.com/yt-dlp/yt-dlp). The
  link and playlist downloader is also in the menu.

## What's new in 2.0.0

- **New name and new package:** the project is now **FastSearchX**
  (`com.sysarchx.fastsearchx`). Uninstall TubeFetch 1.4.x before installing.
- **Android: fixed the "there was a problem parsing the package" error.**
  1.4.1 packaged the native libraries compressed, so the installer had to extract
  hundreds of MB during installation, which failed on many devices. 2.0.0 is
  back to the 1.2.0 packaging (uncompressed `.so`, `extractNativeLibs="false"`),
  which installs directly and only uses the APK size.
- **Linux is now a real browser:** tabs, address bar with search,
  back/forward, reload, navigation history, downloads with progress and a
  context menu to download links and media.
- **Universal APK with a higher `versionCode`**, so it can be installed over a
  per-architecture APK without uninstalling.
- iOS: native transitions, a "Liquid Glass" bar and media detection.

## Downloads

| Platform | Version | File | Requirements |
| --- | :---: | --- | --- |
| **Android** | 2.0.0 | [`FastSearchX-2.0.0-arm64-v8a.apk`](https://github.com/SysArchX/FastSearchX/releases/download/v2.0.0/FastSearchX-2.0.0-arm64-v8a.apk) (48.5 MB) | Android 7.0 (API 24)+, 64-bit phone, recommended |
| **Android** | 2.0.0 | [`FastSearchX-2.0.0-armeabi-v7a.apk`](https://github.com/SysArchX/FastSearchX/releases/download/v2.0.0/FastSearchX-2.0.0-armeabi-v7a.apk) (69.4 MB) | Android 7.0+, 32-bit device |
| **Android** | 2.0.0 | [`FastSearchX-2.0.0-android.apk`](https://github.com/SysArchX/FastSearchX/releases/download/v2.0.0/FastSearchX-2.0.0-android.apk) (168 MB) | Android 7.0+, works on any device |
| **Linux x86_64** | 2.0.1 | [`fastsearchx_2.0.1_amd64.deb`](https://github.com/SysArchX/FastSearchX/releases/download/v2.0.0/fastsearchx_2.0.1_amd64.deb) (2.9 MB) | Debian/Ubuntu with Python 3.11+, GTK 3, WebKit2GTK 4.1 and ffmpeg |
| **iOS** | 2.0.0 | [`FastSearchX-2.0.0-ios-unsigned.ipa`](https://github.com/SysArchX/FastSearchX/releases/download/v2.0.0/FastSearchX-2.0.0-ios-unsigned.ipa) (24 MB) | iOS/iPadOS 15+, **unsigned** (re-sign with your Apple ID) |

Every version is listed on the **[Releases](../../releases)** page.

> The iOS `.ipa` is produced by the GitHub Actions workflow
> (**Actions → "iOS (unsigned .ipa)"**); see [`app/IOS.md`](app/IOS.md).

> The three APKs are the **same 2.0.0 build**. The per-architecture files
> (`arm64-v8a`, `armeabi-v7a`, `x86_64`) only contain the native libraries for
> that device, so they download faster. If in doubt, use
> `FastSearchX-2.0.0-android.apk`.

### Integrity check

The current release includes a `SHA256SUMS` file with the artifact hashes.
To verify your downloads:

```bash
wget https://github.com/SysArchX/FastSearchX/releases/download/v2.0.0/SHA256SUMS
sha256sum -c SHA256SUMS
```

## Installing on Android

1. Download the APK on your phone, preferably `FastSearchX-2.0.0-arm64-v8a.apk`.
   Download it with **Chrome** or a download manager: in-app browsers inside
   messaging apps usually truncate large files.
2. Open the file and allow installation from **unknown sources** for the
   browser or file manager you used.
3. On Android 11 or newer, grant **file access** so downloads are saved to
   `Download/FastSearchX/`.

If you see **"there was a problem parsing the package"**:

- the download is incomplete: download it again and check `SHA256SUMS`;
- the device runs Android 6.x or older. FastSearchX requires Android 7.0+;
- an old TubeFetch build is installed. Uninstall it first (the package changed
  from `com.sysarchx.tubefetch` to `com.sysarchx.fastsearchx`);
- the APK is for another architecture. Try `FastSearchX-2.0.0-android.apk`.

You can also install it through ADB:

```bash
adb install FastSearchX-2.0.0-arm64-v8a.apk
```

The APK is signed with the project's release key:

```
CN=SysArchX, OU=FastSearchX, O=SysArchX, C=BR
Certificate SHA-256: c4ff9e0318a5d17a15ed67d3d2025f7752ea97e06da61201dde5ef44f42565d6
```

> **Upgrading from an older version:** 2.0.0 changed the app ID to
> `com.sysarchx.fastsearchx`. Uninstall **TubeFetch** (1.4.1 or older) before
> installing. The app's history and preferences are lost, but files already
> downloaded stay in `Download/TubeFetch`.
>
> If you installed a **per-architecture** APK and later want to switch to the
> **universal** one, installing over it works (the universal build has a higher
> `versionCode`). The other direction (universal → per-architecture) requires
> uninstalling.

## iOS (.ipa)

FastSearchX is also a Flutter app and runs on iOS: the `.ipa` is produced by a
GitHub Actions workflow on a macOS runner
(**Actions → "iOS (unsigned .ipa)" → Run workflow**).

The file comes out **unsigned** and must be re-signed with your Apple ID
(Sideloadly, AltStore or Xcode). Step by step instructions, validity limits and
the differences from Android: [`app/IOS.md`](app/IOS.md).

## Installing on Linux (.deb)

Download the `.deb` package and install it with:

```bash
sudo apt install ./fastsearchx_2.0.1_amd64.deb
```

`apt` resolves the dependencies automatically (including WebKit2GTK).
Then look for **FastSearchX** in the application menu or run:

```bash
fastsearchx
```

The app opens as a browser. The video/music downloader lives in the toolbar
download button, in the menu and in the right-click menu over links and media.
You can also set FastSearchX as your system **default browser** (the `.desktop`
file registers `x-scheme-handler/http` and `https`).

> **Install from the terminal.** The Linux Mint graphical installer
> (`Captain`/`AptKit`) and PackageKit can fail with
> `org.freedesktop.DBus.Error.NoReply` and leave the transaction stuck. That is
> a problem with the graphical installer, not the package. The command above
> installs in seconds. If the error shows up, close the installer window and
> use the terminal.
>
> Version **2.0.1** of the `.deb` removed the post-installation scripts exactly
> so it no longer depends on the graphical installer. Icons and menu entries
> are registered by the native `dpkg` triggers.

To remove it:

```bash
sudo apt remove fastsearchx
```

> **Upgrading from the old version:** if you installed the old `baixador-yt` or
> `tubefetch`, remove it first with `sudo apt remove baixador-yt tubefetch`.
> Preferences are migrated automatically on the first run.

## Features

### Android (2.0.0)

- Full browser with history, downloads and settings in the menu.
- Can be set as the Android **default browser** (http/https links).
- Download of **any file**: APK, ZIP, PDF, documents, images and
  **LocalSend** links (including HTTPS with a local certificate).
- Automatic detection of YouTube videos and of media on any site.
- **MP3 (192 kbps)** or **MP4 from 360p to 4K** downloads on YouTube.
- Video/audio downloads from **any site**: MP4, WEBM, MKV, MP3, M4A, plus
  **HLS (`.m3u8`)** and **DASH (`.mpd`)** streams handled by FFmpeg.
- **Page media** menu to pick the detected video or audio.
- Downloads screen with **real-time progress**, size, speed and cancellation,
  with no endless spinner.
- Folders organised automatically:
  - `Download/FastSearchX` for other files;
  - `Download/FastSearchX/FastSearchX_videos` for videos;
  - `Download/FastSearchX/FastSearchX_music` for music and audio.
- Detection of a link copied to the clipboard.
- Light, dark or system themes, with several accent colors.
- Browsing and download history.

### Linux: GTK 3 + WebKit2GTK (2.0.0)

- **Tabbed browser** in the Chrome style: address bar, back/forward,
  reload, home page, progress bar and shortcuts
  (`Ctrl+T`, `Ctrl+W`, `Ctrl+L`, `Ctrl+R`, `Ctrl+J`, `Ctrl+Q`, `F5`,
  `Alt+←/→`, `Ctrl+ +/−/0`).
- Google search straight from the address bar.
- **Integrated downloads** with a progress bar, cancellation and notification
  (saved in `~/Downloads`).
- Context menu (right click) to **open a link in a new tab** and
  **download a link/media/image with FastSearchX**.
- **Download video/audio from this page** button that sends the current URL to
  yt-dlp.
- Video downloads as MP4 or audio as MP3.
- Quality selection (best available, 1080p, 720p, 480p, 360p; or
  320/192/128 kbps for MP3).
- Support for full playlists or selected items only (e.g. `1-10, 15`).
- Progress bar with speed, remaining time and the current playlist item.
- Download cancellation.
- Destination folder selection and metadata embedding.
- yt-dlp **bundled in a recent version** with a menu option to update it.
- Bundled QuickJS-ng to solve YouTube's JavaScript challenges.
- Notification when finished.
- Preferences saved between runs (migrated from TubeFetch).

## Requirements (Linux)

- Python 3.11 or newer
- PyGObject (`python3-gi`), GTK 3 (`gir1.2-gtk-3.0`) and
  WebKit2GTK 4.1 (`gir1.2-webkit2-4.1`)
- `ffmpeg` (to merge video + audio and to convert to MP3)

On Debian/Ubuntu based distributions:

```bash
sudo apt install python3 python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.1 ffmpeg
```

## Run without installing (Linux)

You only need the system dependencies. On the first run, `run.sh` downloads
yt-dlp and QuickJS-ng into `vendor/` and `data/bin/`:

```bash
git clone https://github.com/SysArchX/FastSearchX.git
cd FastSearchX
./run.sh
```

If you prefer to download the dependencies first:

```bash
./packaging/fetch-deps.sh
```

## Building the .deb

```bash
./packaging/build-deb.sh
```

The script:

1. downloads yt-dlp and QuickJS-ng if they are not present yet;
2. assembles the package structure and produces
   `dist/fastsearchx_<version>_<architecture>.deb`.

## Layout

```
FastSearchX/
├── src/fastsearchx/
│   ├── browser.py        # tabbed browser (WebKit2GTK)
│   ├── downloader.py     # yt-dlp integration
│   ├── window.py         # downloader window (GTK3)
│   ├── ytdlp_loader.py   # yt-dlp/QuickJS selection
│   └── main.py           # entry point
├── data/
│   ├── com.lazlabs.FastSearchX.desktop
│   ├── fastsearchx.svg
│   ├── bin/qjs           # QuickJS-ng (downloaded by fetch-deps.sh)
│   └── icons/
├── vendor/               # bundled yt-dlp (downloaded by fetch-deps.sh)
├── packaging/
│   ├── build-deb.sh
│   ├── fetch-deps.sh
│   └── make_icons.py
├── run.sh
└── dist/                 # generated packages (git-ignored)
```

## Updating yt-dlp

In the Linux app menu, choose **Update yt-dlp**. The new version is installed
in `~/.local/share/fastsearchx/vendor` and takes priority over the bundled one.
Restart the app when asked.

## Notes

- `ffmpeg` is required to merge video + audio and to convert MP3 in the Linux
  app. On Android the conversion is done by the bundled FFmpeg.
- Solving YouTube challenges for the first time may download a small helper
  script from the EJS project, which is cached for later runs.
- This app is not affiliated with YouTube. Respect the terms of use and the
  copyright of the content you download.

## License

The code of this app is distributed under the [MIT](LICENSE) license. yt-dlp is
distributed under the Unlicense and QuickJS-ng under the MIT license.
