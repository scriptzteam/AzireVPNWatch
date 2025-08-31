#!/bin/bash
API_URL="https://api.azirevpn.com/v3/locations"

# Fetch location info
curl -s "$API_URL" \
  | jq -r '.locations[] | [.name, .city, .country, .pool, .pubkey // ""] | @tsv' \
  | while IFS=$'\t' read -r NAME CITY COUNTRY POOL PUBKEY; do
      # Resolve pool hostname to IP (may return multiple IPs)
      IPS=$(dig +short "$POOL" | paste -sd " , ")
      printf "| %-10s | %-20s | %-15s | %-25s | %-44s | %-40s |\n" \
        "$NAME" "$CITY" "$COUNTRY" "$POOL" "$PUBKEY" "$IPS"
  done > README.md

# Add table header manually
sed -i '1i| NAME       | CITY                 | COUNTRY         | POOL                      | PUBKEY                                     | IP(s)                                   |' README.md
sed -i '2i|------------|----------------------|-----------------|---------------------------|--------------------------------------------|-----------------------------------------|' README.md
