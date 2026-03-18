#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 VIDEO_URL"
    exit 1
fi

URL="$1"

yt-dlp -x --audio-format mp3 \
--embed-metadata \
--embed-thumbnail \
-o "%(title)s.%(ext)s" \
"$URL"
