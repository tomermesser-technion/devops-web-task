#!/usr/bin/env bash
# Copy site to web folder, bump version number, check nginx, reload. Run from repo root.

SOURCE="site"
DEST="/var/www/devops-site"
VERSION_FILE="version.txt"

if [ ! -f "$VERSION_FILE" ]; then
  echo "0" > "$VERSION_FILE"
fi

CURRENT=$(cat "$VERSION_FILE")
NEXT=$((CURRENT + 1))
echo "$NEXT" > "$VERSION_FILE"


cp -r "$SOURCE"/* "$DEST"
echo "$NEXT" > "$DEST/deployment-version.txt"
echo "Deployment version: $NEXT"

sudo nginx -t
if [ $? -ne 0 ]; then
  echo "Error: nginx config is bad"
  exit 1
fi

sudo systemctl reload nginx
if [ $? -ne 0 ]; then
  echo "Error: nginx reload failed"
  exit 1
fi

echo "Deploy done."
exit 0