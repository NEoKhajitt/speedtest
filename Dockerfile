FROM ubuntu:lunar as base
RUN apt-get update && apt-get install -y --no-upgrade speedtest-cli jq mosquitto-clients iputils-ping && apt-get clean
WORKDIR /app
COPY entrypoint.sh .
CMD /bin/sh -c /app/entrypoint.sh
