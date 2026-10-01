import re
import sys

content = open('sehat_sathi/lib/core/i18n/strings_hindi.dart', encoding='utf-8').read()
for line in content.split('\n'):
    matches = re.findall(r"'([^']*)'", line)
    for m in matches:
        if len(m) > 0 and ord(m[0]) > 127:
            try:
                decoded = m.encode('latin-1').decode('utf-8')
                print(f'GARBLED: {repr(m)}')
                print(f'DECODED: {decoded}')
                print()
            except Exception as e:
                print(f'FAILED: {repr(m)} - {e}')
                print()
