# yt-dlp Scripts

A collection of bash scripts for downloading YouTube content as MP3 or MP4 using [yt-dlp](https://github.com/yt-dlp/yt-dlp), packaged as a Docker image for portability.

## Scripts

| Command                         | Output                   | Cookies      |
| ------------------------------- | ------------------------ | ------------ |
| `single URL`                    | Single video → MP3       | Not required |
| `playlist [-c cookies.txt] URL` | Full playlist → MP3s     | Optional     |
| `video [OPTIONS] URL [URL ...]` | One or more videos → MP4 | Optional     |

`playlist` saves progress to `archive.txt` so interrupted downloads resume without re-downloading completed tracks.

`playlist` and `video` accept `-c, --cookies FILE` to specify a cookies file. `video` also accepts `-f, --format FORMAT` to override the yt-dlp format selector (default: `best[ext=mp4]`).

## Cookies

Certain content (age-restricted, private, or member-only) requires authentication via a browser cookie file.

**To export your cookies:**

1. Install the Chrome extension [Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc)
2. Log in to [youtube.com](https://youtube.com)
3. Click the extension → **Export**
4. Save the file as `www.youtube.com_cookies.txt` in this directory

> The `.gitignore` excludes this file to prevent it from being committed.

## Usage

### Docker (recommended)

Pull and run directly from Docker Hub — no build step required:

```bash
docker run --rm --user "$(id -u):$(id -g)" -v "$(pwd)":/downloads rcland12/yt-dlp:latest single "https://youtube.com/watch?v=..."
docker run --rm --user "$(id -u):$(id -g)" -v "$(pwd)":/downloads rcland12/yt-dlp:latest playlist "https://youtube.com/playlist?list=..."
docker run --rm --user "$(id -u):$(id -g)" -v "$(pwd)":/downloads rcland12/yt-dlp:latest video "https://youtube.com/watch?v=..."
```

### Docker Compose (local build)

The Compose file runs the container as your host user so downloaded files are owned by you. Export your UID and GID before running (add these to your shell profile to make it permanent):

```bash
export UID=$(id -u) GID=$(id -g)
```

```bash
docker compose build
```

```bash
docker compose run --rm yt-dlp single "https://youtube.com/watch?v=..."
docker compose run --rm yt-dlp playlist "https://youtube.com/playlist?list=..."
docker compose run --rm yt-dlp playlist -c www.youtube.com_cookies.txt "https://youtube.com/playlist?list=..."
docker compose run --rm yt-dlp video "https://youtube.com/watch?v=..."
docker compose run --rm yt-dlp video -f "bv*+ba/b" "https://youtube.com/watch?v=..."
```

Downloaded files are saved to the current directory on your host.

### Local

Requires `yt-dlp` and `ffmpeg` installed on the host.

```bash
./single.sh "URL"
./playlist.sh "URL"
./playlist.sh -c cookies.txt "URL"
./video.sh "URL"
```
