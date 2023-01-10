#! /bin/sh

#getting the  wifi ID and password as terminal argument

if [[ $# != 2 ]]; then
    echo "Usage: $0 wifi_connection_name wifi_conection_password"
    exit 1
fi

#Checking the output for xenial-finch

if [ -z "$(mdt devices | grep 'xenial-finch')" ]; then
    echo 'Device not found'
    exit 1
fi

# Printing out argument
echo "Attempting to connect to Wi-Fi $1"

#Connecting to the wifi using mendel
mdt exec "nmcli dev wifi connect \"$1\" password \"$2\" ifname wlan0"

#if there is no output print connected to wifi
if [ "$(mdt exec \"echo \$?\")" == "0" ]; then
    echo "Connected to Wi-Fi $1"
else
    echo "Failed to connect to Wi-Fi $1"
    exit 1
fi

echo "Connected to Wi-Fi $1"
echo "Connecting to shell..."

#Openning up the mendel shell
mdt shell
