#!/bin/bash

WEBHOOK_URL="YOUR_GOOGLE_CHAT_WEBHOOK_URL"  # Replace with your webhook URL
PROCESS_NAME="notifier.sh"
CPU_THRESHOLD=70
MEM_THRESHOLD=70

send_notification() {
    local message=$1
    local json_payload=$(jq -n --arg text "$message" '{text: $text}')
    curl -s -X POST -H "Content-Type: application/json" -d "$json_payload" "$WEBHOOK_URL"
}

while true; do
    resource_usage=$(ps aux | grep $PROCESS_NAME | grep -v grep | awk '{cpu+=$3; mem+=$4} END {print cpu, mem}')
    cpu_usage=$(echo $resource_usage | awk '{print $1}')
    mem_usage=$(echo $resource_usage | awk '{print $2}')

    if [[ -n $cpu_usage && -n $mem_usage ]]; then
        if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
            send_notification "High CPU usage detected for $PROCESS_NAME: ${cpu_usage}%"
        fi

        if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
            send_notification "High memory usage detected for $PROCESS_NAME: ${mem_usage}%"
        fi
    fi

    sleep 300
done
