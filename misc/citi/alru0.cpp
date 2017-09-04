#include <iostream>
#include <chrono>
#include <mutex>

#include <thread>
#include <unordered_map>
#include <set>

#include <assert.h>
 
/**
 
 exercise: lru cache

*/

// lru cache

std::mutex lock0;
  
template<typename key_t, typename value_t>
struct LRU {
  const std::chrono::seconds sec;

  typedef std::pair<value_t, bool> pair0;

  // Some test data in the cache.
  std::unordered_map<key_t, pair0> lru_ = {
    {"RED", { "#FF0000", true } },
    {"GREEN", { "#00FF00", true } },
    {"BLUE", { "#0000FF", true } }
    };

  std::set<key_t> hits_;

  LRU(unsigned int secs) :sec(secs) {
    for(auto it = lru_.begin(); it != lru_.end(); ++it) {
      hits_.insert(it->first);
    } 
  }

  // insert a key
  // returns true if an upsert.
  bool insert(const key_t & k, value_t v) {
    std::lock_guard<std::mutex> lock(lock0);
    bool changed = false;
    auto s0 = lru_.find(k);
    changed = s0 == lru_.end();

    pair0 p0(v, true);
    lru_[k] = p0;
    hits_.insert(k);
    return changed;
  }

  bool remove(const key_t & k) {
    std::lock_guard<std::mutex> lock(lock0);
    hits_.erase(k);
    return lru_.erase(k) > 0;
  }

  // search and test value.
  bool search(const key_t & k, value_t& value) {
    std::lock_guard<std::mutex> lock(lock0);
    auto s0 = lru_.find(k);
    if (s0 == lru_.end()) {
      return false;
    }

    hits_.insert(k);
    s0->second.second = true;
      
    return value == s0->second.first;
  }

  mutable std::set<key_t> unhit = std::set<key_t>();

  void prune() {
    std::lock_guard<std::mutex> lock(lock0);

    std::cerr << "pruning: " << running << " (hits, cached): " <<
      hits_.size() << ' ' << lru_.size() << std::endl;

    // Erase those not hit.
    unhit.clear();
    for(auto it = lru_.begin(); it != lru_.end(); ++it) {
      if (!(it->second).second) {
	unhit.insert(it->first);
	continue;
      }

      auto hit0 = hits_.find(it->first);
      if (hit0 == hits_.end())
	(it->second).second = false;
    } 

    for (auto it = unhit.begin(); it != unhit.end(); ++it) {
      lru_.erase(*it);
    }

    // Reset the hit cache.
    hits_.clear();
    
  }

  bool running = false;
  std::thread * th = nullptr;

  ~LRU() {
    if (running) stop();
  }

  void start() {
    running = true;

    th = new std::thread([=]()
		{
		  while (running == true) {
		    std::this_thread::sleep_for(std::chrono::milliseconds(sec));
		    prune();
		  }
		});

  }

  void stop() {
    running = false;
    th->join();
    delete th;
  }
  
};

static LRU<std::string, std::string> lru(3);

int main1()
{
  std::thread t(&LRU<std::string, std::string>::prune, lru);
  t.join();
}

int main2()
{
  lru.start();

  std::chrono::seconds sec(10);

  std::this_thread::sleep_for(std::chrono::milliseconds(sec));
  lru.stop();
}

/**
 
 end: exercise

*/

int main3()
{
  lru.start();

  std::chrono::seconds sec3(3);

  lru.insert("Cornflower blue", "#6195ED");
  lru.insert("Cornflower blue", "#6195ED");
  lru.insert("Albescent White", "#F5E9D3");
  lru.insert("Acadia", "#1B1404");

  std::string s("#6195ED");
  lru.insert("Cornflower blue", s);

  std::this_thread::sleep_for(std::chrono::milliseconds(sec3));
  
  lru.insert("Acadia", "#1B1404");
  std::this_thread::sleep_for(std::chrono::milliseconds(sec3));
  
  lru.remove("RED");
  std::this_thread::sleep_for(std::chrono::milliseconds(sec3));

  std::string s1("#6195ED");
  lru.search("Acadia", s1);

  std::this_thread::sleep_for(std::chrono::milliseconds(sec3));
  std::this_thread::sleep_for(std::chrono::milliseconds(sec3));
  std::this_thread::sleep_for(std::chrono::milliseconds(sec3));
  
  lru.stop();
}


int main() {
  main1();

  std::cout << '\n';

  // main2();

  std::cout << '\n';

  main3();
}

//! Local Variables:
//! mode:c++
//! eval: (doxymacs)
//! eval: (auto-fill)
//! fill-column: 75
//! compile-command: "make alru0"
//! comment-column:50 
//! comment-start: "//! "  
//! comment-end: "" 
//! End: 
