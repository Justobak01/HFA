#! /bin/sh

if [[ $# != 2 ]]; then
    echo "Usage: $0 wifi_connection_name wifi_conection_password"
    exit 1
fi

if [ -z "$(mdt devices | grep 'xenial-finch')" ]; then
    echo 'Device not found'
    exit 1
fi

echo "Attempting to connect to Wi-Fi $1"

mdt exec "nmcli dev wifi connect \"$1\" password \"$2\" ifname wlan0"

if [ "$(mdt exec \"echo \$?\")" == "0" ]; then
    echo "Connected to Wi-Fi $1"
else
    echo "Failed to connect to Wi-Fi $1"
    exit 1
fi

echo "Connected to Wi-Fi $1"
echo "Connecting to shell..."

mdt shell