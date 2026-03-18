#!/bin/bash

# To download cookies:
#   1. Get the chrome extension "Get cookies.txt LOCALLY"
#   2. Navigate to youtube.com
#   3. Click on extension, and click "export"
#   4. Move txt file to this server

yt-dlp --cookies www.youtube.com_cookies.txt -f "best[ext=mp4]" "https://www.youtube.com/watch?v=nfAqiOVxpDM&t=235s"
