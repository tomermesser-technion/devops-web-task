#!/usr/bin/env bash
# Return 0 if site is healthy, 1 otherwise. Run from repo root.

URL="http://localhost"

if curl -sf -o /dev/null "$URL"; then
  echo "Site is healthy"
  exit 0
else
  echo "Site is not healthy" >&2
  exit 1
fi