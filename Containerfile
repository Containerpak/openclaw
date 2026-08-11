FROM ghcr.io/containerpak/sdk-node-lts:main AS build

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential ca-certificates curl git python3 && \
    curl -fsSL https://registry.npmjs.org/openclaw/-/openclaw-2026.7.1-2.tgz \
      -o /tmp/openclaw.tgz && \
    echo '5bb525f36f471a41239615d321c441778c7e1c007018ed6d84b795be77803276  /tmp/openclaw.tgz' | sha256sum -c - && \
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
COPY openclaw /usr/bin/openclaw
COPY openclaw-desktop /usr/bin/openclaw-desktop
COPY ai.openclaw.OpenClaw.desktop /usr/share/applications/ai.openclaw.OpenClaw.desktop
