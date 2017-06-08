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

    const std::vector<int> apply(const std::vector<int> &);
    const std::vector<int> apply0(const std::vector<int> &);
    const std::vector<int> apply1(const std::vector<int> &);
    
    void show(const std::string & mesg, const std::vector<int> &);
  };

}

#endif 
