FROM n8nio/n8n:latest-debian

USER root

# Les dépôts Debian "buster" sont en fin de vie : deb.debian.org ne les sert plus.
# On bascule sur les archives, qui restent disponibles indéfiniment pour les
# versions obsolètes, afin de pouvoir installer curl/xz-utils/ca-certificates.
RUN sed -i \
    -e 's|deb.debian.org/debian-security|archive.debian.org/debian-security|g' \
    -e 's|deb.debian.org/debian|archive.debian.org/debian|g' \
    -e '/buster-updates/d' \
    -e '/buster\/updates/d' \
    /etc/apt/sources.list \
  && apt-get -o Acquire::Check-Valid-Until=false update \
  && apt-get install -y --no-install-recommends curl xz-utils ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
    && mkdir -p /tmp/ffmpeg-extract \
    && tar -xf /tmp/ffmpeg.tar.xz -C /tmp/ffmpeg-extract --strip-components=1 \
    && mv /tmp/ffmpeg-extract/ffmpeg /usr/local/bin/ffmpeg \
    && mv /tmp/ffmpeg-extract/ffprobe /usr/local/bin/ffprobe \
    && chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe \
    && rm -rf /tmp/ffmpeg.tar.xz /tmp/ffmpeg-extract

USER node
