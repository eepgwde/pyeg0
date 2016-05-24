#include <string>
#include <iostream>

#include <string.h>
#include <malloc.h>

// Original class

namespace x0 {
  class string {
  public:
    string( char const* t ) : s(t) {}
    ~string() { delete s; }
    char const* c_str() const { return s; }
  private:
    char const* s;
  };
}

// Revised

namespace x {
  class string final {
  public:
    string(char * const t) : s(t) {}
    ~string() {
      std::cerr << "destruct" << std::endl;
      delete s;
    }
    char * const c_str() const { return s; }

  private:
    char * const s;
  };
}

static char mesg0[10] = "mesg0";

int main(int argc, char **argv) {
  std::string s("this");

  {
    // Even if s is safely on the stack, it is an invalid pointer
    // because on stack.
    // x::string x(s.c_str());
  }

  std::cerr << "next: " + s << std::endl;

  char * s0 = new char[10 + 1];
  strcpy(s0, "this0");

  {
    // This will work with new() but valgrind reports and error.
    x::string x(s0);

    char * const x0 = x.c_str();
    std::cerr << "x0: " << x0 << std::endl;
    *x0 = 't';
    std::cerr << "x0: " << x0 << std::endl;
  }

  char * s1 = (char *)malloc(sizeof(char) * 10 + 1);
  strcpy(s1, "this1");
  std::cerr << s1 << " : " << (void *)s1 << std::endl;

  {
    // This will work with malloc() but valgrind() reports and error.
    x::string x(s1);
  }

  {
    // This won't work - it references static space.

    char const *p = &mesg0[0];
    std::cerr << p << std::endl;
    // x::string x(p);
  }

  return 0;
}
