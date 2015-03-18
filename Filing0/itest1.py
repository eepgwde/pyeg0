## @author weaves

# import unittest
# import Filing0TestCase

import pandas as pd
import pandas

# You need to start an ipython interpreter.
# Run the Filing0TestCase in it.
# Then run these two and after you get access to a Filing0TestCase.
# which you can prototype with.

suite = unittest.TestLoader().loadTestsFromTestCase(Filing0TestCase)
unittest.TextTestRunner(verbosity=2).run(suite)

f0 = Filing0TestCase.f0
df = f0._df

# df[(np.abs() > 3).any(1)]

set(df.columns)

# Load test data

cars = pd.read_csv("u/AllCar.csv", index_col="CarID")

fails = pd.read_csv("u/Failures.csv", index_col="CarId")
fails['Decision']=1

# Set up Decision
cars = cars.join(fails, how="outer")
cars[cars['Decision'].isnull()] = 0

ct = pd.read_csv("u/CarTyres.csv")
ty = pd.read_csv("u/Tyres.csv")

# Verify with a group and a join we have all the cars
ct0 = cars.join((ct.groupby('CarId').count())['CarId'], how='outer')
ct0['tag'].isnull().sum()

# Put the failure decision onto the car and tyre information.
# We cannot join, the index must be a set, so we use merge.
ct0 = pd.merge(ct, cars, left_on='CarId', right_on='CarId')

# This uses record by record mapping, very slow in Pandas

# Can't use a join - requires a unique key
# This is a foreign key lookup
if 0:
    f = lambda id0 : int((list(cars[cars.index == id0]['Decision']))[0])
    ty['Decision'] = ct['CarId'].map(f)
    #
    g = lambda id0 : int((list(ct[ct['TyreId'] == id0]['Decision']))[0])
    # id1 = int((list(ct[ct.index==1]['TyreId']))[0])
    ty['Decision']=ty['TyreId'].map(g)



ty1 = ty.copy()
ty1.rename(columns={'TyreId' : 'Id'}, inplace=True)

# ty1.drop( list(ty1.columns[[1, 2, 3]]), axis=1, inplace=True)

ty1['Id'] = ty1['Id'].astype(int)

ty1.to_csv('tyres.csv', index=False)

# Local Variables:
# mode:python
# mode:doxymacs
# mode:auto-fill 
# py-master-file: "Filing0TestCase.py"
# fill-column: 75 
# comment-column:50 
# comment-start: "# "  
# comment-end: "" 
# End: 
