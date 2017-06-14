#!/bin/bash

# Load credentials
CREDENTIALS="$(dirname $(realpath $0))/credentials"
source $CREDENTIALS

# Request status of Pingdom monitors
curl -s -u "$username:$userpass" -H "account-email: $accountemail" -H "App-Key: $apikey" -X GET "https://api.pingdom.com/api/2.0/checks" | jq '.checks[] | [.name, .status]' | grep -v '\[' | grep -v '\]' | sed 's/  */ /g' | sed 's/,/ =/g' | tr -d "\n" | sed 's/\" \"/"\n"/g' | sed 's/^[ \t]*//' && echo
