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
    
    void show(const std::string & mesg, const std::vector<int> &) const;
  };

}

#endif 
