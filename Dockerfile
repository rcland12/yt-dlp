FROM python:3.14-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        ffmpeg \
        unzip && \
    rm -rf /var/lib/apt/lists/*

RUN export DENO_INSTALL=/usr/local && \
    curl -fsSL https://deno.land/install.sh | sh && \
    deno --version

RUN pip install --no-cache-dir mutagen yt-dlp

COPY single.sh /usr/local/bin/single
COPY playlist.sh /usr/local/bin/playlist
COPY video.sh /usr/local/bin/video
RUN chmod +x /usr/local/bin/single /usr/local/bin/playlist /usr/local/bin/video

ENV HOME=/tmp
ENV XDG_CACHE_HOME=/tmp/.cache

WORKDIR /downloads
