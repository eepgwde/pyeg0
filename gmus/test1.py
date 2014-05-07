import unittest
import matplotlib.pyplot as plt
import GMus0TestCase

suite = unittest.TestLoader().loadTestsFromTestCase(GMus0TestCase)
unittest.TextTestRunner(verbosity=2).run(suite)

plt.plot([1,2,3,4])
plt.ylabel('some numbers')
plt.show()

