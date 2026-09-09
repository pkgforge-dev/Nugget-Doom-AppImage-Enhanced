#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm alsa-lib cmake fluidsynth hicolor-icon-theme openal sdl2_net libsndfile libebur128

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package nugget-doom

# If the application needs to be manually built that has to be done down here
echo "Building stable version of Nugget Doom..."
echo "---------------------------------------------------------------"
REPO="https://github.com/MrAlaux/Nugget-Doom"
TAG="$(curl -s https://api.github.com/repos/MrAlaux/Nugget-Doom/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
VERSION="$(echo "$TAG" | sed 's/^nugget-doom-//')"
git clone --depth 1 --branch "$TAG" "$REPO" ./Nugget-Doom
echo "$VERSION" > ~/version

cmake -B build -S ./Nugget-Doom \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j$(nproc)
cmake --install build
