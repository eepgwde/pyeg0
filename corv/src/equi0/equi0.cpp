#include <iostream>
#include <iterator>
#include <fstream>
#include <vector>
#include <algorithm> // for std::copy

int main( int argc,      // Number of strings in array argv  
          char *argv[],   // Array of command-line argument strings  
          char *envp[] )  // Array of environment variable strings  
{  
  int count0;  

  Partials p0(10);
  
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

