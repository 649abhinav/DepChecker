curl -s -H "Authorization: token <---EDIT-THIS-AND-PLACE-GITHUB-ACCESS-TOKEN->" "https://api.github.com/orgs/<--EDIT-THIS-WITH-REPO-YOU-TO-DOWNLOAD->/repos?per_page=200&page=1,2,3,4" | jq -r '.[].clone_url' | xargs -L1 git clone 
find . -type f -name package.json -exec sh -c 'jq -r "if has(\"dependencies\") then .dependencies | keys_unsorted[] | sub(\".*/\"; \"\") else empty end" $1; jq -r "if has(\"devDependencies\") then .devDependencies | keys_unsorted[] | sub(\".*/\"; \"\") else empty end" $1' _ {} \; | grep -v "@" | xargs -n1 -I{} echo "https://registry.npmjs.org/{}" | httpx -status-code -silent -content-length -mc 404
