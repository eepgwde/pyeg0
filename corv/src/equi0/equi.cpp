#include "equi.hpp"

#include <limits>
#include <set>
#include <iostream>
#include <vector>
#include <tr1/memory>
#include <algorithm>
#include <iterator>
 

using namespace std;  

namespace weaves {

  int Partials::maxN = 10;

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

  template<class U, class T> struct diff0 : public binary_function<U, T, T>
  {
    diff0(U total) : total(total) {}

    T operator() (const T& x, const T& y) {
      U diff = total - 2* (U) y + (U) x;
      return diff;
    }
    const U total;
  };

  std::vector<long> bad(0);

  // The equilibrium entry.
  std::vector<long> Partials::apply3(vector<int> A) {
    if (A.size() == 0 || A.size() > 100000) {
      return bad;
    }
    
    vector<int> B(A.size());
    partial_sum(A.begin(), A.end(), B.begin());
    cout << "total: " << B.back() << endl;

    diff0<long, int> b0(B.back());
    vector<long> C(B.size());
    transform(A.begin(), A.end(), B.begin(), C.begin(), b0);

    vector<long>::iterator result = C.begin();
    while ((result = find(result, C.end(), 0)) != C.end()) {
      cout << "index: " << result - C.begin() << endl;
      result++;
    }
    
    return C;
  };

  template <typename T> int sgn(T val) {
    return  val < T(0) ? -1 : 1;
  };

  template<class T> struct sgner : public unary_function<T, int> {
    int operator() (T x) {
      return sgn(x);
    }
  };


  template<class U, class T> struct check0 : public binary_function<U, T, T> {
    check0(U total) : total(total) {}

    T operator() (const T& x, const T& y) {
      cout << "apply4: signum: sum: " << x << "; " << sgn(x) << "; "
	   << "apply4: signum: part: " << y << "; " << sgn(y) << endl;

      // If the signs are the same, return
      int s0 = sgn(x);
      if (s0 != sgn(y)) {
	if (s0 > 0 && std::abs(s0) < std::abs(y)) s0 = sgn(y);
	else if (s0 < 0 && std::abs(y) > std::abs(s0)) s0 = sgn(y);
      }
      return s0;
    }
    const U total;
  };

  // Data validation: seeking integer overflow.
  std::vector<long> Partials::apply4(vector<int> A) {
    if (A.size() == 0 || A.size() > 100000) {
      return bad;
    }    
    
    vector<int> B(A.size());
    partial_sum(A.begin(), A.end(), B.begin());

    vector<int> C(B.size());
    sgner<int> sgner0;
    transform(B.begin(), B.end(), C.begin(), sgner0);
    show("apply4: sums:   ", B);
    show("apply4: signs:  ", C);

    // Evaluate signs from prior partial and current.
    check0<int, int> c0(0);
    vector<int> D(B.size()-1);
    D.insert(D.begin(), sgn(*B.begin()));
    transform(B.begin(), B.end()-1, A.begin()+1, D.begin()+1, c0 );
    show("apply4: signs1: ", D);

    pair<std::vector<int>::iterator, std::vector<int>::iterator> 
      result = mismatch(C.begin(), C.end()-1, D.begin());

    cout << "apply4: mismatch: " << (result.first != C.end()-1) << "; " <<
      result.first - C.begin() << endl;
    return bad;
  }

  template <typename T> int sgn0(T val) {
    return (T(0) < val) - (val < T(0));
  };

  template <typename T> int sgn1(T val) {
    return val <= T(0) ? 0 : 1;
  };

  template<class T> struct uptick : public binary_function<T, T, T> {
    bool i0 = true;
    T operator() (const T n, const T m) {
      cout << "apply5: n, m, signum: " 
	   << n << " ; "
	   << m << " ; " 
	   << sgn1(n-m) << endl;

      return sgn1(n - m);
    }
  };

  template<class T> struct add : public binary_function<T, T, T> {
    bool i0 = true;
    T n0 = 0;
    T operator() (const T sum0, const T n) {
      cout << "apply5: n, sum0, n0: " 
	   << n << " ; "
	   << sum0 << " ; " 
	   << n0 << endl;
      
      int result = n+ (n == 0 ? 0 : sum0);
      n0 = n;
      return result;
    }
  };

  // Longest increasing sub-sequence.
  std::vector<int> Partials::apply5(vector<int> A) {
    vector<int>& seq = A;
    vector<int> B(seq.size());
    vector<int> C(seq.size());

    show("apply5: seq:   ", seq);

    // sgn0er<int> sgn0er0;
    uptick<int> uptick0;
    add<int> add0;
    
    adjacent_difference(seq.begin(), seq.end(), B.begin(), uptick0);
    *B.begin() = 0;
    show("apply5: deltas: ", B);

    // Specialized adder that increments based on signum.
    partial_sum(B.begin(), B.end(), C.begin(), add0);
    show("apply5: sums: ", C);

    vector<int>::const_iterator it = max_element(C.begin(), C.end());
    if (it == C.end()) return A;
    vector<int>::const_iterator st0 = it - *it;

    cout << "apply5: max: length: " << it+1 - st0 << "; " 
	 << " at: " << st0 - C.begin() << "; ";
    copy(seq.begin() + (st0 - C.begin()), 
	 seq.begin() + (it+1 - C.begin()), 
	 std::ostream_iterator<int>(std::cout, " "));
    cout << endl;
    
    return A;
  }
}


