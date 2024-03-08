#!/bin/bash

# Perform actions to generate diff, author ID, and reviewer details
diff_data=$(git diff HEAD^ HEAD)
author_id=$(git log --format="%an" -n 1)
# Fetch the login of the repository owner
repo_owner_login=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}" \
  | jq -r '.owner.login')

# Fetch the login of the first reviewer
reviewer_login=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${GITHUB_PR_NUMBER}/reviews" \
  | jq -r '.[0].user.login')

# Set reviewer_details to the owner's login if they are the first reviewer
reviewer_details="$reviewer_login"
if [ "$reviewer_login" == "$repo_owner_login" ]; then
  reviewer_details="Repository Owner"
fi
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
