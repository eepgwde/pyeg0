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

  {
    int optct = optionProcess( &checkOptions, argc, argv );
    argc -= optct;
    argv += optct;
  }
  if (ENABLED_OPT( SHOW_DEFS )) {
    int    dirct = STACKCT_OPT( CHECK_DIRS );
    const char** dirs  = STACKLST_OPT( CHECK_DIRS );
    while (dirct-- > 0) {
      const char* dir = *dirs++;
      std::cout << "opt: " << dir << std::endl;
      /*
	...
      */
    }
  }

  if (argc > idx && (t0 = std::stoi(argv[idx]) ) > 0) 
    test0[idx-1] = t0;
  idx++;

  if (argc > idx && (t0 = std::stoi(argv[idx]) ) > 0) 
    test0[idx-1] = t0;
  idx++;

  if (test0[0] == 1) {
    const int N = weaves::Partials::maxN;
    std::vector<int> A(N);

    fill(A.begin(), A.end(), 1);
    weaves::Partials p0;
    p0.apply(A);
  } else if (test0[0] == 2) {
    const std::vector<int> eg0({3, 1, 2, 4, 3});
    weaves::Partials p0;
    const std::vector<int> sums = p0.apply(eg0);
    std::cout << sums.back() << std::endl;

    p0.show("A:                 ", eg0);
    p0.show("Partial sums of A: ", sums);

  } else if (test0[0] == 3) {
    const std::vector<int> eg0({3, 1, 2, 4, 3});
    weaves::Partials p0;
    p0.apply0(eg0);
  } else if (test0[0] == 4) {
    const std::vector<int> eg0({3, 1, 2, 4, 3});
    weaves::Partials p0;
    p0.apply0(eg0);
  } else if (test0[0] == 5) {
    const std::vector<int> eg0({3, 1, 2, 4, 3});
    weaves::Partials p0;
    std::vector<int> sums = p0.apply1(eg0);
    p0.show("A:                 ", eg0);
    p0.show("Deltas: sums of A: ", sums);
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

