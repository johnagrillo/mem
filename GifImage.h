#include <iostream>
#include <cstring> 

class GifImage {
  
public:
  GifImage(const char * data, size_t dataSize)
  // __attribute__((used))
    ;

  ~GifImage() //__attribute__((used))
    ;

private:
  char* buffer;
  size_t size;
};




