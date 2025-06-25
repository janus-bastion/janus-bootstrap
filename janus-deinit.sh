#!/usr/bin/env bash

set -euo pipefail

c0=$(tput sgr0)
BOLD=$(tput bold)
EVI=$(tput setaf 1)
RESET=$(tput sgr0)

WORKDIR="$HOME/janus-workspace"
REPOS=(
  "janus-frontend"
  "janus-infra"
  "janus-monitoring"
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

banner "Janus Uninstallation"

if [ ! -d "$WORKDIR" ]; then
    msg WARN "Workspace $WORKDIR does not exist. Nothing to uninstall."
    exit 0
fi

msg INFO "Stopping and removing Janus infrastructure..."

if docker compose -f "$WORKDIR/janus-infra/janus-compose.yaml" ps > /dev/null 2>&1; then
    cd "$WORKDIR/janus-infra"
    docker compose -f janus-compose.yaml down
    msg SUCCESS "Infrastructure stopped and removed."
    cd "$HOME"
else
    msg WARN "Docker Compose environment not found or not running."
fi

msg INFO "Removing Docker volume 'janus-infra_mysql_data' if it exists..."
if docker volume inspect janus-infra_mysql_data > /dev/null 2>&1; then
    docker volume rm janus-infra_mysql_data
    msg SUCCESS "Volume removed."
else
    msg DEBUG "Volume does not exist."
fi

msg INFO "Removing repositories..."
for repo in "${REPOS[@]}"; do
    if [ -d "$WORKDIR/$repo" ]; then
        rm -rf "${WORKDIR:?}/${repo:?}"
        msg SUCCESS "Removed $repo."
    else
        msg DEBUG "$repo not found. Skipping."
    fi
done

msg INFO "Removing residual Docker images..."
for image in imtjanus/janus-core:latest imtjanus/janus-php:8.2-fpm; do
    if docker image inspect "$image" > /dev/null 2>&1; then
        docker image rm "$image"
        msg SUCCESS "Docker image $image removed."
    else
        msg DEBUG "Docker image $image not found. Skipping."
    fi
done

msg INFO "Cleaning up workspace directory if empty..."
if [ -z "$(ls -A "$WORKDIR")" ]; then
    rmdir "$WORKDIR"
    msg SUCCESS "Workspace directory removed."
else
    msg WARN "Workspace not empty. Some files or directories remain in $WORKDIR."
fi

banner "Janus successfully uninstalled."
