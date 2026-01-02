#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$DIR/default.nix"

REPO="bkerler/mtkclient"
BRANCH="main"

echo "Fetching latest commit for $REPO..."
LATEST_COMMIT_JSON=$(curl -s "https://api.github.com/repos/$REPO/commits/$BRANCH")
REV=$(echo "$LATEST_COMMIT_JSON" | jq -r .sha)
DATE=$(echo "$LATEST_COMMIT_JSON" | jq -r .commit.author.date | cut -d'T' -f1)

echo "Fetching base version from pyproject.toml..."
BASE_VERSION=$(curl -s "https://raw.githubusercontent.com/$REPO/$BRANCH/pyproject.toml" | grep "^version =" | cut -d'"' -f2)
VERSION="$BASE_VERSION-unstable-$DATE"

echo "Latest commit: $REV"
echo "Date: $DATE"
echo "Version: $VERSION"

echo "Prefetching source..."
HASH=$(nix-prefetch-url --unpack "https://github.com/$REPO/archive/$REV.tar.gz" --type sha256)
SRI_HASH=$(nix hash to-sri --type sha256 "$HASH")

echo "SRI Hash: $SRI_HASH"

sed -i "s/version = \".*\";/version = \"$VERSION\";/" "$DEFAULT_NIX"
sed -i "s/rev = \".*\";/rev = \"$REV\";/" "$DEFAULT_NIX"
sed -i "s|hash = \".*\";|hash = \"$SRI_HASH\";|" "$DEFAULT_NIX"

echo "Successfully updated $DEFAULT_NIX"
