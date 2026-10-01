import re

files = [
    "lib/core/i18n/strings_english.dart",
    "lib/core/i18n/strings_hindi.dart",
    "lib/core/i18n/strings_marathi.dart",
]

for filepath in files:
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    lines = content.split("\n")
    fixed_lines = []
    for line in lines:
        # Fix lines that have extra indentation (4 or more spaces) for property assignments
        # Match lines like "    doneDescription:" or "      doneButton:" and fix to "  doneDescription:"
        match = re.match(r'^(\s+)([a-zA-Z]\w*:\s)', line)
        if match:
            spaces = match.group(1)
            if len(spaces) > 2:
                # Fix to 2 spaces
                fixed_lines.append("  " + line[len(spaces):])
            else:
                fixed_lines.append(line)
        else:
            fixed_lines.append(line)
    
    result = "\n".join(fixed_lines)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(result)
    
    print(f"Fixed {filepath}")

print("All files fixed")
