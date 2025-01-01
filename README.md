# Docker and Resource Monitoring Scripts

This repository contains scripts to monitor system and Docker container resource usage, lifecycle events, and container creation. Notifications are sent to a **Google Chat Space** using a webhook.

---

## Features

1. **Resource Monitoring**:
   - Monitors the CPU and memory usage of a specified process or Docker containers.
   - Sends a notification when thresholds are exceeded.

2. **Docker Container Lifecycle Monitoring**:
   - Tracks when a container stops, dies, or is destroyed.
   - Sends error logs and status information to the chat.

3. **New Container Notifications**:
   - Detects newly created or running Docker containers.
   - Sends container details to the chat.

4. **Systemd Service Integration**:
   - Runs all scripts as background daemons using `systemd`.

---

## Prerequisites

- **Google Chat Webhook**: Generate a webhook for your Google Chat Space.  
  Example: `https://chat.googleapis.com/v1/spaces/...`

- Install the following dependencies:
  ```bash
  sudo apt-get install jq bc -y

	•	Docker must be installed and running.

Scripts

1. Resource Monitoring

Script: resource_monitor.sh
Monitors the CPU and memory usage of a specified process and sends notifications if thresholds are exceeded.

2. Docker Container Lifecycle Monitoring

Script: docker_monitor.sh
Tracks stopped, died, or destroyed Docker containers and sends error logs or reasons for failure.

3. Container Resource Usage Monitoring

Script: container_resource_monitor.sh
Monitors the CPU and memory usage of all running Docker containers and sends alerts when thresholds are exceeded.

4. New Container Notifications

Script: notifier.sh
Sends a notification to the chat when a new container starts running.

Installation

1. Clone the Repository

git clone https://github.com/yourusername/docker-resource-monitor.git
cd docker-resource-monitor

2. Configure Webhook

Update the WEBHOOK_URL in each script with your Google Chat webhook URL:

WEBHOOK_URL="YOUR_GOOGLE_CHAT_WEBHOOK_URL"

3. Make Scripts Executable

chmod +x scripts/*.sh

4. Move Scripts to /usr/local/bin

sudo mv scripts/*.sh /usr/local/bin/

Running as Services

1. Create Systemd Services

For each script, create a corresponding service file in /etc/systemd/system.

Example for resource_monitor.sh:

sudo nano /etc/systemd/system/resource_monitor.service

Add the following:

[Unit]
Description=Resource Monitor
After=network.target

[Service]
ExecStart=/usr/local/bin/resource_monitor.sh
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target

2. Enable and Start Services

sudo systemctl daemon-reload
sudo systemctl enable resource_monitor.service
sudo systemctl start resource_monitor.service

Repeat the steps for the other scripts (docker_monitor, container_resource_monitor, notifier).

Monitoring Logs

Check logs for any service:

journalctl -u <service_name>.service

Example:

journalctl -u resource_monitor.service

Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Contact

For issues or inquiries, please contact mallasusan19@gmail.com.

This README is fully structured and GitHub-ready! Let me know if you want to adjust or add any section!
