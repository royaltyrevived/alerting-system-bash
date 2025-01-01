#!/bin/bash

WEBHOOK_URL="YOUR_GOOGLE_CHAT_WEBHOOK_URL"  # Replace with your webhook URL

send_notification() {
    local message=$1
    local json_payload=$(jq -n --arg text "$message" '{text: $text}')
    curl -s -X POST -H "Content-Type: application/json" -d "$json_payload" "$WEBHOOK_URL"
}

docker events --filter 'event=stop' --filter 'event=die' --filter 'event=destroy' --format '{{json .}}' | while read -r event; do
    container_id=$(echo "$event" | jq -r '.id')
    container_name=$(docker inspect --format='{{.Name}}' "$container_id" 2>/dev/null | sed 's|/||')
    status=$(echo "$event" | jq -r '.status')
    error_log=$(docker logs "$container_id" 2>&1 | tail -n 10)

    message="⚠️ *Docker Alert*\n\n- **Container Name:** $container_name\n- **Status:** $status\n\n**Last Logs:**\n$error_log"
    send_notification "$message"
done
