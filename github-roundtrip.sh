#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: A commit message argument is required."
  exit 1 
fi

commit_message="$1"

git add .github/ scripts

if git commit -m "$commit_message"; then
  git push
else
  echo "Error: Git commit failed."
  exit 1
fi

exit 0 