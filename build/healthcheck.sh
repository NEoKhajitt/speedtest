#!/bin/bash

# Check speedtest CLI
speedtest --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Speedtest CLI not available"
  exit 1
fi

# Check MQTT broker
if mosquitto_pub -h "$MQTTHOST" -p "$MQTTPORT" -u "$MQTTUSER" -P "$MQTTPASSWORD" -t healthcheck -m "ok" --quiet; then
  echo "Healthy"
  exit 0
else
  echo "Degraded: MQTT unreachable"
  exit 0
fi