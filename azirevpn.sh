#!/bin/bash

# API endpoint
API_URL="https://api.azirevpn.com/v3/locations"

# Fetch data, parse JSON with jq, format with awk
curl -s "$API_URL" \
  | jq -r '.locations[] | [.name, .city, .country, .pool, .pubkey // ""] | @tsv' \
  | awk -F'\t' '
    BEGIN {
        # Print table header
        printf("| %-10s | %-20s | %-15s | %-25s | %-44s |\n", "NAME", "CITY", "COUNTRY", "POOL", "PUBKEY")
        printf("|------------|----------------------|-----------------|---------------------------|--------------------------------------------|\n")
    }
    {
        # Print table rows
        printf("| %-10s | %-20s | %-15s | %-25s | %-44s |\n", $1, $2, $3, $4, $5)
    }
' > README.md
