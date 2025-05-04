#!/usr/bin/env bash
set -Eeuo pipefail

# Determine device-specific script
unameOut="$(uname -sr)"
case "${unameOut}" in
    *valve*)     device=steamdeck;;
    *Darwin*)    device=macos;;
    *)          device="UNKNOWN:${unameOut}"
esac

# Run device-specific setup
if test -f ${device}/package.sh ; then
    source ${device}/package.sh
fi

# Sync dotfiles into $HOME
echo "Syncing dotfiles to $HOME..."
rsync -avh home/ "$HOME"
echo "Dotfiles synced."