#!/bin/bash

# Perform actions to generate diff, author ID, and reviewer details
diff_data=$(git diff HEAD^ HEAD)
author_id=$(git log --format="%an" -n 1)
reviewer_details=${{ github.repository_owner }}

# Create payload JSON
payload='{
  "diff": "'"$diff_data"'",
  "authorId": "'"$author_id"'",
  "reviewerDetails": "'"$reviewer_details"'"
}'

# Save payload to a file
echo "$payload" > payload.json
