FROM ghcr.io/containerpak/sdk-node-lts:main AS build

ARG DEBIAN_FRONTEND=noninteractive

ADD --checksum=sha256:822b3e5cec8bd41a7d2f4ff1709f1e9e789c6e5e4e23e058443b22f8f6e07ead https://registry.npmjs.org/openclaw/-/openclaw-2026.7.2-beta.4.tgz /tmp/openclaw.tgz

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential git python3 && \
    npm install -g /tmp/openclaw.tgz

FROM ubuntu:26.04 AS assets

ADD --checksum=sha256:b2a9900bd47ba9140f6215e65a2d92776b145c24bb61218a40b2ce9755915de9 https://avatars.githubusercontent.com/u/252820863?v=4&size=512 /tmp/openclaw.png

FROM ghcr.io/containerpak/base:main

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl xdg-utils && \
    cpak-clean-junk

COPY --from=build /usr/local/lib/node_modules/openclaw /opt/openclaw
COPY --from=build /usr/local/bin/node /usr/local/bin/node
COPY --from=assets /tmp/openclaw.png /usr/share/icons/hicolor/512x512/apps/ai.openclaw.OpenClaw.png
COPY openclaw /usr/bin/openclaw
COPY openclaw-desktop /usr/bin/openclaw-desktop
COPY ai.openclaw.OpenClaw.desktop /usr/share/applications/ai.openclaw.OpenClaw.desktop
