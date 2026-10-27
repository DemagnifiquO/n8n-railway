FROM n8nio/n8n:latest

USER root

# Enable apk package manager in n8n's Alpine runtime
RUN ARCH=$(uname -m) && \
    wget -qO- "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk && \
    ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main \
    -U --allow-untrusted add apk-tools && \
    rm -rf sbin apk-tools-static-*.apk

# Install Chromium and required font/system libraries
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    dbus

# Point Puppeteer globally to system Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true

USER node
