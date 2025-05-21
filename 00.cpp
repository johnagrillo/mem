#include <cstring>

class GifImage {
public:

  GifImage(const char * data, unsigned long dataSize)
  { 
    size = dataSize;
    buffer = new char[size];
    memcpy(buffer, data, size);
  }

  ~GifImage()
  {
    delete[] buffer;
  }
  
  char* buffer;
  unsigned long size;
};









int main() {
  const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a' };
  const auto* gifP = new GifImage(sampleData, sizeof(sampleData));
  const auto gif = GifImage(sampleData, sizeof(sampleData));
  return gif.size + gifP->size();
}


Offset    | Contents                        | Notes
----------|----------------------------------|-----------------------------
rbp +8    | return address                   } not directly accessible via rbp unless manually calculated
rbp+0     | [saved RBP]                      | base pointer of the caller
rbp-8     | ???                              | possibly padding/temp
rbp-16    | ???                              | possibly padding/temp
rbp-24    | pointer to GifImage (gifP)       | 8 bytes
rbp-32    | unsigned long size (6)           | 8 bytes
rbp-33    | 'a'                              | sampleData[5]
rbp-34    | '9'                              | sampleData[4]
rbp-35    | '8'                              | sampleData[3]
rbp-36    | 'F'                              | sampleData[2]
rbp-37    | 'I'                              | sampleData[1]
rbp-38    | 'G'                              | sampleData[0]
rbp-39    | ??                               | padding
rbp-40    | ??                               | padding














