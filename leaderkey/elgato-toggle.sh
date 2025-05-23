#!/bin/bash
ELGATO_IP="192.168.4.134"
STATE=$(curl -s --location --request GET "http://${ELGATO_IP}:9123/elgato/lights" | jq '.lights[].on')

if [ "$STATE" == "1" ]; then
    curl -s --location --request PUT "http://${ELGATO_IP}:9123/elgato/lights" \
    --header 'Content-Type: application/json' \
    --data '{
        "lights": [
            {
                "on": 0
            }
        ]
    }' > /dev/null
else
    curl -s --location --request PUT "http://${ELGATO_IP}:9123/elgato/lights" \
    --header 'Content-Type: application/json' \
    --data '{
        "lights": [
            {
                "on": 1
            }
        ]
    }' > /dev/null
fi
