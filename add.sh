#!/bin/bash

# Usage check
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 newpage.html 'InsertAfterLabel'"
  echo "Example: $0 tools.html 'Research'"
  exit 1
fi

# Inputs
NEW_PAGE="$1"
AFTER_LABEL="$2"
NEW_LABEL="${NEW_PAGE%%.*}"  # derive link label from filename, e.g., tools.html → tools
NEW_LABEL="$(tr '[:lower:]' '[:upper:]' <<< ${NEW_LABEL:0:1})${NEW_LABEL:1}" # Capitalize

NAV_LINE="            <li><a href=\"$NEW_PAGE\">$NEW_LABEL</a></li>"

# Process each HTML file
for file in *.html; do
  echo "Updating $file..."

  awk -v navline="$NAV_LINE" -v label="$AFTER_LABEL" '
    BEGIN { done=0 }
    {
      print
      if (!done && match($0, "<li><a href=.*>" label "</a></li>")) {
        print navline
        done=1
      }
    }
  ' "$file" > tmp && mv tmp "$file"
done

echo "✅ Inserted link to '$NEW_PAGE' after label '$AFTER_LABEL' in all HTML files."