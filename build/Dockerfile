FROM ubuntu:20.04 AS base

RUN apt-get update && \
  apt-get install -y --no-install-recommends jq mosquitto-clients iputils-ping curl gnupg ca-certificates tzdata && \
  curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
  apt-get install -y --no-install-recommends speedtest && \
  apt-get purge -y --auto-remove curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY entrypoint.sh .
COPY healthcheck.sh .
# ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
CMD /bin/sh -c /app/entrypoint.sh

HEALTHCHECK --interval=5m --timeout=30s --start-period=30s --retries=3 \
  CMD /bin/bash /app/healthcheck.sh