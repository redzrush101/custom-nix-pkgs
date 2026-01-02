#!/usr/bin/env bash

set -euo pipefail

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$DIR/../../"
FLAKE_FILE="$ROOT_DIR/flake.nix"

echo "Updating shuvcode flake input..."
cd "$ROOT_DIR"
nix flake update shuvcode

echo "Verifying build and auto-patching hash if needed..."
# Try to build and capture output to find hash mismatch
BUILD_OUTPUT=$(nix build .#shuvcode 2>&1 || true)

if echo "$BUILD_OUTPUT" | grep -q "hash mismatch"; then
    GOT_HASH=$(echo "$BUILD_OUTPUT" | grep "got:" | sed 's/.*got:[[:space:]]*//')
    if [ -n "$GOT_HASH" ]; then
        echo "Detected hash mismatch. New hash: $GOT_HASH"
        echo "Patching $FLAKE_FILE..."
        # Update the hash in flake.nix. We target the hash line specifically.
        sed -i "s|hash = \"sha256-.*\";|hash = \"$GOT_HASH\";|" "$FLAKE_FILE"
        
        echo "Retrying build..."
        nix build .#shuvcode
        echo "Hash patched successfully!"
    else
        echo "Could not extract new hash from build output."
        exit 1
    fi
else
    echo "Build successful or no hash mismatch detected."
fi

echo "shuvcode update check complete."
