#!/usr/bin/env python3

with open("array.txt") as fin, open("input.mem", "w") as fout:
    for line in fin:
        line = line.strip()
        if line:
            value = int(line)
            if not (0 <= value <= 255):
                raise ValueError(f"Value {value} out of range")
            fout.write(f"{value:02X}\n")

print("Generated input.mem")