#!/usr/bin/env bash
# Builds the FastSearchX .deb package.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VERSION="$(PYTHONPATH="$ROOT/src" python3 -c 'import fastsearchx; print(fastsearchx.APP_VERSION)')"
ARCH="$(dpkg --print-architecture)"
PKG_NAME="fastsearchx_${VERSION}_${ARCH}"
STAGE="$ROOT/build/$PKG_NAME"
DIST="$ROOT/dist"

echo "==> Version: $VERSION | Architecture: $ARCH"

# ----------------------------------------------------------------------
# Bundled dependencies
# ----------------------------------------------------------------------
"$ROOT/packaging/fetch-deps.sh"

QJS="$ROOT/data/bin/qjs"

# ----------------------------------------------------------------------
# Package structure
# ----------------------------------------------------------------------
rm -rf "$STAGE"
mkdir -p "$STAGE/DEBIAN"
mkdir -p "$STAGE/usr/bin"
mkdir -p "$STAGE/usr/lib/fastsearchx"
mkdir -p "$STAGE/usr/share/applications"
mkdir -p "$STAGE/usr/share/doc/fastsearchx"

cp -a "$ROOT/src/fastsearchx" "$STAGE/usr/lib/fastsearchx/"
find "$STAGE/usr/lib/fastsearchx" -type d -name "__pycache__" -prune -exec rm -rf {} +
find "$STAGE/usr/lib/fastsearchx" -type f -name "*.pyc" -delete

cp -a "$ROOT/vendor" "$STAGE/usr/lib/fastsearchx/vendor"
find "$STAGE/usr/lib/fastsearchx/vendor" -type d -name "__pycache__" -prune -exec rm -rf {} +
find "$STAGE/usr/lib/fastsearchx/vendor" -type f -name "*.pyc" -delete

install -Dm755 "$QJS" "$STAGE/usr/lib/fastsearchx/bin/qjs"

cat > "$STAGE/usr/bin/fastsearchx" <<'LAUNCHER'
#!/bin/sh
export PYTHONPATH="/usr/lib/fastsearchx${PYTHONPATH:+:$PYTHONPATH}"
exec python3 -m fastsearchx "$@"
LAUNCHER
chmod 755 "$STAGE/usr/bin/fastsearchx"

install -Dm644 "$ROOT/data/com.lazlabs.FastSearchX.desktop" \
    "$STAGE/usr/share/applications/com.lazlabs.FastSearchX.desktop"

for SIZE in 16 24 32 48 64 128 256 512; do
    ICON="$ROOT/data/icons/fastsearchx-${SIZE}.png"
    if [ -f "$ICON" ]; then
        install -Dm644 "$ICON" \
            "$STAGE/usr/share/icons/hicolor/${SIZE}x${SIZE}/apps/fastsearchx.png"
    fi
done
install -Dm644 "$ROOT/data/fastsearchx.svg" \
    "$STAGE/usr/share/icons/hicolor/scalable/apps/fastsearchx.svg"

install -Dm644 "$ROOT/README.md" "$STAGE/usr/share/doc/fastsearchx/README.md"
install -Dm644 "$ROOT/vendor/yt_dlp-2026.10.26.dist-info/licenses/LICENSE" \
    "$STAGE/usr/share/doc/fastsearchx/copyright-yt-dlp" 2>/dev/null || true

# Consistent permissions (files 644; executables 755)
find "$STAGE/usr" -type d -exec chmod 755 {} +
find "$STAGE/usr" -type f -exec chmod 644 {} +
chmod 755 "$STAGE/usr/bin/fastsearchx" "$STAGE/usr/lib/fastsearchx/bin/qjs"

# ----------------------------------------------------------------------
# Controle do pacote
# ----------------------------------------------------------------------
INSTALLED_SIZE="$(du -sk --exclude=DEBIAN "$STAGE" | cut -f1)"

cat > "$STAGE/DEBIAN/control" <<EOF
Package: fastsearchx
Version: $VERSION
Section: web
Priority: optional
Architecture: $ARCH
Installed-Size: $INSTALLED_SIZE
Depends: python3 (>= 3.11), python3-gi, gir1.2-gtk-3.0, gir1.2-webkit2-4.1, ffmpeg
Recommends: python3-pip, yt-dlp, xdg-utils
Maintainer: LazLabs <lazlabs@localhost>
Description: Chrome-style browser with a video and music downloader
 Tabbed browser (WebKit2GTK) that also downloads videos (MP4) and music
 (MP3) from YouTube links and playlists. Uses the bundled yt-dlp, with
 progress, cancellation, quality selection, playlist item selection
 and yt-dlp updates.
EOF

# No post-installation scripts: desktop/icon caches are updated
# by the dpkg triggers (desktop-file-utils and hicolor-icon-theme).
# This avoids any chance of the graphical installer hanging (AptKit/PackageKit).

# ----------------------------------------------------------------------
# Empacotamento
# ----------------------------------------------------------------------
mkdir -p "$DIST"
dpkg-deb --build --root-owner-group "$STAGE" "$DIST/$PKG_NAME.deb"

echo
echo "==> Package created: $DIST/$PKG_NAME.deb"
echo "    Size: $(du -h "$DIST/$PKG_NAME.deb" | cut -f1)"
echo
echo "Instale com:"
echo "    sudo apt install \"$DIST/$PKG_NAME.deb\""
