#!/bin/bash
# cleanup_workspace.sh - Keep the workspace root clean from tool artifacts

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../.."

echo "🧹 Cleaning up Skill Seekers artifacts in $ROOT_DIR..."

cd "$ROOT_DIR" || exit

# List of folders/files often generated in root by accident
TARGETS=("configs" "output" "dist")

for item in "${TARGETS[@]}"; do
    if [ -d "$item" ]; then
        echo "  - Removing directory: $item"
        rm -rf "$item"
    elif [ -f "$item" ]; then
        echo "  - Removing file: $item"
        rm -f "$item"
    fi
done

echo "✨ Cleanup complete. Relevant files are safely stored in .agent/ or tmp/."
