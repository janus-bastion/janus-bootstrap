#!/usr/bin/env bash

set -euo pipefail

c0=$(tput sgr0)
BOLD=$(tput bold)
EVI=$(tput setaf 2)
RESET=$(tput sgr0)

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
        HIGHLIGHT) color=5 ;;
        *)       color=7 ;;
    esac

    tput setaf "$color"
    printf -- "[%s] : %s%s\n" "$type" "$*" "$c0"
}

banner() {
    local msg="*** $* ***"
    local edge
    edge=$(printf '%*s' "${#msg}" '' | tr ' ' '*')

    printf "\n"
    echo "${BOLD}${EVI}${edge}"
    echo "$msg"
    echo "${edge}${RESET}"
    printf "\n"
}

msg INFO "Preparing workspace..."
mkdir -p "$HOME/$WORKDIR"
cd "$HOME/$WORKDIR"

msg INFO "Checking running Janus infrastructure..."
if docker compose -f "$HOME/$WORKDIR/janus-infra/janus-compose.yaml" ps | grep -q 'Up'; then
    msg SUCCESS "Janus infrastructure is already running."
else
    msg INFO "Cloning repositories..."
    for repo in "${REPOS[@]}"; do
        if [ -d "$repo" ]; then
            msg DEBUG "$repo already exists. Skipping..."
        else
            msg INFO "Cloning $repo..."
            git clone "git@github.com:janus-bastion/$repo.git"
        fi
    done

    msg INFO "Checking Docker volume 'janus-infra_mysql_data'..."
    if docker volume inspect janus-infra_mysql_data > /dev/null 2>&1; then
        msg WARN "Volume exists. Removing..."
        docker volume rm janus-infra_mysql_data &> /dev/null
        msg SUCCESS "Volume removed."
    else
        msg DEBUG "Volume does not exist. Skipping removal."
    fi

    msg INFO "Launching infrastructure..."
    cd "$HOME/$WORKDIR/janus-infra"
    docker compose -f janus-compose.yaml up -d
    msg SUCCESS "Infrastructure launched."
    cd ..
fi

msg INFO "Retrieving janus-haproxy IP..."
HAPROXY_IP=$(docker inspect janus-haproxy | grep '"IPAddress":' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]' | head -n1)

msg SUCCESS "Found janus-haproxy IP: $HAPROXY_IP"

URL="https://$HAPROXY_IP:8445"

banner "Janus is accessible at: $URL"

if command -v xdg-open > /dev/null; then
    msg INFO "Attempting to open browser..."
    xdg-open "$URL" &> /dev/null || {
        msg WARN "No graphical browser available. Please open manually: $URL"
    }
else
    msg WARN "xdg-open not found. Please open manually: $URL"
fi
