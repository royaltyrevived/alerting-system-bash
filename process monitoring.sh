#!/bin/bash

WEBHOOK_URL="https://chat.googleapis.com/v1/spaces/AAAA8Q5SHX0/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=Uoog_kg0xAIZ_TerPv9FiUsZp4KuklZ6kCaoF6pmadg"
THRESHOLD=70

while true; do
  # Get CPU and Memory usage
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
  MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

  # Parse top process correctly by ensuring no misalignment
  TOP_PROCESS=$(ps -eo pid,comm,%mem,%cpu --sort=-%cpu | awk 'NR==2')
  TOP_PID=$(echo "$TOP_PROCESS" | awk '{print $1}')
  TOP_PROC_NAME=$(echo "$TOP_PROCESS" | awk '{print $2}')
  TOP_PROC_MEM=$(echo "$TOP_PROCESS" | awk '{print $3}')
  TOP_PROC_CPU=$(echo "$TOP_PROCESS" | awk '{print $4}')

  # If parsing fails, set default values for safety
  if [[ -z "$TOP_PID" || -z "$TOP_PROC_NAME" || -z "$TOP_PROC_MEM" || -z "$TOP_PROC_CPU" ]]; then
    TOP_PROC_NAME="Unknown"
    TOP_PID="N/A"
    TOP_PROC_MEM="0.0"
    TOP_PROC_CPU="0.0"
  fi

  send_alert() {
    MESSAGE="Server usage exceeded ${THRESHOLD}%!
    - CPU Usage: ${CPU_USAGE}%
    - Memory Usage: ${MEM_USAGE}%
    - Top Service: [${TOP_PROC_NAME}] (PID: ${TOP_PID}, CPU: ${TOP_PROC_CPU}%, MEM: ${TOP_PROC_MEM}%)"

    curl -X POST -H "Content-Type: application/json" \
         -d "{\"text\": \"${MESSAGE}\"}" \
         "${WEBHOOK_URL}"
  }

  # Compare CPU and memory usage with threshold
  if (( $(echo "${CPU_USAGE} > ${THRESHOLD}" | bc -l) || $(echo "${MEM_USAGE} > ${THRESHOLD}" | bc -l) )); then
    send_alert
  fi

  sleep 60  # Check every 60 seconds
done
