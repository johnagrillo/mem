#include <iostream>
#include <cstring>
#include "gifimage.h" 

class GifImage {
  
public:
  GifImage(const char * data, size_t dataSize);
  ~GifImage() //__attribute__((used))

private:
  char* buffer;
  size_t size;
};

GifImage::GifImage(const char * data, size_t dataSize)
{ 
  size = dataSize;
  buffer = new char[size];
  memcpy(buffer, data, size);
}

GifImage::~GifImage()
{
  delete[] buffer;
};




