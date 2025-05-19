#!/usr/bin/env bash

set -euo pipefail

c0=$(tput sgr0)

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

msg() {
    local type="$1"
    shift
    local color

    case "$type" in
        INFO)    color=6 ;; 
        WARN)    color=3 ;;
        ERROR)   color=1 ;;
        SUCCESS) color=2 ;;
        DEBUG)   color=4 ;;
        *)       color=7 ;;
    esac

    tput setaf "$color"
    printf -- "[%s] : %s%s\n" "$type" "$*" "$c0"
}

msg INFO "Preparing workspace..."
mkdir -p "$HOME/$WORKDIR"
cd "$HOME/$WORKDIR"
sleep 1

msg INFO "Cloning repositories..."
for repo in "${REPOS[@]}"; do
    if [ -d "$repo" ]; then
        msg WARN "$repo already exists. Skipping..."
    else
        msg INFO "Cloning $repo..."
        git clone git@github.com:janus-bastion/$repo.git
    fi
done
sleep 1

msg SUCCESS "Cloning repositories completed"
msg INFO "Checking if Docker volume 'janus-infra_mysql_data' exists..."

if docker volume inspect janus-infra_mysql_data > /dev/null 2>&1; then
    msg WARN "Volume 'janus-infra_mysql_data' exists. Removing..."
    docker volume rm janus-infra_mysql_data &> /dev/null
    msg SUCCESS "Volume removed successfully."
else
    msg DEBUG "Volume 'janus-infra_mysql_data' does not exist. Skipping removal."
fi

msg INFO "Launching infrastructure..."

cd "$HOME/$WORKDIR/janus-infra"
docker compose -f janus-compose.yaml up -d
msg SUCCESS "Infrastructure launch completed"

cd "$HOME/$WORKDIR"

msg SUCCESS "Janus is ready!"

# msg INFO : Retrieving janus-haproxy container IP..."

HAPROXY_IP=$(docker inspect janus-haproxy | grep '"IPAddress":' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]' | head -n1)

echo "[SUCCESS] : Found janus-haproxy IP: $HAPROXY_IP"

# URL="https://$HAPROXY_IP:8445"
URL="https://localhost:8445"

echo "[INFO] : Attempting to open browser..."

# Redirige les erreurs de xdg-open vers /dev/null
if command -v xdg-open > /dev/null; then
    xdg-open "$URL" &> /dev/null || {
        echo "[WARNING] : No graphical browser available. Please open manually: $URL"
    }
else
    echo "[WARNING] : xdg-open not found. Please open manually: $URL"
fi

