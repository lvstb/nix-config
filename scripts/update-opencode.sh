#!/usr/bin/env bash
set -euo pipefail

# Script to update opencode package hash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_NIX="$SCRIPT_DIR/../pkgs/opencode.nix"

echo "Updating opencode package hash..."

# Get current system info
if [[ "$OSTYPE" == "darwin"* ]]; then
    platform="darwin"
else
    platform="linux"
fi

if [[ "$(uname -m)" == "aarch64" ]] || [[ "$(uname -m)" == "arm64" ]]; then
    arch="arm64"
else
    arch="x64"
fi

# Try to build and capture the hash mismatch error
echo "Building to get new hash..."
cd "$SCRIPT_DIR/.."

# Temporarily set fake hash
sed -i 's/sha256 = ".*";/sha256 = lib.fakeSha256;/' "$OPENCODE_NIX"

# Build and capture the error to get the real hash
if build_output=$(nix build .#opencode 2>&1); then
    echo "Build succeeded unexpectedly"
    exit 1
else
    # Extract the correct hash from the error message
    correct_hash=$(echo "$build_output" | grep -o 'got:.*sha256-[A-Za-z0-9+/=]*' | sed 's/got:.*\(sha256-[A-Za-z0-9+/=]*\)/\1/')
    
    if [[ -n "$correct_hash" ]]; then
        echo "Found new hash: $correct_hash"
        # Update the file with the correct hash
        sed -i "s/sha256 = lib.fakeSha256;/sha256 = \"$correct_hash\";/" "$OPENCODE_NIX"
        
        echo "Testing build with new hash..."
        if nix build .#opencode; then
            echo "✅ Successfully updated opencode package!"
            echo "New version: $(./result/bin/opencode --version)"
        else
            echo "❌ Build failed with new hash"
            exit 1
        fi
    else
        echo "❌ Could not extract hash from build output"
        echo "Build output:"
        echo "$build_output"
        exit 1
    fi
fi