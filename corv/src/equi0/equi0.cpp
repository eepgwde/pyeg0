#include <iostream>  
#include <iostream>
#include <iterator>
#include <fstream>
#include <vector>
#include <algorithm> // for std::copy

int main( int argc,      // Number of strings in array argv  
          char *argv[],   // Array of command-line argument strings  
          char *envp[] )  // Array of environment variable strings  
{  
  int count;  
  
  // Display each command-line argument.  
  std::cout << "\nCommand-line arguments:\n";  
  for( count = 0; count < argc; count++ )  
    std::cout << "  argv[" << count << "]   "  
	 << argv[count] << "\n";  

  std::ifstream is(argv[argc-1]);
  std::istream_iterator<double> start(is), end;
  std::vector<double> numbers(start, end);
  std::cout << "Read " << numbers.size() << " numbers" << std::endl;

  // print the numbers to stdout
  std::cout << "numbers read in:\n";
  std::copy(numbers.begin(), numbers.end(), 
            std::ostream_iterator<double>(std::cout, " "));
  std::cout << std::endl;

}  

