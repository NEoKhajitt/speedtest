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

# Will loop this code every x amount in sleep command
while true; do

    speedtest_version=$(speedtest --version |head -n 1)
    speedtest_result=$(speedtest --json )

    download=$(echo "$speedtest_result" | jq '.download' |cut -f1 -d ".")
    upload=$(echo "$speedtest_result" | jq '.upload' |cut -f1 -d ".")
    ping_server=$(echo "$speedtest_result" | jq '.ping')
    url_test=$(echo "$speedtest_result" | jq '.server."url"' | tr -d \")
    time_run=$(echo "$speedtest_result" | jq '.timestamp' | tr -d \")
    isp=$(echo "$speedtest_result" | jq '.client.isp' | tr -d \")
    # echo $download $upload $ping_server $time_run
    # echo $url_test

    download=$(printf %.2f "$(($download/1000))e-3")
    upload=$(printf %.2f "$(($upload/1000))e-3")
    ping_server=$(printf %.3f "$ping_server")
    # echo $download $upload $ping_server $time_run
    # echo $url_test

    speedteststring='{"state":"'"$url_test"'","attributes":{"time_run":"'"$time_run"'","ping":"'"$ping_server"'","download":"'"$download"'","upload":"'"$upload"'","isp":"'"$isp"'","version":"'"$speedtest_version"'"}}'
    echo $speedteststring
    # echo "**********************************************************************************************"

    # Publish to MQTT Broker

    mosquitto_pub -h $mqttbroker -p $mqttport -u "$mqttuser" -P "$mqttpassword" -t $topic -m "$speedteststring" -r

    sleep $speed_test_interval
done
