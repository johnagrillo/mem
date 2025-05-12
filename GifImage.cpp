#include <iostream>
#include <cstring>
#include "gifimage.h" 

GifImage::GifImage(const char * data,
	   size_t dataSize)
{ 
  size = dataSize;
  buffer = new char[size];
  memcpy(buffer, data, size);
}

GifImage::~GifImage()
{
  delete[] buffer;
};




