# Converter script to merge several successive Insert Statements into one batch insert

import re

current_table = ""
lines = []
converted_lines = []
prev_is_insert = False

with open('./scripts/original-testdata.sql', 'r', encoding='utf-8') as f:
    lines = f.readlines()
    
for line in lines:
    match = re.findall('^INSERT INTO ([\W\w]+) \(.*\) VALUES (\(.*\));$', line)
    print(line, match)
    if(match):
        table = match[0][0]
        if(table[0] == current_table and prev_is_insert):
            values = match[0][1]
            converted_lines.append(values + ",\n")
            prev_is_insert = True
        else:
            if(prev_is_insert): # terminate inserts
                converted_lines[-1] = converted_lines[-1][:-2] + ";\n"
            converted_lines.append(line[:-2] + ",\n")
            current_table = table[0]
            prev_is_insert = True
    else:
        if(prev_is_insert): # terminate inserts
            converted_lines[-1] = converted_lines[-1][:-2] + ";\n"
        converted_lines.append(line)
        prev_is_insert = False
    
with open('./scripts/2-testdata.sql', 'w', encoding='utf-8') as f:
    f.writelines(converted_lines)