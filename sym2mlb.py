'''
SYM2MLB

Convert WLA-DX symbol files to Mesen MLB files

Samuel Volk, Dec 2025
'''

import argparse
import os
from pathlib import Path
import sys

parser = argparse.ArgumentParser()
parser.add_argument('symfile', help="SYM file to convert to MLB format")
parser.add_argument('-o', "--output", help="Output file name")
args = parser.parse_args()

# check to see if file exists
if not os.path.exists(args.symfile):
    print("File", args.symfile, "does not exist.")
    sys.exit()

# load in symbols
print("Loading in symbols from", args.symfile)
symbols = []
i = 0
with open(args.symfile, 'rt') as symfile:
    # skip forwards in file to the labels
    for line in symfile:
        if '[labels]' in line:
            break

    while line != '\n':
        line = symfile.readline()

        # check if line is a new line
        if line == '\n':
            break
        line = line.strip()

        # split line into bank, address and label
        addr, label = line.split(' ', )
        bank, addr = addr.split(':')
        bank = int(bank, 16)
        addr = int(addr, 16) - 0xC000

        symbols.append([bank, addr, label])
        i += 1

print("Found", len(symbols), "symbols.")

# choose a filename for output
if args.output:
    mlbfilename = args.output
else:
    mlbfilename = args.symfile.strip('.sym') + '.mlb'

# check if it already exists
mlbfile = Path(mlbfilename)
if mlbfile.is_file():
    print("ERROR: Output file", mlbfilename, "already exists.")
    sys.exit()

# output symbols into mlb file
with open(mlbfilename, "x") as mlbfile:
    i = 0
    for symbol in symbols:
        mlbfile.write(
                "NesPrgRom:" + '{:04x}'.format(symbols[i][1]) +
                ':' + str(symbols[i][2]) + '\n')
        i += 1

print("Finished.")
