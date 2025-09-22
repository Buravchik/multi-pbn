#!/bin/bash

echo "🔧 Applying FINAL comprehensive fix for ALL remaining issues..."

# Fix all spacing issues with a more aggressive approach
echo "  📝 Fixing all heading spacing..."
# Add blank line before every heading
sed -i '' '/^##/i\
' README.md
# Add blank line after every heading  
sed -i '' '/^##/a\
' README.md

echo "  📝 Fixing all table spacing..."
# Add blank line before every table row
sed -i '' '/^|.*|$/i\
' README.md
# Add blank line after every table row
sed -i '' '/^|.*|$/a\
' README.md

echo "  📝 Fixing all code fence spacing..."
# Add blank line before every code fence
sed -i '' '/^```/i\
' README.md
# Add blank line after every code fence
sed -i '' '/^```$/a\
' README.md

echo "  📝 Fixing all list spacing..."
# Add blank line before every list item
sed -i '' '/^[-*+]/i\
' README.md
# Add blank line after every list item
sed -i '' '/^[-*+]/a\
' README.md

echo "  📝 Cleaning up excessive blank lines..."
# Remove multiple consecutive blank lines
sed -i '' '/^$/N;/^\n$/d' README.md

echo "✅ FINAL comprehensive fix applied"
