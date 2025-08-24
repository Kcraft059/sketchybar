#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"
log() { echo -e "${YELLOW}➤ $1${RESET}"; }
success() { echo -e "${GREEN}✔ $1${RESET}"; }

log "clone sketchybar-config repository..."
CONFIG_DIR="$HOME/.config"
rm -rf "$CONFIG_DIR/sketchybar"
git clone --depth 1 https://github.com/Kcraft059/sketchybar-config "$CONFIG_DIR/sketchybar"
success "cloned sketchybar-config repository"

log "Installing SketchyBar dependencies..."
brew tap FelixKratz/formulae
brew install sketchybar media-control macmon imagemagick
brew install --cask sf-symbols font-sketchybar-app-font font-sf-pro
success "installed dependencies..."

log "get latest icon map ..."
latest_tag=$(curl -s https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
font_url="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/${latest_tag}/icon_map.sh"
output_path="$CONFIG_DIR/sketchybar/dyn-icon_map.sh"
rm -f "$output_path"
mkdir -p "$(dirname "$output_path")"
curl -L "$font_url" -o "$output_path"
success "Downloaded dyn-icon_map.sh"

brew services restart sketchybar
sketchybar --reload
success "SketchyBar loaded."
