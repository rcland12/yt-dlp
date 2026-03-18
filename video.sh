#!/usr/bin/env bash

# To download cookies:
#   1. Get the chrome extension "Get cookies.txt LOCALLY"
#   2. Navigate to youtube.com
#   3. Make sure you are logged in
#   4. Click on extension, and click "export"
#   5. Move txt file to this server

set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"
COOKIE_FILE="www.youtube.com_cookies.txt"
FORMAT="best[ext=mp4]"

print_help() {
  cat <<EOF
Usage:
  $SCRIPT_NAME [OPTIONS] URL [URL ...]

Download one or more YouTube videos with yt-dlp using a cookies.txt file.

Arguments:
  URL                 One or more video URLs to download

Options:
  -c, --cookies FILE  Path to cookies.txt file
  -f, --format FORMAT yt-dlp format selector
  -h, --help          Show this help message and exit

Examples:
  $SCRIPT_NAME "https://www.youtube.com/watch?v=nfAqiOVxpDM&t=235s"
  $SCRIPT_NAME URL1 URL2 URL3
  $SCRIPT_NAME -c mycookies.txt URL
  $SCRIPT_NAME -f "bv*+ba/b" URL
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
  local -a urls=()

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
      -f|--format)
        shift
        [[ $# -gt 0 ]] || die "Missing value after --format"
        FORMAT="$1"
        ;;
      --)
        shift
        while [[ $# -gt 0 ]]; do
          urls+=("$1")
          shift
        done
        break
        ;;
      -*)
        die "Unknown option: $1. Use --help for usage."
        ;;
      *)
        urls+=("$1")
        ;;
    esac
    shift
  done

  require_cmd yt-dlp

  [[ -f "$COOKIE_FILE" ]] || die "Cookie file not found: $COOKIE_FILE"
  [[ ${#urls[@]} -gt 0 ]] || die "No URL provided. Use --help for usage."

  yt-dlp \
    --cookies "$COOKIE_FILE" \
    --no-mtime \
    --continue \
    --no-overwrites \
    --format "$FORMAT" \
    "${urls[@]}"
}

main "$@"
