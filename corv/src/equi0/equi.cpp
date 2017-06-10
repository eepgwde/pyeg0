#include "equi.hpp"

using namespace std;  

namespace weaves {

  int Partials::maxN = 10;

  const vector<int> eg0({3, 1, 2, 4, 3});

  void Partials::show(const string &mesg, const vector<int> &A) const {
    std::cout << mesg ;
    std::copy(A.begin(), A.end(), std::ostream_iterator<int>(std::cout, " "));
    std::cout << endl;
  }

  std::vector<int> Partials::apply(const vector<int> &A) {
    vector<int> B(A.size());
    partial_sum(A.begin(), A.end(), B.begin());
    return B;
  };

  const std::vector<int> Partials::apply0(const vector<int> &A0) {
    int A[] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100};
    const int N = sizeof(A) / sizeof(int);
    int B[N];

    cout << "A[]:         ";
    copy(A, A + N, ostream_iterator<int>(cout, " "));
    cout << endl;
  
    adjacent_difference(A, A + N, B);
    cout << "Differences: ";
    copy(B, B + N, ostream_iterator<int>(cout, " "));
    cout << endl;

    cout << "Reconstruct: ";
    partial_sum(B, B + N, ostream_iterator<int>(cout, " "));
    cout << endl;
    return A0;
  };

  template<class T> struct bias : public unary_function<T, T>
  {
    bias(T total) : total(total) {}

    T operator() (T x) {
      T diff = abs(x - (total - x));
      return diff;
    }
    const T total;
  };

  std::vector<int> Partials::apply1(vector<int> &A0) {
    bias<int> b0(A0.back());
    cout << "last: " << A0.back() << endl;

    transform(A0.begin(), A0.end(), A0.begin(), b0);
    return A0;
  };

  template<class T> struct diff : public binary_function<T, T, T>
  {
    diff(T total) : total(total) {}

    T operator() (const T& x, const T& y) {
      std::cout << "sum: " << total << "; " << x << "; " << y << std::endl;
      // left - right; where right === total - left
      T diff = x - (total - y);
      return diff;
    }
    const T total;
  };

  // 
  const std::vector<int> Partials::apply2(const vector<int> &A, 
					  const vector<int> &B) {
    diff<int> b0(B.back());
    vector<int> C(B.size());

    transform(A.begin(), A.end(), B.begin(), C.begin(),
	      b0);
    return C;
  };


}


