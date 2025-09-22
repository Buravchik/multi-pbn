#!/bin/bash

# Fix markdown linting issues in README.md

echo "🔧 Fixing markdown linting issues..."

# Add blank lines around headings (MD022)
sed -i '' '/^##/i\
' README.md

# Add blank lines around tables (MD058) - add before and after table rows
sed -i '' '/^|.*|$/i\
' README.md
sed -i '' '/^|.*|$/a\
' README.md

# Add blank lines around code fences (MD031)
sed -i '' '/^```/i\
' README.md
sed -i '' '/^```$/a\
' README.md

# Add blank lines around lists (MD032)
sed -i '' '/^[-*+]/i\
' README.md
sed -i '' '/^[-*+]/a\
' README.md

echo "✅ Linting fixes applied"
