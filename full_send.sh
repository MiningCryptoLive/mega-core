#!/bin/sh
set -e

# Install necessary packages
pip install pyyaml

# Read the configuration
python3 << END
import yaml
import os

try:
    with open('/app/conf/conf.yaml', 'r') as file:
        config = yaml.safe_load(file)
    for service, enabled in config.get('services', {}).items():
        os.environ[f"RUN_{service.upper()}"] = str(enabled).lower()
except Exception as e:
    print(f"Error reading configuration: {e}")
    exit(1)
END

# Function to start a service
start_service() {
    service_name=$1
    env_var="RUN_${service_name^^}"
    if [ "${!env_var}" = "true" ]; then
        echo "Starting ${service_name} service"
        docker-compose up -d "$service_name" || echo "Failed to start ${service_name}"
    else
        echo "${service_name} service is disabled in configuration"
    fi
}

# Start the database service (always runs)
echo "Starting ui-db service"
docker-compose up -d ui-db || { echo "Failed to start ui-db"; exit 1; }

# Start other services based on configuration
start_service "dash"
start_service "sharkui"
start_service "nginx"
start_service "bonus"

# Check if any services are running
if ! docker-compose ps --services --filter "status=running" | grep -q .; then
    echo "No services are running. Check your configuration and logs."
    exit 1
fi

echo "All enabled services have been started."

# Keep the script running
tail -f /dev/null