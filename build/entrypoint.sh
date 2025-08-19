#!/bin/bash

# Only edit the following setup lines with correct login information
# Mosquitto Broker Details

mqttuser=$MQTTUSER
mqttpassword=$MQTTPASSWORD
mqttbroker=$MQTTHOST
mqttport=$MQTTPORT

# Some script options
speed_test_interval=$TEST_INTERVAL # In seconds (1800=30 minutes)
topic=$MQTTTOPIC

echo "Getting speedtest version"
speedtest_version=$(speedtest --version | head -n 1 | awk '{print $4}')
echo "Speedtest version: $speedtest_version"
echo "Running initial test with EULA"
timeout 2 speedtest --accept-license --accept-gdpr --format=json > /dev/null 2>&1 # Initial run to get license out of the way

# Will loop this code every x amount in sleep command
while true; do
    echo "Running speedtest now"

    speedtest_result=$(speedtest --format=json)

    timestamp=$(echo "$speedtest_result" | jq -r '.timestamp')
    ping_latency=$(echo "$speedtest_result" | jq '.ping.latency')
    ping_jitter=$(echo "$speedtest_result" | jq '.ping.jitter')
    download_bandwidth=$(echo "$speedtest_result" | jq '.download.bandwidth')
    upload_bandwidth=$(echo "$speedtest_result" | jq '.upload.bandwidth')
    packet_loss=$(echo "$speedtest_result" | jq '.packetLoss')
    server_name=$(echo "$speedtest_result" | jq -r '.server.name')
    server_location=$(echo "$speedtest_result" | jq -r '.server.location')
    server_country=$(echo "$speedtest_result" | jq -r '.server.country')
    isp=$(echo "$speedtest_result" | jq -r '.isp')
    result_url=$(echo "$speedtest_result" | jq -r '.result.url')

    # Convert bandwidth from bytes/sec to Mbps
    download_mbps=$(awk "BEGIN {printf \"%.2f\", $download_bandwidth/125000}")
    upload_mbps=$(awk "BEGIN {printf \"%.2f\", $upload_bandwidth/125000}")

    speedteststring='{"state":"'"$server_name"'","attributes":{"timestamp":"'"$timestamp"'","ping_latency":"'"$ping_latency"'","ping_jitter":"'"$ping_jitter"'","download_mbps":"'"$download_mbps"'","upload_mbps":"'"$upload_mbps"'","packet_loss":"'"$packet_loss"'","server_location":"'"$server_location"'","server_country":"'"$server_country"'","isp":"'"$isp"'","result_url":"'"$result_url"'","version":"'"$speedtest_version"'"}}'
    echo $speedteststring

    # Publish to MQTT Broker
    mosquitto_pub -h $mqttbroker -p $mqttport -u "$mqttuser" -P "$mqttpassword" -t $topic -m "$speedteststring" -r

    sleep $speed_test_interval
done
