#!/bin/bash

echo "🔧 Applying final comprehensive fixes..."

# Fix remaining spacing issues
# Add blank lines before headings that don't have them
sed -i '' '/^##/i\
' README.md

# Add blank lines after headings that don't have them  
sed -i '' '/^##/a\
' README.md

# Add blank lines around tables
sed -i '' '/^|.*|$/i\
' README.md
sed -i '' '/^|.*|$/a\
' README.md

# Add blank lines around code fences
sed -i '' '/^```/i\
' README.md
sed -i '' '/^```$/a\
' README.md

# Add blank lines around lists
sed -i '' '/^[-*+]/i\
' README.md
sed -i '' '/^[-*+]/a\
' README.md

# Clean up excessive blank lines
sed -i '' '/^$/N;/^\n$/d' README.md

echo "✅ Final fixes applied"
