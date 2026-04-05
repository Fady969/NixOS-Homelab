#!/usr/bin/env bash
set -euo pipefail

# Default host
HOST="${1}"

FLAKE="/etc/nixos/#${HOST}"
REPO_DIR="/etc/nixos"
HOSTS_DIR="/etc/nixos/hosts"

echo "Target host: $HOST"

cd $REPO_DIR

# Sanity check
if [ ! -d "${HOSTS_DIR}/${HOST}" ]; then
	echo " Host '$1' does not exist in ${HOSTS_DIR}"
	echo "Available hosts:"
	ls "${HOSTS_DIR}"
	exit 1
fi

echo "Rebuilding system..."


git add .

if sudo nixos-rebuild switch --flake "$FLAKE"; then
	echo "Rebuild successful"
else
	echo "Rebuild failed"
	git reset
	exit 1
fi


cd "$REPO_DIR"


# Check if anything is staged
if git diff --cached --quiet; then
	echo "No changes to commit"
else
	echo "Changes detected, committing..."

	git commit -m "nixos: rebuild ${HOST} $(date '+%Y-%m-%d %H:%M:%S')"

	git -c credential.helper= \
	-c "credential.helper=!f() { \
		echo username=x-access-token; \
		echo password=$(cat /run/secrets/github_token); \
		}; f" \
	push origin main
	echo "Changes committed and pushed"
fi
