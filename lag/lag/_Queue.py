from lag import Stack

class Queue:

    def __init__(self):
        self.stack_1 = Stack()
        self.stack_2 = Stack()

    def enqueue(self, item):
        self.stack_1.push(item)

    def push(self, item):
        self.enqueue(item)

    def pop(self):
        return self.dequeue()

    def peek(self):
        return self.stack_1.elements[0]

    def size(self):
        return self.stack_1.size() + self.stack_2.size()

    def is_empty(self):
        return self.stack_1.is_empty() and self.stack_2.is_empty()

    def dequeue(self):
        if not self.stack_1.is_empty():
            while self.stack_1.size() > 0:
                self.stack_2.push(self.stack_1.pop())
            res = self.stack_2.pop()
            while self.stack_2.size() > 0:
                self.stack_1.push(self.stack_2.pop())
            return res
        else:
            ## Be consistent and throw an IndexError
            self.stack_1.pop()

