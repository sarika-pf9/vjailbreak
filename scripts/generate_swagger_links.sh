#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
OUTPUT_FILE="$PROJECT_ROOT/docs/src/content/docs/guides/using_apis.mdx"

# Get the latest 5 tags and format them as a JSON array
TAGS_JSON=$(git tag --sort=-creatordate | head -n 5 | jq -R . | jq -s .)

# Create the MDX file with proper frontmatter and component usage
cat > "$OUTPUT_FILE" <<EOF
---
title: "API Reference by Version"
---

import ApiReference from '../../../components/ApiReference.astro';

<ApiReference versions={$TAGS_JSON} />

echo "API reference page updated to use ApiReference component in $OUTPUT_FILE"
