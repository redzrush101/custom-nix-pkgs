#!/usr/bin/env bash
set -e

# Configuration
REPO="Latitudes-Dev/shuvcode"
NIX_FILE="default.nix"
ARCH="linux-x64"

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo "Checking for latest release of $REPO..."

# Fetch latest release tag
LATEST_TAG=$(gh release list --repo "$REPO" --limit 1 --json tagName --jq '.[0].tagName')

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Could not fetch latest tag."
    exit 1
fi

# Remove 'v' prefix for version comparison/usage if needed, but the release URL uses the tag.
VERSION=${LATEST_TAG#v}

echo "Latest version: $VERSION (Tag: $LATEST_TAG)"

# Check if we are already up to date
CURRENT_VERSION=$(grep 'version =' "$NIX_FILE" | head -n 1 | cut -d '"' -f 2)

if [ "$VERSION" == "$CURRENT_VERSION" ]; then
    echo "Package is already at version $VERSION. Nothing to do."
    exit 0
fi

echo "Updating from $CURRENT_VERSION to $VERSION..."

# Construct download URL
URL="https://github.com/$REPO/releases/download/$LATEST_TAG/shuvcode-$ARCH.tar.gz"

echo "Prefetching $URL..."
HASH=$(nix-prefetch-url "$URL")
SRI_HASH=$(nix hash to-sri --type sha256 "$HASH")

echo "New Hash: $SRI_HASH"

# Update version in default.nix
sed -i "s/version = \".*\";/version = \"$VERSION\";/" "$NIX_FILE"

# Update hash in default.nix
# We use a pattern that matches the hash line. 
# Assuming standard formatting: hash = "sha256-..."
sed -i "s|hash = \"sha256-.*\";|hash = \"$SRI_HASH\";|" "$NIX_FILE"

echo "Update complete!"
