weaves

For Fractal Labs

This is a Stack using a list see _Stack.py

And a Queue that using two Stack objects. This latter structure uses
a Towers of Hanoi rebuild when there is a dequeue()

It has these extra features:

I've implemented push and pop to enqueue and dequeue
peek() is the first of the stack_1

I've forced an error on dequeue to make the test code for the Queue (see
test_Test1) identical to the test code for Stack, see test_Test.

In pseudo-code

Enqueue:
push passed element onto stack_1.

Dequeue:
if empty(stack_1) throw index error 
while (!empty(stack_1))
   element = pop from stack_1
   push element onto stack_2

result = pop from stack2

while (!empty(stack_1))
   element = pop from stack_2
   push element into stack_1

return result
