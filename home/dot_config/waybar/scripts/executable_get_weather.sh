#!/usr/bin/env bash
set -u

# Function to get city from IP (fallback: error message)
get_city() {
  curl -s https://ipinfo.io/city || echo ""
}

LOCATION="$(get_city)"

if [[ -z "$LOCATION" ]]; then
  echo '{"text":"error", "tooltip":"Failed to detect location"}'
  exit 1
fi

# Try fetching weather up to 5 times
for i in {1..5}; do
  text=$(curl -fs "https://wttr.in/${LOCATION}?format=1&u") && \
  tooltip=$(curl -fs "https://wttr.in/${LOCATION}?format=4&u")

  if [[ $? == 0 ]]; then
    text=$(echo "$text" | tr -s ' ')
    tooltip=$(echo "$tooltip" | tr -s ' ')
    echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
    exit 0
  fi

  sleep 2
done

echo "{\"text\":\"error\", \"tooltip\":\"Failed to fetch weather for $LOCATION\"}"
exit 1
