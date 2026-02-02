#!/usr/bin/env bash
# Backup the deployed site, keep only the last 5 backups. Run from repo root.

BACKUP_DIR="backups"

if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Error: Backup directory $BACKUP_DIR could not be created" >&2
  exit 1
fi
if [ ! -w "$BACKUP_DIR" ]; then
  echo "Error: Backup directory $BACKUP_DIR is not writable" >&2
  exit 1
fi

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="devops-site-$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C /var/www devops-site

if [ $? -ne 0 ]; then
  echo "Error: backup failed" >&2
  exit 1
fi

echo "Backup created: $BACKUP_DIR/$BACKUP_NAME"

for f in $(ls -t "$BACKUP_DIR"/devops-site-*.tar.gz 2>/dev/null | tail -n +6); do
  rm -f "$f"
  echo "Removed old backup: $f"
done

echo "Backup done."
exit 0