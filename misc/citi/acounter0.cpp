#include <atomic>
#include <iostream>

#include <assert.h>
 
std::atomic<int>  ai;
 
int  tst_val= 3;
int  new_val= 4;

void valsout(bool exchanged)
{
  std::cout << "ai= " << ai
	    << "  tst_val= " << tst_val
	    << "  new_val= " << new_val
	    << "  exchanged= " << std::boolalpha << exchanged
	    << std::endl;
}

int main1()
{
  tst_val= 3;
  new_val= 4;
 
  bool exchanged= false;
  ai= tst_val;
  valsout(exchanged);
 
  // tst_val != ai   ==>  tst_val is modified
  exchanged= ai.compare_exchange_strong( tst_val, new_val );
  valsout(exchanged);
 
  // tst_val == ai   ==>  ai is modified
  exchanged= ai.compare_exchange_strong( tst_val, new_val );
  valsout(exchanged);
}

/**
 
 exercise: locking counter.

*/

// locking counter
//
// could use a static or a singleton for use across threads within a process.

// I'm a TDD. I usually design from the top-down and then implement from the
// bottom up. Testing the logic of using the objects in the API.

// I don't always organize and log those experiments. I use git to capture a
// design-check version.

// Questions:

// This looks like a resource locker, similar to the reference
// counting scheme you might have for a shared pointer.
// 
// It might be used to solve a dead-lock issue:
// dining philosophers.

// The number appears to be the remaining tickets for identical resources.
// I haven't counted them to accurately.

// I've made use of my knowledge about multi-threaded processing, which is that,
// usually, threads yield on a select() call.

// A fully pre-emptive system would need locking on the calls.

// It is also not templated, it might be worthwhile extending these to
// produce tickets and being able to return tuples.

// Some applications might need to have two or more tickets. For
// example, this class might provide access to database query servers 
// load-balancing and authenticating.

// I didn't use a real testing infra-structure. Testing multi-threaded
// access is always problematic.

struct ctr0 {
  std::atomic<int>  ai0;

  // Number of resources to manage.
  //
  // Use the compiler to throw the error.
  ctr0(unsigned int x) {
    ai0 = x;
  }

  // resource lock
  //
  // Stack variables are always thread-safe - re-entrancy.
  // We always test and compare to zero.
  // 
  // returns -1 when counted out.
  int get() {
    int tst_val = 0; 		
    // use an atomic swap to remain at 0.
    // the exchange call is odd, it takes a reference and sets it to ai0
    // current value. I could have used that rather than the load, but I would
    // have to check the logic with a test script.
    // But I know this operation would be thread safe.
    //
    // so simpler logic might be as in get0().
    
    bool exchanged = ai0.compare_exchange_strong( tst_val, 0 );
    int x = ai0.load();
    if (!x) return -1;

    ai0--;
    return x;
  }

  // much simpler, might be.
  // but still two operations on the atomic.
  int get0() {
    int tst_val = 0;
    return ai0.compare_exchange_strong( tst_val, 0 ) ? -1 : ai0-- ;
  }

  // Return a counted resource.
  //
  // pre-increment, again, I could check if the ai0++ alone would work.
  int release() {
    // return ai0++;
    
    int x = ai0.load();
    ai0++;
    return x;
  }

  // much simpler and therefore try an inline.
  inline int release0() {
    return ai0++;
  }
  
};

int main3()
{
  ctr0 ctr(3);

  tst_val= 0;
  new_val= 0;

  for (int n : {0, 1, 2, 3, 4, 5}) {
    std::cout << n << ' ' << ctr.get() << std::endl;
  }

  for (int n : {0, 1, 2, 3, 4, 5}) {
    std::cout << n << ' ' << ctr.release() << std::endl;
  }

  for (int n : {0, 1, 2, 3, 4, 5, 6, 7 }) {
    std::cout << n << " g: " << ctr.get() << std::endl;
    std::cout << n << " r: " << ctr.release() << std::endl;
    std::cout << n << " g: " << ctr.get() << std::endl;
  }

  std::cout << '\n';
 
}

int main4()
{
  ctr0 ctr(3);

  tst_val= 0;
  new_val= 0;

  for (int n : {0, 1, 2, 3, 4, 5}) {
    std::cout << n << ' ' << ctr.get0() << std::endl;
  }

  for (int n : {0, 1, 2, 3, 4, 5}) {
    std::cout << n << ' ' << ctr.release0() << std::endl;
  }

  for (int n : {0, 1, 2, 3, 4, 5, 6, 7 }) {
    std::cout << n << " g: " << ctr.get0() << std::endl;
    std::cout << n << " r: " << ctr.release0() << std::endl;
    std::cout << n << " g: " << ctr.get0() << std::endl;
  }

  std::cout << '\n';
 
}

/**
 
 end: exercise

*/

int main2()
{
  tst_val= 0;
  new_val= 0;

  bool exchanged= false;
  ai= 3;
  valsout(exchanged);

  for (int n : {0, 1, 2, 3, 4, 5}) {
    // tst_val != ai   ==>  tst_val is modified
    tst_val = 0;
    std::cout << n << ' ' << ai.load() << ' ' << tst_val << ' ' ;
    exchanged = ai.compare_exchange_strong( tst_val, new_val );
    valsout(exchanged);
    if (!exchanged) ai--;
  }

  std::cout << '\n';
 
}

int main() {
  main1();

  std::cout << '\n';

  main2();

  std::cout << '\n';

  main3();

  std::cout << '\n';

  main4();
}

//! Local Variables:
//! mode:c++
//! eval: (doxymacs)
//! eval: (auto-fill)
//! fill-column: 75
//! compile-command: "make acounter0"
//! comment-column:50 
//! comment-start: "//! "  
//! comment-end: "" 
//! End: 
