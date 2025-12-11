#!/bin/bash

# Defaults
COUNT=${1:-5}          # Number of commits (default: 5)
DELAY=${2:-10}         # Delay in seconds (default: 10)
PUSH=${3:-true}        # Push to remote (default: true)
FILE=${4:-"activity_log.txt"} # File to update (default: activity_log.txt)

echo "Starting sequence: $COUNT commits, waiting ${DELAY}s between them."

for ((i=1; i<=COUNT; i++)); do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    CONTENT="Run #$i: $TIMESTAMP"

    # 1. Append to file
    echo "$CONTENT" >> "$FILE"
    echo ""
    echo "[$i/$COUNT] Updated $FILE"

    # 2. Git operations
    git add "$FILE"
    git commit -m "Automated update #$i - $TIMESTAMP to test culprit finder"

    if [ "$PUSH" = "true" ]; then
        echo "[$i/$COUNT] Pushing to remote..."
        git push

      # 3. Wait (if not the last iteration)
      if [ "$i" -lt "$COUNT" ]; then
          echo "Waiting $DELAY seconds..."
          sleep "$DELAY"
      fi
    fi

done

echo ""
echo "Sequence completed successfully."
