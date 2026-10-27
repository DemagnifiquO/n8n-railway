FROM n8nio/n8n:latest

USER root

# Re-emable apk package manager and install required font/system libraries for rendering
RUN ARCH=$(uname -m) && \
    wget -qO- "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk && \
    ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main \
    -U --allow-untrusted add apk-tools && \
    rm -rf sbin apk-tools-static-*.apk

RUN apk add --no-cache \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    dbus

# Remove any custom executable path overrides so Puppeteer uses its auto-downloaded cache
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true

USER node

# Force npm/puppeteer to install the matching browser binary into the node user cache path
RUN npx puppeteer browsers install chrome
