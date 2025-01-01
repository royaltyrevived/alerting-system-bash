#!/bin/bash

WEBHOOK_URL="YOUR_GOOGLE_CHAT_WEBHOOK_URL"  # Replace with your webhook URL
CPU_THRESHOLD=70
MEM_THRESHOLD=70

send_notification() {
    local message=$1
    local json_payload=$(jq -n --arg text "$message" '{text: $text}')
    curl -s -X POST -H "Content-Type: application/json" -d "$json_payload" "$WEBHOOK_URL"
}

while true; do
    docker stats --no-stream --format "{{.Name}} {{.CPUPerc}} {{.MemPerc}}" | while read line; do
        container_name=$(echo $line | awk '{print $1}')
        cpu_usage=$(echo $line | awk '{print $2}' | tr -d '%')
        mem_usage=$(echo $line | awk '{print $3}' | tr -d '%')

        if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
            send_notification "High CPU usage detected for $container_name: ${cpu_usage}%"
        fi

        if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
            send_notification "High memory usage detected for $container_name: ${mem_usage}%"
        fi
    done

    sleep 300
done
