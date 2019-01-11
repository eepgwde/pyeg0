## @author weaves

## This doesn't allow reading a block of lines.
# from distutils.text_file import TextFile


class Part(object):
    """
    File-reading class
    """

    fo = None
    nbytes = 10000000

    def __init__(self, filename = None, nbytes=None):
        """
        Given a filename, opens it and makes it available for iteration.

        @param nbytes is used with readlines(nbytes)
        """
        assert filename is not None
        self.fo = open(filename, "r")  # default mode is default

        if nbytes is None:
            nbytes = self.nbytes

        assert nbytes > 0
        self.nbytes = nbytes

    def __iter__(self):
        return self

    def __next__(self):
        lines = self.fo.readlines(self.nbytes)
        if len(lines) == 0:
            raise StopIteration
        return lines

    def __del__(self):
        self.fo.close()
        del self.fo

