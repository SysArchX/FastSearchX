"""Locates and imports the yt-dlp version used by the application.

Preference order:

1. ``FASTSEARCHX_VENDOR`` (environment variable, useful for tests);
2. ``~/.local/share/fastsearchx/vendor`` (version updated by the user);
3. ``/usr/lib/fastsearchx/vendor`` (version bundled in the .deb package);
4. ``vendor/`` next to the source code (development mode);
5. yt-dlp installed on the system.
"""

from __future__ import annotations

import os
import shutil
import sys
from pathlib import Path


def _vendor_candidates():
    env = os.environ.get("FASTSEARCHX_VENDOR")
    if env:
        yield Path(env).expanduser()
    yield Path.home() / ".local" / "share" / "fastsearchx" / "vendor"
    yield Path.home() / ".local" / "share" / "tubefetch" / "vendor"
    yield Path("/usr/lib/fastsearchx/vendor")
    yield Path(__file__).resolve().parent.parent.parent / "vendor"


def _qjs_candidates():
    yield Path.home() / ".local" / "share" / "fastsearchx" / "bin" / "qjs"
    yield Path.home() / ".local" / "share" / "tubefetch" / "bin" / "qjs"
    yield Path("/usr/lib/fastsearchx/bin/qjs")
    yield Path(__file__).resolve().parent.parent.parent / "data" / "bin" / "qjs"
    system = shutil.which("qjs")
    if system:
        yield Path(system)


def _find_qjs() -> str | None:
    for candidate in _qjs_candidates():
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return str(candidate)
    return None


def _setup_path() -> str | None:
    for path in _vendor_candidates():
        if (path / "yt_dlp" / "__init__.py").is_file():
            entry = str(path)
            if entry not in sys.path:
                sys.path.insert(0, entry)
            return entry
    return None


_VENDOR_PATH = _setup_path()

QJS_PATH = _find_qjs()

import yt_dlp  # noqa: E402  (must come after the sys.path adjustment)

YTDLP_VERSION: str = yt_dlp.version.__version__

if _VENDOR_PATH:
    user_vendor = str(Path.home() / ".local" / "share" / "fastsearchx" / "vendor")
    if _VENDOR_PATH == user_vendor:
        YTDLP_ORIGIN = "updated by the user"
    elif _VENDOR_PATH.startswith("/usr/lib/fastsearchx"):
        YTDLP_ORIGIN = "embutido no aplicativo"
    else:
        YTDLP_ORIGIN = "development mode"
else:
    YTDLP_ORIGIN = "installed on the system"
