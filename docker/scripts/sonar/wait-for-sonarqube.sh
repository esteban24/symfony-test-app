#!/bin/bash
# Poll SonarQube server status and health until it's fully operational
max_attempts=60  # Increase attempts if necessary
attempt=0
while true; do
  status=$(curl -s -u $SONARQUBE_USERNAME:$SONARQUBE_PASSWORD "$SONARQUBE_URL/api/system/status" | grep -o '"status":"UP"')
  health=$(curl -s -u $SONARQUBE_USERNAME:$SONARQUBE_PASSWORD "$SONARQUBE_URL/api/system/health" | grep -o '"health":"GREEN"')
  if [[ $status && $health ]]; then
    echo "SonarQube server is up and healthy."
    break
  elif [ $attempt -ge $max_attempts ]; then
    echo "SonarQube server did not become fully operational after $max_attempts attempts. Exiting."
    exit 1
  else
    echo "Waiting for SonarQube server to become fully operational..."
    sleep 10  # Increase sleep time if necessary
    ((attempt++))
  fi
done

echo "Proceeding to check login."

# Attempt to log in with the provided credentials
response=$(curl -s -o /dev/null -w "%{http_code}" -u $SONARQUBE_USERNAME:$SONARQUBE_PASSWORD "$SONARQUBE_URL/api/authentication/validate")

# Check if the login was successful
if [[ "$response" -ge 200 && "$response" -lt 300 ]]; then
  echo "Successfully logged into SonarQube."
else
  echo "Failed to log into SonarQube. HTTP response code: $response"
fi

echo "SonarQube is ready."

# Execute Sonar Scanner (pass any arguments to the script)
sonar-scanner "$@"