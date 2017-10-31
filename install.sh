#!/bin/bash

LOCAL_STOW_PATH="vendor/stow-2.2.2/dist/bin/stow"

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

DOTFILES_DIR="$PWD"

if ! type stow 2>/dev/null; then
    STOW="$DOTFILES_DIR/$LOCAL_STOW_PATH"
    if [ ! -f "$STOW" ]; then
        make stow
    fi
else
    STOW="stow"
fi

exec "$STOW" -v -t "$HOME" "$@"
