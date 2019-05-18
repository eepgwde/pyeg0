## @author weaves

## This doesn't allow reading a block of lines.
# from distutils.text_file import TextFile


class Part(object):
    """
    File-reading class 
    """

    nbytes = 10000000           # class constant

    def __init__(self, filename = None, nbytes=None):
        """
        Given a filename, opens it and makes it available for iteration.

        The file must be closed.

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
        """
        Read the file in n-byte blocks and then append the following line.
        """
        buf1 = self.fo.read(self.nbytes)
        if len(buf1) == 0:
            raise StopIteration
        buf2 = self.fo.readline()
        if len(buf2) == 0:
            return buf1
        return buf1 + buf2

    def __del__(self):
        self.fo.close()
        del self.fo

