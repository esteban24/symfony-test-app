#!/bin/bash

# Start SonarQube in the background
echo "Starting SonarQube..."
/opt/sonarqube/docker/entrypoint.sh &

SONAR_PID=$!

# Execute custom scripts
echo "Running custom initialization scripts..."
"/change_default_password.sh"

# Now, wait for SonarQube process to end (if it ever does)
wait $SONAR_PID