#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# 1. Check if there are any uncommitted changes in your current working directory
if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: You have uncommitted changes. Please commit or stash them before syncing."
    exit 1
fi

# Get the name of the branch you are currently working on
CURRENT_BRANCH=$(git branch --show-current)
echo "🔄 Current development branch identified as: $CURRENT_BRANCH"

echo "=== 📥 Step 1: Switching to main and fetching upstream updates ==="
git checkout main
git fetch upstream

echo "=== 🔀 Step 2: Merging upstream/main into local main ==="
git merge upstream/main

echo "=== 📤 Step 3: Pushing updated main to your Organization fork ==="
git push origin main

# Only attempt to merge back if your feature branch wasn't already 'main'
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "=== 🔄 Step 4: Returning to your feature branch ($CURRENT_BRANCH) ==="
    git checkout "$CURRENT_BRANCH"

    echo "=== 🧬 Step 5: Merging the fresh updates into your feature branch ==="
    git merge main
fi

echo "✅ Success! Everything is synced and you are back on branch: $(git branch --show-current)"
