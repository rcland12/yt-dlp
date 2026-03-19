#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"
COOKIE_FILE="www.youtube.com_cookies.txt"
FORMAT="best[ext=mp4]"

print_help() {
  cat <<EOF
Usage:
  $SCRIPT_NAME [OPTIONS] URL [URL ...]

Download one or more YouTube videos as MP4 using yt-dlp.

Arguments:
  URL                 One or more video URLs to download

Options:
  -c, --cookies FILE  Path to cookies.txt file (default: www.youtube.com_cookies.txt)
  -f, --format FORMAT yt-dlp format selector (default: best[ext=mp4])
  -h, --help          Show this help message and exit

Examples:
  $SCRIPT_NAME "https://www.youtube.com/watch?v=..."
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

  [[ ${#urls[@]} -gt 0 ]] || die "No URL provided. Use --help for usage."

  local -a cmd=(
    yt-dlp
    --no-mtime
    --continue
    --no-overwrites
    --format "$FORMAT"
  )

  if [[ -f "$COOKIE_FILE" ]]; then
    cmd+=(--cookies "$COOKIE_FILE")
  fi

  cmd+=("${urls[@]}")

  "${cmd[@]}"
}

main "$@"
