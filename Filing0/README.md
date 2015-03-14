* Author

Walter Eaves

* Task - Warwick Analytics

This is a training set of fault data.

Find all records that have no fault in any attribute.

* Programming Task 1

** No web interface

I haven't implemented a web interface. I would do that with Django, but I
thought I wouldn't have enough time.

** Filing0 and TestCase

I've implemented a basic class for the data filtering: Filing0.py. It has a
test case Filing0TestCase.py

I've used Pandas (python-pandas   0.13.1-2ubuntu2).

The key function is filter1(). It's pretty well documented in there, but it
an intersection of all acceptable records for each variable.

** Testing

There is also a Makefile that runs the TestCase

 make ARGS=exampleA_input.csv check

and change the ARGS file and with the output files, you can run diff in
side-by-side format on the input to output. 

 make check-all

The *_output.csv files from the zipfile are in a subdir t and I've produced
a diff with that too using the same check-all rule.

** Results

Unfortunately, I don't tally with the output results. exampleA is fine.

exampleC shows the difference. My output is on the left, the zipfile is on
the right.

Id,Var1,Var2,Decision						Id,Var1,Var2,Decision
2,20,4,1							2,20,4,1
							      >	3,30,1,0
4,40,7,1							4,40,7,1
7,25,6,0						      |	5,50,3,0
							      >	6,20,11,0
							      >	7,25,6,0

Looking at the input

Id,Var1,Var2,Decision
1,10,9,0
2,20,4,1
3,30,1,0
4,40,7,1
5,50,5,0
6,20,11,0
7,25,6,0

The rules are: 
 for only the Decision==1 records, find min and max for each column 

2,20,4,1
4,40,7,1

Clearly, using () for open limit (>, <) and [] for closed (>=, <=)
Var1 has permitted range (20,40)
Var2 has permitted range (4,7)

So annotating with ~ meaning invalid on the permitted ranges.

1,10,9,0 ~Var1, ~Var2
3,30,1,0 ~Var2
5,50,5,0 ~Var1
6,20,11,0 ~Var1 ~Var2
7,25,6,0 

So only one valid record. 7,25,6,0 

The output I produce is

Id,Var1,Var2,Decision
2,20,4,1
4,40,7,1
7,25,6,0



** 

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
