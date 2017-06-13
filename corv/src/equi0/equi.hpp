#ifndef _EQUI
#define _EQUI

#include <iostream>
#include <iterator>
#include <fstream>
#include <vector>
#include <algorithm> // for std::copy
#include <numeric> // for std::copy
  
namespace weaves {

  struct Equilibribum {};

  struct Partials {
    static int maxN;

    Partials() {}

    std::vector<int> apply(const std::vector<int> &);
    const std::vector<int> apply0(const std::vector<int> &);
    std::vector<int> apply1(std::vector<int> &);
    const std::vector<int> apply2(const std::vector<int> &, const std::vector<int> &);
    std::vector<long> apply3(std::vector<int>);
    std::vector<long> apply4(std::vector<int>);
    std::vector<int> apply5(std::vector<int> A);
    
    template <typename T> void show
    (const std::string &mesg, const std::vector<T> &A) const {
      std::cout << mesg ;
      std::copy(A.begin(), A.end(), std::ostream_iterator<T>(std::cout, " "));
      std::cout << std::endl;
    };
  };

}

#endif 
