#!/bin/bash
# Block git push to main/master branches (except in Hugo, which always pushes to master)
repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

# Hugo is Steve's knowledge base — always pushes to master
if [[ "$repo_root" == */hugo ]]; then
  echo '{}'
  exit 0
fi

branch=$(git symbolic-ref --short HEAD 2>/dev/null)
if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  printf '{"continue":false,"stopReason":"Blocked: refusing to push to %s. Use a feature branch, or ask Steve if this push to %s is intentional."}' "$branch" "$branch"
else
  echo '{}'
fi
