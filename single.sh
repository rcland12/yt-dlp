#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"

print_help() {
  cat <<EOF
Usage:
  $SCRIPT_NAME URL

Download a YouTube video as MP3 using yt-dlp.

Arguments:
  URL         URL of the video to download

Options:
  -h, --help  Show this help message and exit

Examples:
  $SCRIPT_NAME "https://www.youtube.com/watch?v=..."
EOF
}

die() {
  echo "Error: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

main() {
  local url=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        print_help
        exit 0
        ;;
      -*)
        die "Unknown option: $1. Use --help for usage."
        ;;
      *)
        [[ -z "$url" ]] || die "Too many arguments. Use --help for usage."
        url="$1"
        ;;
    esac
    shift
  done

  [[ -n "$url" ]] || die "No URL provided. Use --help for usage."

  require_cmd yt-dlp
  require_cmd ffmpeg

  yt-dlp \
    -x \
    --audio-format mp3 \
    --embed-metadata \
    --embed-thumbnail \
    --no-mtime \
    --continue \
    --no-overwrites \
    -o "%(title)s.%(ext)s" \
    "$url"
}

main "$@"
