#include <memory>
#include <cstring>

class GifImage {
public:
  static auto GetGif() noexcept {
    const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a' };
    return std::unique_ptr<GifImage>(new GifImage(sampleData, sizeof(sampleData)));
    
  GifImage(const char * data, unsigned long dataSize) noexcept { 
    size = dataSize;
    buffer = new char[size];
    memcpy(buffer, data, size);}

  ~GifImage() { delete[] buffer;  }

  char* buffer;
  unsigned long size;
};

int main() {
  auto gifPtr  = GifImage::GetGif();
  return gifPtr->size;
}



