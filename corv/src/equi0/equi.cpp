#include "equi.hpp"

using namespace std;  

namespace weaves {

  int Partials::maxN = 10;

  const vector<int> eg0({3, 1, 2, 4, 3});

  void Partials::show(const string &mesg, const vector<int> &A) {
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
    bias(T& total) : total(total) {}

    T operator() (T x) {
      T diff = total - x;
      return diff;
    }
    const T total;
  };

  const std::vector<int> Partials::apply1(const vector<int> &A0) {
    const int N = A0.size();
    double A[N];
    iota(A, A+N, 1);

    vector<int> B(A, A+N);
    show("iota: ", B);

    bias<int> b0(B.back());
    cout << "last: " << B.back() << endl;

    transform(B.begin(), B.end(), B.begin(), b0);
    return B;
  };

  template<class T> struct Diff : public binary_function<T, T, T>
  {
    Diff(T total) : total(total) {}

    T operator() (const T& x, T& y) {
      T diff = total - y;
      return diff;
    }
    const T total;
  };

  std::vector<int> Partials::apply2(const vector<int> &A, vector<int> &B) {
    Diff<int> b0(B.back());

    transform(A.begin(), A.end(), B.begin(), B.end(),
	      b0);
    return B;
  };


}


