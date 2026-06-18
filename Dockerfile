# Étape 1 : téléchargement et extraction du binaire FFmpeg statique.
# Cette étape utilise une image Debian classique (curl, tar disponibles),
# car l'image n8n récente (v2.x) est distroless et n'a aucun de ces outils.
FROM debian:bookworm-slim AS ffmpeg-downloader

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl xz-utils ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
    && mkdir -p /tmp/ffmpeg-extract \
    && tar -xf /tmp/ffmpeg.tar.xz -C /tmp/ffmpeg-extract --strip-components=1

# Étape 2 : image n8n finale (récente, distroless). On copie uniquement les
# deux binaires déjà compilés depuis l'étape précédente, sans exécuter aucune
# commande shell ici puisque cette image n'a ni gestionnaire de paquets ni
# utilitaires de base.
FROM n8nio/n8n:latest

COPY --from=ffmpeg-downloader /tmp/ffmpeg-extract/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-downloader /tmp/ffmpeg-extract/ffprobe /usr/local/bin/ffprobe
