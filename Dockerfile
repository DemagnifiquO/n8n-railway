FROM n8nio/n8n:latest

USER root

# Install system Chromium and rendering fonts on Alpine Linux
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    dbus

# Point Puppeteer globally to the system Chromium binary path
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true

USER node
