# FastSearchX on iOS (.ipa)

The `.ipa` is produced on a **macOS** GitHub Actions runner, because the iOS
build only exists with Xcode (there is no way to compile iOS on Linux, nor to
"convert" the APK).

## Producing the .ipa

1. Open **Actions → "iOS (unsigned .ipa)" → Run workflow**.
2. Wait ~20–40 min (the FFmpeg pod downloads ~49 MB of frameworks).
3. Download the **`FastSearchX-ios-unsigned-ipa`** artifact at the bottom of the run page.

The artifact contains `FastSearchX-<version>-ios-unsigned.ipa` and its `.sha256`.
It comes out **unsigned** — Apple only installs apps signed by an Apple ID.

## Installing on the iPhone

| Tool | Where it runs | Account | App validity |
| --- | --- | --- | --- |
| [Sideloadly](https://sideloadly.io) | Windows/macOS | Free Apple ID | 7 days (renew) |
| [AltStore](https://altstore.io) + AltServer | Windows/macOS | Free Apple ID | 7 days (renews by itself while AltServer is running) |
| Xcode → *Window → Devices and Simulators* → "+" | macOS | Free Apple ID | 7 days |
| TestFlight / Ad Hoc | macOS | **Paid** Apple Developer (US$ 99/year) | 90 days / 1 year |

First install: on the iPhone, go to **Settings → General → VPN & Device
Management → trust the developer**.

## Local build (if you have a Mac)

```bash
cd app
flutter pub get
cd ios && pod install && cd ..
flutter build ipa --release      # signed, requires an Apple account
flutter build ios --release --no-codesign   # unsigned, to re-sign
```

## What differs on iOS compared to Android

- **Downloads** go to `Documents/FastSearchX` inside the sandbox and show up in
  the **Files** app under *On My iPhone → FastSearchX* (enabled by
  `UIFileSharingEnabled` in `Info.plist`).
- **Default browser** cannot be registered by an app on iOS; the matching
  settings item only appears on Android.
- The `Download/FastSearchX*` folders on Android shared storage do not exist on
  iOS (`MANAGE_EXTERNAL_STORAGE` is Android-only).
- Plain HTTP is allowed through `NSAppTransportSecurity` (the equivalent of
  Android's `usesCleartextTraffic`).

## Known iOS limitations

- App Store: an app that downloads videos from "any site" is likely to be
  rejected in review. For personal use, use sideloading/TestFlight.
- Without a paid account the app expires every 7 days and the limit is 3 apps per Apple ID.
