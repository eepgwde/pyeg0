import unittest
import matplotlib.pyplot as plt
import GMus0TestCase

suite = unittest.TestLoader().loadTestsFromTestCase(GMus0TestCase)
unittest.TextTestRunner(verbosity=2).run(suite)

plt.plot([1,2,3,4])
plt.ylabel('some numbers')
plt.show()

# Local Variables:
# mode:python
# mode:doxymacs
# mode:auto-fill 
# py-master-file: "GMus0TestCase.py"
# fill-column: 75 
# comment-column:50 
# comment-start: "# "  
# comment-end: "" 
# End: 
