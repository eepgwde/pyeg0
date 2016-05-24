* Author

Walter Eaves

* Task - Warwick Analytics

This is a training set of fault data.

Find all records that have no fault in any attribute.

* Task 2 - Data Analysis 

The data is compliant with Programming Task 1.

I did some manipulation of the Tyres.csv file using the other files to
derive the Decision field. 

I discovered there are 204 failed tyre tests and 2724 successful
ones.

I ran the "include" algorithm and discovered that all of the 2724
successful tests did not have any variables recorded outside the [min, max]
ranges of the same variables in the failed tests.

The method eliminates from the analysis those successful records that have
variables that taken on values outside their normal operating ranges. So,
we conclude from our analysis, that all the successful tests have had their
variables measured within their normal operating ranges.

* Task 3 - System Analysis 

C# heap management uses mark and sweep garbage collection.  Garbage
collection takes place when memory available falls below a certain level.

Objects are initially assigned a "Generation 0" status - meaning they are
expected to be short-lived - unless they are large objects, these go
directly to "Generation 2". During the mark phase, any live objects left in
"Generation 0" are promoted to "Generation 1". Similarly, any in
"Generation 1" are promoted to "Generation 2".

The mark phase processes Generation 0 objects first and then invokes a
sweep. If garbage collection is still necessary (not below threshold), it
moves onto the Generration 1 objects and so on.

Lots of things that can be done to improve the garbage collection. 

Simple things are to improve the machine (add more RAM), this means that
garbage collection will be less frequent. You could then try and run the
garbage collection manually - in a thread. There is a lot of trial and
error involved in these kinds of changes.

Improving the algorithm to not create as many new objects: trying to re-use
objects with cacheing or memoization.

A less conventional technique is to use the stack for temporary variables
(variables that exist for just a block). It is possible with C# to
implement simple classes (usually no more than Plain Old Datatype
containers) as a struct, so it will not inherit the baggage of the Object
class. And in an unsafe code block, these struct types can be then created
on the stack.

This is quite an attractive modification to make. You would only need to
change the form of a basic type. (Unsafe code is not as dangerous as one
might think.) So you wouldn't need to re-factor and re-test as you would
with algorithm re-design.

Using the stack in unsafe blocks means that some part of the code will be
using an unmanaged run-time system. This can be taken further: key
components of the code could be implemented wholly in an unmanaged
language, usually C++. Often times not as tricky as it may seem. The
overhead for passing variables between the C++ heap to the CLR one is an
additional overhead.

* Task 1 - Programming 

** No web interface

I haven't implemented a web interface. I would do that with Django, but I
thought I wouldn't have enough time.

** Filing0 and TestCase

I've implemented a basic class for the data filtering: Filing0.py. It has a
test case Filing0TestCase.py

I've used Pandas (python-pandas   0.13.1-2ubuntu2).

The key functions are include0() and exclude0(). They're pretty well
documented in there, but it is an intersection of all acceptable records for
each variable.

See the notes that follow - there are inconsistencies between the
specification and the test data.

** Testing

There is also a Makefile that runs the TestCase

 make ARGS=exampleA_input.csv check

and change the ARGS file and with the output files, you can run diff in
side-by-side format on the input to output. 

 make check-all

The *_output.csv files from the zipfile are in a subdir t and I've produced
a diff with that too using the same check-all rule.

There are a number of tests set up. You can compare input to output, output
to analyst output and, importantly, a new test is to compare output as
input to output. You can do that last test because the system is
idempotent. That means, the output if used as input will produce the same
output as the input. (This has been designed into the implementation of the
Filing0 class, it preserves the order of the records to help in
comparison.) 

** Results

*** Mistake in specification

Unfortunately, I don't tally with the output results. In what follows, I've
used the term "analyst output" - that's the example output files given in
the Zip. 

[Ed: for some reason, there's this convention the straw man is taken to be
a straw woman, so the analyst is "she".]

Let's look at the statement in the specification.

 The app should parse the csv file and remove any records (rows) which
 meet both of the following conditions: 
  Have a Decision of 0 
  For each variable (column), no value falls between FMIN and FMAX.
 Where FMIN and FMAX are the smallest and largest value for that
 variable across all records with a decision value of 1.

So this is negative logic, remove all records and no values between [FMIN,
FMAX]. Let's call it "The Exclusion Method".

This must be wrong! Let's look at exampleA_input.csv

Id,Var1,Decision
1,10,0
2,20,1
3,30,0
4,40,1
5,50,0

Ignore the 0-type records and we get bounds [0, 20) [40, inf), because

2,20,1
4,40,1

Apply these to the 0-type records and we get the wrong ones.

1,10,0
5,50,0

because the analyst output is 

3,30,0

So I suspect she got her logic wrong. Let's check with exampleC, using the
1-type records.

2,20,4,1
4,40,7,1

gives bounds [20,40] and [4,7] on Var1 and Var2, resp'ly. Looking at the
0-type records, no records within those bounds means

1,10,9,0  
3,30,1,0 ~Var1
5,50,5,0 ~Var2
6,20,11,0 ~Var1 
7,25,6,0 ~Var1 && ~Var2

so only 

1,10,9,0 

is valid meaning the output should be

Id,Var1,Var2,Decision
1,10,9,0
2,20,4,1
4,40,7,1

And the analyst output is given as

3,30,1,0
5,50,3,0
6,20,11,0
7,25,6,0

This too is inconclusive. (It appears that the analyst has now applied the
exclusion logic.) Let's assume the analyst only managed to code exampleA
correctly. Then we change the specification to match that. Convert to
positive logic (retain rather remove) and it should read:

 The app should parse the csv file and retain records (rows) which
 meet both of the following conditions: 
  Have a Decision of 0 
  For each variable (column), value falls between FMIN and FMAX.

And call this the inclusion method.

[Ed: note, I read ahead to Part 2 and these are fault records. (1 is
faulty). So we would want good records to lie within the bounds of the
worst faulty ones.]

We now apply this logic (to exampleC) and we discover

Id,Var1,Var2,Decision
2,20,4,1
4,40,7,1
7,25,6,0

only record Id==7 is correct.

But the analyst gives

Id,Var1,Var2,Decision
2,20,4,1
3,30,1,0
4,40,7,1
5,50,3,0
6,20,11,0

but by the revised logic

 Id==3 is valid on Var1, but wrong on Var2
 Id==5 is invalid on Var1 and invalid on Var2
 Id==6 is valid on Var1, but invalid on Var2

And the analyst does *not* include record id==7.

It now appears that the analyst has applied the exclusion logic to this
data set. (25, 6) are within the (20,40) (4,7) bounds and by the exclusion
logic should be removed.

The final dataset exampleB doesn't match with either logic! But the include
logic - works with exampleA - does return 589 matches. The exclude logic
doesn't match any records.

All very confusing.

I have implemented and tested the include0() and exclude0() methods to
implement both logics. 

There will also be issues about the open or closed nature of the
interval. I've added include1() to illustrate.

** Recommendations

[Ed: a bit of role play here. I'm assuming I'm handing over to a junior.]

"I'm off on holiday tomorrow and, as you can see, I've found out that there
are some problems with implementing this CSV upload and filter system.

You should go back to the analysts and see what they intended. You don't
have to do, but, if you do, try to be light-hearted about it, they don't
appreciate being criticized and may want to put the fault on you. Don't
worry! Be magnamious. Just try and find out what they want.

If don't feel up to discussing it with the analysts, then carry on
developing the web-component, whilst I have a holiday. I'll try and resolve
it by e-mail whilst I'm away. 

Let me know!

PS 

This sort of thing rarely happens with Pairs Programming.

PPS

All the best, don't let the ship go down!"


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
