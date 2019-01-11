## @author weaves

## This doesn't allow reading a block of lines.
# from distutils.text_file import TextFile

import re
from functools import partial

import logging

logger = logging.getLogger('Test')

def repl_(m, v0="*"):
    """
    A replacement method for re.sub().
    @param v0 the string to replace the middle group.

    @note
    This particular application can deduce the middle group's replacement.
    """
    if m.group(3):
        return m.group(1) + v0 + m.group(3)
    else:
        return m.group(1)

class Redact(object):
    """
    Creates a dictionary of strings to redact.
    """

    def __init__(self, filename = None):
        """
        Given a filename, opens it and reads single lines. Each line is a string to be redacted.

        @param nbytes is used with readlines(nbytes)
        """
        assert filename is not None
        with open(filename, "r") as inp:
            lines = inp.readlines()

        self.d0 = dict()

        for line in lines:
            v0 = line.strip()
            k0 = '*' * len(v0)
            l0 = self.d0.get(k0)
            if l0 is None:
                self.d0[k0] = [ v0 ]
            else:
                l0.append(v0)

    def toRE(self, pre0='(?P<sep>[\s,.!?;:])', post0='(?P<sep1>\s,.!?;:])', flags=re.IGNORECASE):
        """
        For the dictionary of strings, for regular expressions with pre- and post- strings.

        The pre- and post- strings are typically white-space and punctuation.
        """
        d1 = dict()
        for k0 in iter(self.d0):
            print(self.d0[k0])
            d1[k0] = re.compile(pre0 + '(?P<text>' + "|".join(self.d0[k0]) + ')' + post0, flags)

        return d1

    def apply(self, lines, dict0=None):
        if not ( isinstance(lines, list) or isinstance(lines, tuple)):
            logger.info("fail: 1")
            return lines
        if len(lines) == 0:
            logger.info("fail: 2")
            return lines

        if dict0 is None:
            dict0 = self.toRE()

        ## Longest strings first
        keys0 = list(dict0.keys())
        keys0.sort(key = len)
        keys0.reverse()

        lines1 = lines[:]
        ## The key is the token to replace
        for k0 in keys0:
            pat0 = dict0[k0]
            repl = partial(repl_, v0=k0)
            logger.info("repl: " + k0)
            logger.info("pat: " + str(pat0))
            lines2 = map(lambda l: re.sub(pat0, repl, l), lines1)
            lines1 = lines2

        return lines1

