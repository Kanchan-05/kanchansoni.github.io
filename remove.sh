#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 page_to_remove.html"
  echo "Example: $0 tools.html"
  exit 1
fi

# Input
REMOVE_PAGE="$1"

# Build match string to look for
PATTERN="href=[\"']$REMOVE_PAGE[\"']"

# Loop through all HTML files and remove matching nav link
for file in *.html; do
  echo "Updating $file..."
  awk -v pattern="$PATTERN" '!($0 ~ pattern)' "$file" > tmp && mv tmp "$file"
done

echo "✅ Removed links to '$REMOVE_PAGE' from all HTML files."