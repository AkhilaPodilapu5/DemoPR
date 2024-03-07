#!/bin/bash

# Perform actions to generate diff, author ID, and reviewer details
diff_data=$(git diff HEAD^ HEAD)
author_id=$(git log --format="%an" -n 1)
reviewer_details=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${{ github.event.pull_request.number }}/reviews" \
  | jq -r '.[0].user.login')
pull_request_url=$(git rev-parse --show-toplevel)/.github/pull_request_url
# Create payload JSON
payload='{
  "diff": "'"$diff_data"'",
  "authorId": "'"$author_id"'",
  "reviewerDetails": "'"$reviewer_details"'"
  "pull_request_url": "'"$pull_request_url"'"
}'

# Save payload to a file
echo "$payload" > payload.json
