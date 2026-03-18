FROM python:3.14-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir yt-dlp

COPY single.sh /usr/local/bin/single
COPY playlist.sh /usr/local/bin/playlist
COPY video.sh /usr/local/bin/video
RUN chmod +x /usr/local/bin/single /usr/local/bin/playlist /usr/local/bin/video

WORKDIR /downloads
