#include <iostream>
#include <iterator>
#include <fstream>
#include <vector>
#include <algorithm> // for std::copy

#include "equi.hpp"

#include "checkopt.h"

int main( int argc,      // Number of strings in array argv  
          char **argv,   // Array of command-line argument strings  
          char *envp[] )  // Array of environment variable strings  
{  
  int count0;

  int test0[] = { 0, 0 };
  int t0;
  int idx = 1;
  int N0 = weaves::Partials::maxN;

  {
    int optct = optionProcess( &checkOptions, argc, argv );
    argc -= optct;
    argv += optct;
  }
  if (ENABLED_OPT( SHOW_DEFS )) {
    int dirct = STACKCT_OPT( TEST_ID );
    std::cout << "T count: " << dirct << std::endl;
    const char** dirs  = STACKLST_OPT( TEST_ID );
    while (dirct-- > 0) {
      const char* dir = *dirs++;
      std::cout << "opt: " << dir << std::endl;
    }
  }

  if (HAVE_OPT(X0_SIZE)) {
    N0 = OPT_VALUE_X0_SIZE;
    std::cout << "N0: " << N0 << std::endl;
  }

  int dirct = STACKCT_OPT( TEST_ID );
  std::cout << "T count: " << dirct << std::endl;
  const char** dirs  = STACKLST_OPT( TEST_ID );
  while (dirct-- > 0) {
    const char* dir = *dirs++;

    t0 = std::stoi(dir);
    std::cout << "t0: " << t0 << std::endl;
    if (t0 <= 0) break;

    weaves::Partials p0;
    const std::vector<int> eg0({3, 1, 2, 4, 3});

    std::vector<int> A(N0);
    std::vector<int> sums;

    switch (t0) {
    case 1: 
      fill(A.begin(), A.end(), 1);
      p0.apply(A);
      break;
    case 2: 
      sums = p0.apply0(eg0);
      std::cout << sums.back() << std::endl;
      break;
    case 3:
      sums = p0.apply1(eg0);
      p0.show("A:                 ", eg0);
      p0.show("Deltas: sums of A: ", sums);
      break;
    case 4: 
      break;
    }
  }
  
  if (test0[0] > 0) return 0;

  // Display each command-line argument.  
  std::cerr << "\nCommand-line arguments:\n";  
  for( count0 = 0; count0 < argc; count0++ )  
    std::cerr << "  argv[" << count0 << "]   "  
	      << argv[count0] << "\n";  

  std::ifstream is(argv[argc-1]);
  std::istream_iterator<double> start(is), end;
  std::vector<double> numbers(start, end);
  std::cerr << "Read " << numbers.size() << " numbers" << std::endl;

  // print the numbers to stdout
  std::cerr << "numbers read in:\n";
  std::copy(numbers.begin(), numbers.end(), 
            std::ostream_iterator<double>(std::cerr, " "));
  std::cerr << std::endl;

}  

