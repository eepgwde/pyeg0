## @author weaves
##
## 

class Stack:
    """
    Stack implementation using native list.
    """

    def __init__(self):
        self.elements = []

    def push(self, item):
        self.elements.append(item)

    def pop(self):
        """
        Return the stored reference to top element and remove it from the stack.

        This does not trap exceptions. Use is_empty() prior to invoking this.
        """
        return self.elements.pop()

    def peek(self):
        """
        Return the stored reference and do not remove it.

        This does not trap exceptions. Use is_empty() prior to invoking this.
        """
        return self.elements[-1]

    def size(self):
        return len(self.elements)

    def is_empty(self):
        return self.size() == 0
