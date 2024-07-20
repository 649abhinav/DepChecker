#!/bin/bash

usage() {
    echo "Usage: $0 <github_access_token> <org_name>"
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

ACCESS_TOKEN="$1"
ORG_NAME="$2"

## Fetch repositories and clone them
curl -s -H "Authorization: $ACCESS_TOKEN" "https://api.github.com/orgs/$ORG_NAME/repos?per_page=200&page=1,2,3,4" | jq -r '.[].clone_url' | xargs -L1 git clone

## find Package.json files and check all dependencies iinclude public & private
find . -type f -name package.json -exec sh -c '
jq -r "if has(\"dependencies\") then .dependencies | keys_unsorted[] | sub(\".*/\"; \"\") else empty end" $1;
jq -r "if has(\"devDependencies\") then .devDependencies | keys_unsorted[] | sub(\".*/\"; \"\") else empty end" $1' _ {} \; | grep -v "@" | xargs -n1 -I{} echo "https://registry.npmjs.org/{}" | httpx -status-code -silent -content-length -mc 404

