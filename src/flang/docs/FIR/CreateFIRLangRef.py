# This script combines FIRLangRef_Header.md with the auto-generated Dialect/FIRLangRef.md
# for the purpose of creating an introduction header/paragraph for FIRLangRef.html.

import os

# These paths are relative to flang/docs in the build directory, not source, as that's where this tool is executed.
HEADER_PATH = os.path.join('Source', 'FIR', 'FIRLangRef_Header.md')
DOCS_PATH   = os.path.join('Dialect', 'FIRLangRef.md')
OUTPUT_PATH = os.path.join('Source', 'FIRLangRef.md')

# 1. Writes line 1 from docs to output, (comment line that the file is autogenerated)
# 2. Adds a new line
# 3. Writes the entire header to the output file
# 4. Writes the remainder of docs to the output file
with open(OUTPUT_PATH, 'w') as output:
    with open(HEADER_PATH, 'r') as header, open(DOCS_PATH, 'r') as docs:
        output.write(docs.readline())
        output.write("\n")
        output.write(header.read())
        output.write(docs.read())