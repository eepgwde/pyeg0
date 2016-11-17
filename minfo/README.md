* weaves

This is a Python script 'minfo' that uses this module MInfo to extract
information from media files.

This is then used to produce a chapters file for MP4Box to produce an Apple
audiofile (an .m4b) that can be a full audiobook with chapters.

* MediaInfo

There is a package for reading media file information.

 https://mediaarea.net/en/MediaInfo

For Debian/stretch this is packaged as a Python DLL wrapper.

 python3-mediainfodll    0.7.88-1

** Get() method in MediaInfo

There have been problems. The DLL library does not work as
advertised. The file MediaInfoExample.py doesn't work as advertised. The
Inform() method works.

** UTF-8 encoded file names

There is a problem with loading files that have OS filename paths that
contain UTF-8 characters.

I've tried setting PYTHONIOENCODING=utf-8 but to no avail.

Because of that, the MInfo goes through some tortuous logic to create a
symlink to the file and then invoke the MediaInfo Open() on that.

** New object for each file, so Close() is redundant

The Close() call seems to be redundant. I found that I could not issue an
Open(f), Close(), Open(g) on the same MediaInfo object.

* Development

** unittest under make

I've packaged some testing files: MInfoTestCase and MInfoTestCase2. They
are invoked using make(1).

There are logging messages sent to minfo.log.

MInfoTestCase2 tries to process all the files in a directory named by SDIR

** unidecode

The UTF-8 encoding on some of the test file names could not be simplified
using the module unidecode. I only use this for logging, but you may see
messages like

 site-packages/unidecode/__init__.py:50:
 RuntimeWarning: Surrogate character '\udcbc' will be ignored. 
 You might be using a narrow Python build.
  return _unidecode(string)



* This file's Emacs file variables

[  Local Variables: ]
[  mode:text ]
[  mode:outline-minor ]
[  mode:auto-fill ]
[  fill-column: 75 ]
[  coding: iso-8859-1-unix ]
[  comment-column:50 ]
[  comment-start: "[  "  ]
[  comment-end:"]" ]
[  End: ]

