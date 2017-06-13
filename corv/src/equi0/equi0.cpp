#include <iostream>
#include <iterator>
#include <fstream>
#include <vector>
#include <algorithm>
#include <limits>

#include "equi.hpp"

#include "checkopt.h"

template<class T> struct tester : public std::unary_function<T, void>
{
  tester(const int N0) : N0(N0) {}

  void operator() (T eg0) {
    int dirct = STACKCT_OPT( TEST_ID );
    std::cout << "T count: " << dirct << std::endl;
    const char** dirs  = STACKLST_OPT( TEST_ID );
    while (dirct-- > 0) {
      const char* dir = *dirs++;

      const int t0 = std::stoi(dir);
      std::cout << "t0: " << t0 << std::endl;
      if (t0 <= 0) break;

      weaves::Partials p0;

      T A(N0);
      T sums;
      T sums1;
      std::vector<long> lsums;
      std::vector<long> lsums1;
      typename T::const_iterator it;

      switch (t0) {
      case 1: 
	fill(A.begin(), A.end(), 1);
	p0.apply(A);
	break;
      case 2: 
	// partial sums
	p0.show<int>("eg0-apply1:  ", eg0);
	sums = p0.apply(eg0);
	p0.show<int>("sums of eg0: ", sums);
	std::cout << sums.back() << std::endl;
	sums1 = p0.apply1(sums);
	p0.show<int>("sums1 of eg0: ", sums1);
	it = min_element(sums1.begin(), sums1.end());
	std::cout << "The smallest element is " << *it << "; at: " 
		  << (it - sums1.begin())+1 << "th " << std::endl;
	break;
      case 3:
	// partial sums
	p0.show<int>("eg0-apply2:  ", eg0);
	sums = p0.apply(eg0);
	p0.show<int>("sums of eg0: ", sums);
	sums1 = p0.apply2(sums, sums);

	p0.show<int>("sums:         ", sums);
	p0.show<int>("sums1 of sums:", sums1);
	break;
      case 4:
	p0.show<int>("eg0-apply3:  ", eg0);
	lsums = p0.apply3(eg0);
	p0.show<long>("sums of eg0: ", lsums);
	break;
      case 5:
	p0.show<int>("eg0-apply4:  ", eg0);
	lsums = p0.apply4(eg0);
	p0.show<long>("sums of eg0: ", lsums);
	break;

      case 6:
	p0.show<int>("eg0-apply5:  ", eg0);
	sums = p0.apply5(eg0);
	break;
       
      default:
	break;
      }
    }
  }
  const int N0;
};
  
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

  // 4294967294
  const std::vector<int> eg1({3, 1, 2, 4, 3});
  const std::vector<int> eg2({-1, 3, -4, 5, 1, -6, 2, 1});
  const std::vector<int> eg3({std::numeric_limits<int>::max(), std::numeric_limits<int>::min() });

  // This produces integer overflow in expression warning from the compiler.
  const std::vector<int> eg4({2*std::numeric_limits<int>::max(), 2*std::numeric_limits<int>::min() });
  const std::vector<int> eg5({ std::numeric_limits<int>::max(), std::numeric_limits<int>::max(), std::numeric_limits<int>::max() });

  weaves::Partials p1;
  p1.show("limits: ", eg3);

  const std::vector<std::vector<int>> egs({ eg1, eg2, eg3, eg4, eg5 });

  const std::vector<int>& eg0 = eg2;

  tester<std::vector<int> > tester0(N0);
  for_each (egs.begin(), egs.end(), tester0);
  
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

