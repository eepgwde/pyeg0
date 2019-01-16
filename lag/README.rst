weaves

Demonstration project

I've developed this on a Linux system. I haven't tried it on Windows or Mac.

The distribution file has been generated using setuptools so it will install with

 pip3 install lag-0.0.1.dev585.tar.gz

(Note: the files _Queue.py and _Stack.py are part of template project I derived this from.)

This will install the script file which will run with the attached files (in the extra.zip file).
(Usually, the script is installed as the file $HOME/.local/bin/lag.)

Unzip some test files.

 unzip extra.zip

These files are similar to exercise given

 lag tests/banned_words.txt tests/prose.txt

This pair of files is more typical

 lag tests/en.txt tests/profane.txt

The full installation, with the tests, is given in tarball weaves.tar.gz

--

A quick walk-through of the code is that

 _Part.py contains a file loader that reads up to 10 MBytes (and a line) at a time.

The key method is __next__, which reads up to 10 MBytes and then reads the following and
appends it to the 10 MBytes. (This block-loading method is tested with a small block in the tests/)

 _Redact.py is more involved. The constructor loads the file of strings into a dictionary.

The key of each entry is the replacement string, '****' for example, and the value for that key is
a list of all the words that are four characters in length.

This simplifies the processing. All the words of length 4 will be replaced all together.

The method toRE() concatenates all those n-length words for an n-length key to form a regular
expression. A prefix and suffix are added. (This uses the named regular expression form
available in Python's re package.) A new dictionary is created.

Finally, the apply() method takes a text buffer from Part.__next__() and applies all
the regular expressions from the toRE() dictionary.

It uses a feature of the Python re.sub() method, that a function can be passed to it.
This function is repl(): a curried function. The string to replace the word is passed as the
named parameter v0.

Longest strings are processed first and all the keys are applied on the text buffer.













