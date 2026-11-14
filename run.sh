#!/bin/sh
# Runs the app from source (development mode).
set -eu
cd "$(dirname "$0")"

# Downloads the bundled yt-dlp and QuickJS-ng on the first run.
if [ ! -f vendor/yt_dlp/__init__.py ] || [ ! -x data/bin/qjs ]; then
    ./packaging/fetch-deps.sh
fi

export PYTHONPATH="$PWD/src${PYTHONPATH:+:$PYTHONPATH}"
exec python3 -m fastsearchx "$@"
