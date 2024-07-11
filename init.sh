#!/usr/bin/env bash
set -Eeuo pipefail

# Drop into the package setup for my distro/device
unameOut="$(uname -sr)"
case "${unameOut}" in
    *valve*)     device=steamdeck;;
    *Darwin*)    device=macos;;
    *)          device="UNKNOWN:${unameOut}"
esac

if test -f ${device}/package.sh ; then
    source ${device}/package.sh
fi
