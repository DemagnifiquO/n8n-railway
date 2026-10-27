FROM n8nio/n8n:latest

USER root

# Install system dependencies required for Chromium rendering on Alpine
RUN apk add --no-cache \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    dbus

USER node

# Automatically download the exact browser version required by Puppeteer during the build
RUN npx puppeteer browsers install chrome
