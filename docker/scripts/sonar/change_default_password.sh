#!/bin/bash

# Ensure that SONARQUBE_UI_PASSWORD is set
if [ -z "$SONARQUBE_UI_PASSWORD" ]; then
  echo "The SONARQUBE_UI_PASSWORD environment variable is not set."
  echo "Please set it to the desired new admin password."
  exit 1
fi

# Function to check SonarQube server status without jq
check_sonar_status() {
  local status=$(curl -s "http://localhost:9000/api/system/status" | grep -o '"status":"[^"]*' | grep -o '[^"]*$')
  echo $status
}

# Poll SonarQube server status until it's UP
max_attempts=30
attempt=0
while [ "$(check_sonar_status)" != "UP" ]; do  if [ $attempt -ge $max_attempts ]; then
    echo "SonarQube server did not become available after $max_attempts attempts. Exiting."
    exit 1
  fi
  echo "Waiting for SonarQube server to become available..."
  sleep 10
  ((attempt++))
done

echo "SonarQube server is up. Proceeding to change password."

# Change the SonarQube default admin password
response=$(curl -s -o /dev/null -w "%{http_code}" -u admin:admin -X POST "http://localhost:9000/api/users/change_password?login=admin&previousPassword=admin&password=$SONARQUBE_UI_PASSWORD")

# Check if the password was changed successfully
if [[ "$response" -ge 200 && "$response" -lt 300 ]]; then
  echo "The SonarQube admin password has been successfully updated."
else
  echo "Failed to change the SonarQube admin password. HTTP response code: $response"
  exit 1
fi