#!/usr/bin/env bash

set -euo pipefail
WORKDIR="janus-workspace"

REPOS=(
  "janus-core"
  "janus-frontend"
  "janus-cli"
  "janus-infra"
  "janus-devops"
  "janus-monitoring"
  "janus-docs"
  "janus-vault"
)

echo "[INFO] : Preparing workspace..."
mkdir -p "$HOME/$WORKDIR"
cd "$HOME/$WORKDIR"
sleep 1

echo "[INFO] : Cloning repositories..."
for repo in "${REPOS[@]}"; do
	if [ -d "$repo" ]; then
		echo "[INFO] : $repo already exists. Skipping..."
	else
		echo "[INFO] : Cloning $repo..."
		git clone git@github.com:janus-bastion/$repo.git
	fi
done
sleep 1

echo "[INFO] : Cloning repositories successfully"
echo "[INFO] : Infrastructure launch..."

cd "$HOME/$WORKDIR/janus-infra"
docker compose -f janus-compose.yaml up -d 
echo "[INFO] : Infrastructure launch completed"


cd "$HOME/$WORKDIR"

echo "[INFO] : Janus is ready!"
