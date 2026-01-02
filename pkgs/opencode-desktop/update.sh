#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGE_FILE="$DIR/default.nix"

# Fetch latest release from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/sst/opencode/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | jq -r .tag_name | sed 's/^v//')

CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_FILE")

if [ "$LATEST_VERSION" == "$CURRENT_VERSION" ]; then
    echo "opencode-desktop is already at the latest version ($CURRENT_VERSION)"
    exit 0
fi

echo "Updating opencode-desktop from $CURRENT_VERSION to $LATEST_VERSION..."

DEB_URL="https://github.com/sst/opencode/releases/download/v${LATEST_VERSION}/opencode-desktop-linux-amd64.deb"

# Get SRI hash
NEW_HASH=$(nix-prefetch-url --type sha256 "$DEB_URL")
SRI_HASH=$(nix hash to-sri --type sha256 "$NEW_HASH")

# Update the file
sed -i "s/version = \".*\";/version = \"$LATEST_VERSION\";/" "$PACKAGE_FILE"
sed -i "s|hash = \".*\";|hash = \"$SRI_HASH\";|" "$PACKAGE_FILE"

echo "Successfully updated opencode-desktop to $LATEST_VERSION with hash $SRI_HASH"
