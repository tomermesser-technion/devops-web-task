#!/usr/bin/env bash
# Restore the previous deployment from backups. Run from repo root.

BACKUP_DIR="backups"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Error: Backup directory $BACKUP_DIR not found" >&2
  exit 1
fi

PREVIOUS_BACKUP=$(ls -t "$BACKUP_DIR"/devops-site-*.tar.gz 2>/dev/null | sed -n '2p')

if [ -z "$PREVIOUS_BACKUP" ] || [ ! -f "$PREVIOUS_BACKUP" ]; then
  echo "Error: No previous backup found (need at least 2 backups)" >&2
  exit 1
fi

echo "Restoring previous deployment from: $PREVIOUS_BACKUP"

# Extract backup over current site (overwrites /var/www/devops-site)
tar -xzf "$PREVIOUS_BACKUP" -C /var/www

if [ $? -ne 0 ]; then
  echo "Error: Restore failed" >&2
  exit 1
fi

echo "Roll-back done. Site and deployment-version.txt are now from the previous backup."
exit 0