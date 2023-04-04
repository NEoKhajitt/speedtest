FROM ubuntu:lunar as base
RUN apt-get update && apt-get install -y --no-install-recommends --no-upgrade speedtest-cli jq mosquitto-clients && apt-get clean
WORKDIR /app
COPY entrypoint.sh .
CMD /bin/sh -c /app/entrypoint.sh
