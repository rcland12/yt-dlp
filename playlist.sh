#!/usr/bin/env bash
set -e

#
# playlist.sh
#
# Download a YouTube playlist as MP3 files using yt-dlp.
#
# Requirements:
#   - yt-dlp
#   - ffmpeg
#
# Usage:
#   playlist.sh PLAYLIST_URL [COOKIES_FILE]
#
# Examples:
#   playlist.sh https://www.youtube.com/playlist?list=XXXX
#
#   playlist.sh https://www.youtube.com/playlist?list=XXXX cookies.txt
#
# Cookies are only needed for:
#   - age restricted videos
#   - private playlists
#   - login required content
#
# To export cookies:
#   1. Install Chrome extension "Get cookies.txt LOCALLY"
#   2. Navigate to youtube.com
#   3. Click extension → Export
#   4. Save cookies.txt and pass it as argument
#

if [ $# -lt 1 ]; then
    echo "Usage: $0 PLAYLIST_URL [COOKIES_FILE]"
    exit 1
fi

URL="$1"
COOKIES="$2"

CMD=(
yt-dlp
-x
--audio-format mp3
--embed-metadata
--embed-thumbnail
--download-archive archive.txt
-o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"
)

if [ -n "$COOKIES" ]; then
    CMD+=(--cookies "$COOKIES")
fi

CMD+=("$URL")

"${CMD[@]}"
