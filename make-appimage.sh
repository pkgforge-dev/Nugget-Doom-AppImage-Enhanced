#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/nugget-doom.png
export DESKTOP=/usr/share/applications/io.github.MrAlaux.Nugget-Doom.desktop
export STARTUPWMCLASS=nugget-doom
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/nugget-doom /usr/bin/nugget-doom-setup /usr/lib/libfluidsynth.so*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
