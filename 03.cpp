
class GifImage {
 public:
  GifImage getGif() {
    const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a',  };
    GifImage img(sampleData, sizeof(sampleData));
    return img;  }
  
  GifImage(const char* data, size_t dataSize) {
    size = dataSize;
    buffer = new char[size];
    memcpy(buffer, data, size); }

  // Move Constructor
  GifImage(GifImage&& other) noexcept
    : buffer(other.buffer), size(other.size) {
    other.buffer = nullptr;
    other.size = 0;}

  ~GifImage() {delete[] buffer;}

  char* buffer;
  size_t size;
}
  

  

					    
