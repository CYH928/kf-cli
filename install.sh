#!/usr/bin/env bash
# install.sh — kf-cli installer for ~/.agents/skills/kf-cli/
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ZorCorp/kf-cli/master/install.sh | sh
#   curl -fsSL .../install.sh | sh -s -- --update
#   curl -fsSL .../install.sh | sh -s -- --uninstall

set -euo pipefail

REPO_TARBALL="https://github.com/ZorCorp/kf-cli/archive/refs/heads/master.tar.gz"
INSTALL_DIR="$HOME/.agents/skills/kf-cli"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP_DIR="$HOME/.agents/skills/kf-cli.bak-$TIMESTAMP"

MODE="install"
for arg in "$@"; do
    case "$arg" in
        --update)     MODE="update" ;;
        --uninstall)  MODE="uninstall" ;;
        *) echo "Unknown arg: $arg" >&2; exit 2 ;;
    esac
done

uninstall() {
    if [[ -d "$INSTALL_DIR" ]]; then
        rm -rf "$INSTALL_DIR"
        echo "✓ Removed $INSTALL_DIR"
    else
        echo "Nothing to uninstall at $INSTALL_DIR"
    fi
    # preserve the most recent .bak-* (do not touch backups)
}

fetch_and_extract() {
    local dest="$1"
    mkdir -p "$dest"
    if ! curl -fsSL "$REPO_TARBALL" | tar -xz --strip-components=1 -C "$dest"; then
        echo "❌ Failed to fetch or extract $REPO_TARBALL" >&2
        exit 1
    fi
}

check_deps() {
    for tool in yt-dlp gh curl tar; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            case "$tool" in
                yt-dlp) echo "⚠ yt-dlp not found — install: brew install yt-dlp" ;;
                gh)     echo "⚠ gh not found — install: brew install gh" ;;
                curl)   echo "⚠ curl not found — install via your system package manager" ;;
                tar)    echo "⚠ tar not found — install via your system package manager" ;;
            esac
        fi
    done
}

verify() {
    if command -v openclaw >/dev/null 2>&1; then
        echo ""
        echo "Verify OpenClaw registration:"
        echo "  openclaw skills list 2>/dev/null | grep kf-cli"
    else
        echo ""
        echo "Verify install:"
        echo "  head -5 $INSTALL_DIR/SKILL.md"
    fi
}

case "$MODE" in
    uninstall)
        uninstall
        exit 0
        ;;
    install|update)
        mkdir -p "$HOME/.agents/skills"
        if [[ -d "$INSTALL_DIR" ]]; then
            STAGING="$(mktemp -d)"
            fetch_and_extract "$STAGING"
            if diff -qr "$INSTALL_DIR" "$STAGING" >/dev/null 2>&1; then
                echo "✓ Already up-to-date at $INSTALL_DIR"
                rm -rf "$STAGING"
            else
                mv "$INSTALL_DIR" "$BACKUP_DIR"
                mv "$STAGING" "$INSTALL_DIR"
                echo "✓ Installed to $INSTALL_DIR (previous version backed up to $BACKUP_DIR)"
            fi
        else
            fetch_and_extract "$INSTALL_DIR"
            echo "✓ Installed to $INSTALL_DIR"
        fi
        check_deps
        verify
        ;;
esac
