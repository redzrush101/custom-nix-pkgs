#!/usr/bin/env bash

set -euo pipefail

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Updating shuvcode flake input..."
# Note: Since shuvcode is a flake input, we update it via the root flake
cd "$DIR/../../"
nix flake update shuvcode

echo "shuvcode update check complete."
