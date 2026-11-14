# FastSearchX — Flutter app (Android/iOS)

Source code of the **FastSearchX** mobile app: a full browser with
media detection and a downloader (MP3/MP4) using FFmpeg and yt-dlp through an API.

- Android: browser + downloads in `Download/FastSearchX/`, can be set as the
  default browser (`http`/`https`).
- iOS: WKWebView with video/audio detection and a downloader; see
  [`IOS.md`](IOS.md) to produce the unsigned `.ipa`.

## Development

```bash
flutter pub get
flutter run
```

## Android build (signed)

Put the keystore in `android/keystore/` and create `android/key.properties`
(both are git-ignored):

```properties
storePassword=...
keyPassword=...
keyAlias=tubefetch
storeFile=keystore/fastsearchx-release.jks
```

```bash
flutter build apk --release --split-per-abi   # per-architecture APKs
flutter build apk --release                   # universal APK
```

`android/app/build.gradle.kts` packages the native libraries **uncompressed**
(`useLegacyPackaging = false`). That is intentional: with compressed `.so`
files the installer has to extract hundreds of MB and many devices show
*"there was a problem parsing the package"*.

## iOS

```bash
flutter build ios --release --no-codesign
```

The GitHub Actions workflow in `.github/workflows/ios-ipa.yml` produces the
unsigned `.ipa`.
