FROM ghcr.io/containerpak/sdk-node-lts:main AS build

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential ca-certificates curl git python3 && \
    curl -fsSL https://registry.npmjs.org/openclaw/-/openclaw-2026.7.2-beta.4.tgz \
      -o /tmp/openclaw.tgz && \
    echo '822b3e5cec8bd41a7d2f4ff1709f1e9e789c6e5e4e23e058443b22f8f6e07ead  /tmp/openclaw.tgz' | sha256sum -c - && \
    npm install -g /tmp/openclaw.tgz

FROM ghcr.io/containerpak/mesa:main

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xdg-utils && \
    curl -fsSL 'https://avatars.githubusercontent.com/u/252820863?v=4&size=512' \
      -o /usr/share/icons/hicolor/512x512/apps/ai.openclaw.OpenClaw.png && \
    echo 'b2a9900bd47ba9140f6215e65a2d92776b145c24bb61218a40b2ce9755915de9  /usr/share/icons/hicolor/512x512/apps/ai.openclaw.OpenClaw.png' | sha256sum -c - && \
    cpak-clean-junk

COPY --from=build /usr/local/lib/node_modules/openclaw /opt/openclaw
COPY --from=build /usr/local/bin/node /usr/local/bin/node
COPY openclaw /usr/bin/openclaw
COPY openclaw-desktop /usr/bin/openclaw-desktop
COPY ai.openclaw.OpenClaw.desktop /usr/share/applications/ai.openclaw.OpenClaw.desktop
