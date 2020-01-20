
// *** Some functional composition
// https://stackoverflow.com/questions/47349538/function-composition-tuples-and-unpacking

from functools import reduce
from operator import add

class upk:  #class constructor signals composer to unpack prior result
def __init__(s,r):  s.r = r  #hold function's return for wrapper function

idt = lambda x: x  #identity
wrp = lambda x: x.r if isinstance(x, upk) else (x,)  #wrap all but unpackables
com = lambda *fs: (  #unpackable compose, unpacking whenever upk is encountered
                     reduce(lambda a,f: lambda *x: a(*wrp(f(*x))), fs, idt) )

foo = com(add, upk, divmod)  #upk signals divmod's results should be unpacked
print(foo(6,4))
