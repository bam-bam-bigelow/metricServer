#!/bin/bash

# Variables
DOC="develserver_capacity"
PERIOD_FILTER_START=1723730401
TPARAMS="textserver_capacity"
SAVED_FILTERS=""
OUTPUT_FILE="./static/output_file.txt" # Change this to the actual path where you want to save the file

# Capture current time, CPU usage, memory usage, and disk usage
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}') # CPU usage in percentage
MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f\n", $3/$2 * 100.0)}') # Memory usage in percentage
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g') # Disk usage in percentage

# New entry to be added
NEW_ENTRY="band=server_stat time=$CURRENT_TIME cpu=$CPU_USAGE us_mem=$MEM_USAGE ud=$DISK_USAGE"

# Ensure the file exists
if [ ! -f "$OUTPUT_FILE" ]; then
    # If the file doesn't exist, create it with initial headers
    cat <<EOF > "$OUTPUT_FILE"
doc=$DOC
period_filter_start=$PERIOD_FILTER_START
tparams=$TPARAMS
saved_filters=$SAVED_FILTERS
EOF
fi

# Read existing entries and filter out the first 4 header lines
CURRENT_ENTRIES=$(tail -n +5 "$OUTPUT_FILE")

# Count the number of existing "band=server_stat ..." lines
LINE_COUNT=$(echo "$CURRENT_ENTRIES" | wc -l)

# Maximum number of lines (48 lines)
MAX_LINES=48

# Manage the number of entries
if [ "$LINE_COUNT" -ge "$MAX_LINES" ]; then
    # Remove the oldest line (first line after headers)
    UPDATED_ENTRIES=$(echo "$CURRENT_ENTRIES" | tail -n +2)
else
    UPDATED_ENTRIES="$CURRENT_ENTRIES"
fi

# Append the new entry
UPDATED_ENTRIES="$UPDATED_ENTRIES
$NEW_ENTRY"

# Write the updated lines back to the file, including the initial headers
cat <<EOF > "$OUTPUT_FILE"
doc=$DOC
period_filter_start=$PERIOD_FILTER_START
tparams=$TPARAMS
saved_filters=$SAVED_FILTERS
$UPDATED_ENTRIES
EOF