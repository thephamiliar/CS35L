#!usrbinpython
"""
Output lines selected randomly from a file

Copyright 2005, 2007 Paul Eggert.
Copyright 2010 Darrell Benjamin Carbajal.

This program is free software: you can redistribute it andor modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Please see <http:www.gnu.orglicenses> for a copy of the license.

$Id: randline.py,v 1.4 20100405 20:04:43 eggert Exp $
"""

import random, sys
from optparse import OptionParser

class randline:
    def __init__(self, filename):
        self.lines = []
        for i in range(len(filename)):
            f = open(filename[i], 'r')
            self.lines.append(f.readlines())
            f.close()
        output = []
        for f in self.lines:
            for i in f:
                output.append(i)
        self.lines = output

    def uniq(self):
        output = []
        for f in self.lines:
            if f not in output:
                output.append(f)
        self.lines = output

    def chooseline(self,noRE,output):
        l = random.choice(self.lines)
        if (noRE):
            fileCount = self.lines.count(l)
            outputCount = output.count(l)
            while (outputCount >= fileCount):
                l = random.choice(self.lines)
                fileCount = self.lines.count(l)
                outputCount = output.count(l)
        return l

def main():
    version_msg = "%prog 2.0"
    usage_msg = """%prog [-n(num)uw]... FILE FILE2

Output randomly selected lines from files. Must have at least one input file."""

    parser = OptionParser(version=version_msg,
                          usage=usage_msg)
    parser.add_option("-n", "--numlines",
                      action="store", dest="numlines", default=1,
                      help="output NUMLINES lines (default 1)")
    parser.add_option("-u", "--unique", action="store_true",
		      dest="unique", default=False,
		      help="duplicate lines in the input are ignored")
    parser.add_option("-w", "--without-replacement", action="store_true",
		      dest="noRE", default=False,
		      help="output lines without replacement")

    options, args = parser.parse_args(sys.argv[1:])

    try:
        numlines = int(options.numlines)
        unique = bool(options.unique)
        noRE = bool(options.noRE)
    except:
        parser.error("invalid NUMLINES: {0}".
                     format(options.numlines))
    if numlines < 0:
        parser.error("negative count: {0}".
                     format(numlines))
    if len(args) < 1:
        parser.error("wrong number of operands")

    input_file = []
    for i in range(len(args)):
        input_file.append(args[i])

    try:
        generator = randline(input_file)

    except IOError as err:
        parser.error("IO error({0}): {1}".
                     format(errno, strerror))
    if (unique):
        generator.uniq()
    if (noRE) and (len(generator.lines) < numlines):
        parser.error("input has fewer lines than numlines")
    output = []
    for index in range(numlines):
        l = generator.chooseline(noRE,output)
        output.append(l)
        sys.stdout.write(l)

if __name__ == "__main__":
    main()

