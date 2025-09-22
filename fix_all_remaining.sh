#!/bin/bash

echo "🔧 Fixing ALL remaining linting issues..."

# Create a backup
cp README.md README.md.backup

# Fix all spacing issues systematically
echo "  📝 Adding blank lines around all headings..."
sed -i '' '/^##/i\
' README.md
sed -i '' '/^##/a\
' README.md

echo "  📝 Adding blank lines around all tables..."
sed -i '' '/^|.*|$/i\
' README.md
sed -i '' '/^|.*|$/a\
' README.md

echo "  📝 Adding blank lines around all code fences..."
sed -i '' '/^```/i\
' README.md
sed -i '' '/^```$/a\
' README.md

echo "  📝 Adding blank lines around all lists..."
sed -i '' '/^[-*+]/i\
' README.md
sed -i '' '/^[-*+]/a\
' README.md

echo "  📝 Cleaning up excessive blank lines..."
sed -i '' '/^$/N;/^\n$/d' README.md

echo "✅ All spacing fixes applied"
