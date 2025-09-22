#!/usr/bin/env python3

import re

def fix_markdown_linting(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    
    # Remove trailing whitespace
    lines = [line.rstrip() + '\n' for line in lines]
    
    # Fix specific issues
    fixed_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i].rstrip()
        
        # Fix MD003: Remove setext heading (---)
        if line == '---' and i > 0 and not lines[i-1].strip().startswith('#'):
            # Skip this line (remove setext heading)
            i += 1
            continue
            
        # Fix MD051: Fix link fragments
        if 'documentation-links' in line:
            line = line.replace('#-documentation-links', '#-documentation-links')
        
        fixed_lines.append(line + '\n')
        
        # Add blank lines around headings (MD022)
        if re.match(r'^##', line):
            # Add blank line before if previous line is not blank
            if i > 0 and fixed_lines[-2].strip() != '':
                fixed_lines.insert(-1, '\n')
            # Add blank line after if next line is not blank
            if i < len(lines) - 1 and lines[i+1].strip() != '':
                fixed_lines.append('\n')
        
        # Add blank lines around tables (MD058)
        elif re.match(r'^\|.*\|$', line):
            # Add blank line before if previous line is not blank
            if i > 0 and fixed_lines[-2].strip() != '':
                fixed_lines.insert(-1, '\n')
            # Add blank line after if next line is not blank and not a table row
            if i < len(lines) - 1 and lines[i+1].strip() != '' and not re.match(r'^\|.*\|$', lines[i+1]):
                fixed_lines.append('\n')
        
        # Add blank lines around code fences (MD031)
        elif line.startswith('```'):
            # Add blank line before if previous line is not blank
            if i > 0 and fixed_lines[-2].strip() != '':
                fixed_lines.insert(-1, '\n')
            # Add blank line after if next line is not blank
            if i < len(lines) - 1 and lines[i+1].strip() != '':
                fixed_lines.append('\n')
        
        # Add blank lines around lists (MD032)
        elif re.match(r'^[-*+]', line):
            # Add blank line before if previous line is not blank
            if i > 0 and fixed_lines[-2].strip() != '':
                fixed_lines.insert(-1, '\n')
            # Add blank line after if next line is not blank and not a list item
            if i < len(lines) - 1 and lines[i+1].strip() != '' and not re.match(r'^[-*+]', lines[i+1]):
                fixed_lines.append('\n')
        
        i += 1
    
    # Clean up multiple consecutive blank lines
    final_lines = []
    prev_blank = False
    for line in fixed_lines:
        if line.strip() == '':
            if not prev_blank:
                final_lines.append(line)
            prev_blank = True
        else:
            final_lines.append(line)
            prev_blank = False
    
    # Write back to file
    with open(filename, 'w') as f:
        f.writelines(final_lines)

if __name__ == '__main__':
    fix_markdown_linting('README.md')
    print("✅ Precise linting fixes applied")
