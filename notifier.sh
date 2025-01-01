#!/bin/bash

WEBHOOK_URL="YOUR_GOOGLE_CHAT_WEBHOOK_URL"  # Replace with your webhook URL

send_notification() {
    local message=$1
    local json_payload=$(jq -n --arg text "$message" '{text: $text}')
    curl -s -X POST -H "Content-Type: application/json" -d "$json_payload" "$WEBHOOK_URL"
}

docker ps --filter "status=running" --format "{{.ID}} {{.Names}}" | while read line; do
    container_id=$(echo $line | awk '{print $1}')
    container_name=$(echo $line | awk '{print $2}')

    message="✅ *Docker Notification*\n\n- **Container Name:** $container_name\n- **Status:** Running"
    send_notification "$message"
done
