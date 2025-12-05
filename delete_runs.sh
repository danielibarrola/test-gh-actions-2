#!/bin/bash

# Check if a workflow name was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <workflow-name-or-filename>"
  echo "Example: $0 main.yml"
  echo "Example: $0 \"CI Build\""
  exit 1
fi

WORKFLOW_NAME="$1"

echo "Fetching runs for workflow: $WORKFLOW_NAME..."

# 1. Get all runs for the specific workflow
# --limit 1000: Increases the fetch limit (default is usually 30)
# --json databaseId: Only fetch the ID field
# --jq: Parse the JSON to return only raw IDs, separated by newlines
RUN_IDS=$(gh run list --workflow "$WORKFLOW_NAME" --limit 1000 --json databaseId --jq '.[].databaseId')

# Check if any runs were found
if [ -z "$RUN_IDS" ]; then
  echo "No runs found for workflow: $WORKFLOW_NAME"
  exit 0
fi

COUNT=$(echo "$RUN_IDS" | wc -l)
echo "Found $COUNT runs. Deleting..."

# 2. Delete the runs
# We pipe the IDs into xargs to execute the delete command for each ID
echo "$RUN_IDS" | xargs -I{} gh run delete {}

echo "Done."