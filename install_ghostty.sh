#!/bin/bash

# Set up error handling
set -e

# Dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y libgtk-4-dev libadwaita-1-dev git blueprint-compiler

# Create a temporary directory for the build
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# For building older Ghostty that works with Debian 12, we need Zig 0.13.0
ZIG_BUILD_VERSION="0.13.0"

# Download Zig 0.13.0 to temporary location for this build
echo "Downloading Zig $ZIG_BUILD_VERSION for Ghostty build..."
cd "$TMP_DIR"
ZIG_URL="https://ziglang.org/download/$ZIG_BUILD_VERSION/zig-linux-x86_64-$ZIG_BUILD_VERSION.tar.xz"
wget -q "$ZIG_URL"
tar -xf "zig-linux-x86_64-$ZIG_BUILD_VERSION.tar.xz"
ZIG_PATH="$TMP_DIR/zig-linux-x86_64-$ZIG_BUILD_VERSION/zig"

# Verify Zig download
$ZIG_PATH version || { echo "Zig download failed!"; exit 1; }
echo "Using Zig $($ZIG_PATH version) for build"

# Define the Ghostty commit that works with Debian 12's older libraries
# This is the commit shown in your working installation
GHOSTTY_COMMIT="f1f11207"

# Clone and checkout the specific commit
echo "Cloning and building Ghostty from commit $GHOSTTY_COMMIT..."
cd "$TMP_DIR"
git clone https://github.com/ghostty-org/ghostty.git
cd ghostty
git -c advice.detachedHead=false checkout "$GHOSTTY_COMMIT"

sudo $ZIG_PATH build -p /usr -Doptimize=ReleaseFast
echo "Ghostty installed successfully."

# Cleanup
echo "Cleaning up temporary files..."
sudo rm -rf "$TMP_DIR"

# Ensure ~/.config/ghostty directory exists
mkdir -p "$HOME/.config/ghostty"

# Desired ghostty configuration
CONFIG_FILE="$HOME/.config/ghostty/config"
DESIRED_CONFIG="
font-family = SauceCodePro Nerd Font Mono
font-size = 16
background-opacity = 0.90
theme = nightfox
"

# Create or update the config file
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Creating ghostty config with default settings at $CONFIG_FILE..."
    echo "$DESIRED_CONFIG" > "$CONFIG_FILE"
else
    echo "Updating ghostty config at $CONFIG_FILE to ensure desired settings are present..."

    for setting in "font-family" "font-size" "background-opacity" "theme"; do
        value=$(echo "$DESIRED_CONFIG" | grep "^$setting" | cut -d'=' -f2-)
        if grep -q "^$setting" "$CONFIG_FILE"; then
            sed -i "s|^$setting.*|$setting = $value|" "$CONFIG_FILE"
        else
            echo "$setting = $value" >> "$CONFIG_FILE"
        fi
    done
fi

echo "Ghostty installation and configuration complete."
