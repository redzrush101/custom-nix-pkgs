#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGE_FILE="$DIR/default.nix"

# Get latest commit from main
LATEST_COMMIT=$(git ls-remote https://github.com/Fission-AI/OpenSpec.git refs/heads/main | cut -f1)
CURRENT_COMMIT=$(grep -oP 'rev = "\K[^"]+' "$PACKAGE_FILE")

if [ "$LATEST_COMMIT" == "$CURRENT_COMMIT" ]; then
    echo "OpenSpec is already at the latest commit ($CURRENT_COMMIT)"
    exit 0
fi

echo "Updating OpenSpec from $CURRENT_COMMIT to $LATEST_COMMIT..."

# Prefetch source hash
NEW_HASH=$(nix-prefetch-url --unpack https://github.com/Fission-AI/OpenSpec/archive/${LATEST_COMMIT}.tar.gz)
NEW_SRI_HASH=$(nix-hash --to-sri --type sha256 "$NEW_HASH")

# Update version with current date
NEW_VERSION="0.17.2-unstable-$(date +%Y-%m-%d)"

# Update the file
sed -i "s/version = \".*\";/version = \"$NEW_VERSION\";/" "$PACKAGE_FILE"
sed -i "s/rev = \".*\";/rev = \"$LATEST_COMMIT\";/" "$PACKAGE_FILE"
sed -i "s|hash = \".*\";|hash = \"$NEW_SRI_HASH\";|" "$PACKAGE_FILE"

# Reset npmDepsHash to get the new one
sed -i 's/npmDepsHash = ".*";/npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";/' "$PACKAGE_FILE"

echo "Successfully updated OpenSpec to $LATEST_COMMIT. Now run nix build to get the new npmDepsHash."
