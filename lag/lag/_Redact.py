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

    pre0='(?P<sep>[\s,.!?;:]*)'
    post0='(?P<sep1>[\s,.!?;:]*)'

    def __init__(self, **kwargs):
        """
        Given a filename, opens it and reads single lines. Each line is a string to be redacted.

        These are stored in the object's dictionary d0. The keys are strings * ** *** and so on.
        The value for each key is a list of string, each is a word to redact.

        That dictionary is then converted to a regular expression.

        @param nbytes is used with readlines(nbytes)
        """
        filename = kwargs.get('filename', None)
        self.pre0 = kwargs.get('pre0', self.pre0)
        self.post0 = kwargs.get('post0', self.post0)

        assert filename is not None
        with open(filename, "r") as inp:
            lines = inp.readlines()

        self.d0 = dict()

        for line in lines:
            v0 = line.strip()
            k0 = '*' * len(v0)  # This makes the anonymous string.
            l0 = self.d0.get(k0)
            if l0 is None:
                self.d0[k0] = [ v0 ]
            else:
                l0.append(v0)

    ##    def toRE(self, pre0='(?P<sep>\s*)', post0='(?P<sep1>\s*)', flags=re.IGNORECASE):
    def toRE(self, flags=re.IGNORECASE):
        """
        For the dictionary of strings, make regular expressions with pre- and post- strings.

        An expression might be (?P<sep>cunt|fuck|shit)(?P<sep1>[\s,.!?;:]*)

        The pre- and post- strings are typically white-space and punctuation.
        @return dictionary of regular expressions: keys are * ** and so on
        """
        d1 = dict()
        for k0 in iter(self.d0):
            d1[k0] = re.compile(self.pre0 + '(?P<text>' + "|".join(self.d0[k0]) + ')'
                                + self.post0, flags)

        return d1

    def apply(self, lines, dict0=None):
        if not isinstance(lines, str):
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

        ## The key is the token that will replace the strings in the pat0
        for k0 in keys0:
            pat0 = dict0[k0]
            repl = partial(repl_, v0=k0)
            lines = re.sub(pat0, repl, lines)

        return lines

