#ifndef _EQUI
#define _EQUI

#include <iostream>
#include <iterator>
#include <fstream>
#include <vector>
#include <algorithm> // for std::copy
#include <numeric> // for std::copy
  
using namespace std;  

namespace weaves {

  struct Equilibribum {
  
  } equi;

  struct Partials {
    const int N;
    static int maxN;

    Partials(const int N) : N(N) {}

    void apply() {
      fill(A, A+N, 1);
  
      cout << "A:                 ";
      copy(A, A+N, ostream_iterator<int>(cout, " "));
      cout << endl;

      cout << "Partial sums of A: ";
      partial_sum(A, A+N, ostream_iterator<int>(cout, " "));
      cout << endl;
    };

    int A[];
  };

}

#endif 
