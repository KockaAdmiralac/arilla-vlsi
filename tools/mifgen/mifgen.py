#!/usr/bin/env python

import argparse
import sys
from os.path import getsize, splitext
from functools import partial

'''
              _ ____     
  ____ ______(_) / /___ _
 / __ `/ ___/ / / / __ `/
/ /_/ / /  / / / / /_/ / 
\__,_/_/  /_/_/_/\__,_/  
                         
Arilla mifgen
Generate Memory Initialization (.mif) files

File format reference: https://www.intel.com/content/www/us/en/programmable/quartushelp/17.0/reference/glossary/def_mif.htm
'''


def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(
        description="mifgen: Generate Memory Initialization (.mif) files.")
    parser.add_argument('input', metavar='input file',
                        type=str, help='input binary file')
    parser.add_argument('output', metavar='output file', default=None, nargs='?',
                        type=str, help='output binary file')
    parser.add_argument('-w', '--width',
                        help='memory width', type=int, default=8)
    args = parser.parse_args()

    # Proper file extensions
    if (args.output is None):
        args.output = splitext(args.input)[0] + '.mif'
    elif (splitext(args.output)[1] != 'mif'):
        args.output += '.mif'

    # Check width
    if args.width % 8 != 0:
        print(f'Width must be divisible by 8.')
        sys.exit()

    try:
        with open(args.output, 'w') as output_file, open(args.input, 'rb') as input_file:
            file_size = getsize(args.input)
            output_file.writelines([
                '%\n\tGenerated using mifgen - a part of the Arilla Tooling Project\n%\n',
                f'DEPTH = {file_size};\n',
                f'WIDTH = {args.width};\n',
                'ADDRESS_RADIX = HEX;\n',
                'DATA_RADIX = HEX;\n',
                'CONTENT BEGIN\n',
            ])

            reader = partial(input_file.read1, args.width // 8)
            line = 0

            for chunk in iter(reader, bytes()):
                output_file.write(f'{line:x} : ')
                for byte in chunk:
                    output_file.write(f'{byte:02x}')
                output_file.write(';\n')
                line += 1

            output_file.write('\nEND;')

    except FileNotFoundError:
        print(f'File {args.input} not found.')


if __name__ == '__main__':
    main()
