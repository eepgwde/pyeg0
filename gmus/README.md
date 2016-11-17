* weaves

Using the GMusic API with Pandas

* Overview

This is a simple example of using the gmusapi. Recently updated to Python
3.

It uses the GMusic Manager Wrapper now to provide logon and handle the new
application specific logon.

The idea is to download a catalogue of your songs and work with it using Pandas.

* Pre-requisites

To use you need to download gmusapi (or have a URL) see GMus00.py for those.
Use pip(1) to install it.

 pip install --user . 

will install into ~/.local

Debian packages needed to install are python-setuptools and python-pip.

Then to run this code, you can use the standard Debian packages:
python-peak.rules and python-requests.

* Running

Debugging is tricky because it is a test case. 

** Command-line

To run from the command-line under unittest.

 $ python3 -m unittest GMus0TestCase

** Within Emacs

Under Emacs using ipython, the ipython parameters are passed to the
unittest.main(sys.argv). So there is some side-stepping code in the
GMus0TestCase file now.

Use the send buffer method of the Python IDE. Do not make it dedicated.
Then enter the test0.py buffer and send the unittest.run commands.

You can then access the object via the GMus0TestCase module.

The variables and the objects can then be accessed via the
GMus0TestCase class's variables.

** This file's Emacs file variables

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
