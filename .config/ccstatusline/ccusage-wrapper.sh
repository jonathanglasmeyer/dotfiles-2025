#!/bin/bash

# Read Claude Code JSON data from stdin
json_data=$(cat)

# Pass JSON data to ccusage and capture output (back to auto mode)
ccusage_output=$(echo "$json_data" | npx -y ccusage@latest statusline --cost-source auto 2>/dev/null)

# Check if output contains error or is too short
if [[ "$ccusage_output" == *"Invalid input"* ]] || [[ ${#ccusage_output} -lt 10 ]]; then
    echo "ccusage error"
    exit 1
fi

# Extract only session cost (most accurate for current session)
session_cost=$(echo "$ccusage_output" | sed -n 's/.*💰 \(\$[0-9.]*\) session.*/\1/p')

# Output formatted result
if [ -n "$session_cost" ]; then
    echo "$session_cost"
else
    # Fallback: show original but truncated  
    echo "$ccusage_output" | cut -c1-60
fi