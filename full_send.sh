#!/bin/sh

# Install necessary packages
apk add --no-cache py3-pip
pip install pyyaml

# Read the configuration
python3 << END
import yaml
import os

with open('/app/conf/conf.yaml', 'r') as file:
    config = yaml.safe_load(file)

for service, enabled in config['services'].items():
    os.environ[f"RUN_{service.upper()}"] = str(enabled).lower()
END

# Start the database service (always runs)
docker-compose up -d database

# Start other services based on configuration
if [ "$RUN_APP" = "true" ]; then
    echo "Starting App service"
    docker-compose up -d app
fi

if [ "$RUN_SHARKPOOL_MONITOR" = "true" ]; then
    echo "Starting SharkPool Monitor service"
    docker-compose up -d sharkpool-monitor
fi

if [ "$RUN_NGINX" = "true" ]; then
    echo "Starting Nginx service"
    docker-compose up -d nginx
fi

if [ "$RUN_BONUS_APP" = "true" ]; then
    echo "Starting Bonus App service"
    docker-compose up -d bonus_app
fi

# Keep the script running
tail -f /dev/null