#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"
COOKIE_FILE=""

print_help() {
  cat <<EOF
Usage:
  $SCRIPT_NAME [OPTIONS] URL

Download a YouTube video as audio using yt-dlp.

Arguments:
  URL                 URL of the video to download

Options:
  -c, --cookies FILE  Path to cookies.txt file
  -h, --help          Show this help message and exit

Examples:
  $SCRIPT_NAME "https://www.youtube.com/watch?v=..."
  $SCRIPT_NAME -c www.youtube.com_cookies.txt "https://www.youtube.com/watch?v=..."
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
      -c|--cookies)
        shift
        [[ $# -gt 0 ]] || die "Missing value after --cookies"
        COOKIE_FILE="$1"
        ;;
      --)
        shift
        [[ $# -eq 1 ]] || die "Expected exactly one URL after --. Use --help for usage."
        url="$1"
        break
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

  local -a cmd=(
    yt-dlp
    --js-runtimes "deno:/usr/local/bin/deno"
    --remote-components ejs:github
    --cache-dir /tmp/yt-dlp-cache
    -x
    --audio-format flac
    --embed-metadata
    --embed-thumbnail
    --no-mtime
    --continue
    --no-overwrites
    -o "%(title)s.%(ext)s"
  )

  if [[ -n "$COOKIE_FILE" ]]; then
    [[ -f "$COOKIE_FILE" ]] || die "Cookie file not found: $COOKIE_FILE"
    cmd+=(--cookies "$COOKIE_FILE")
  fi

  cmd+=("$url")

  "${cmd[@]}"
}

main "$@"