#include <cstring>

int main()
{
  const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a' };
  const auto* gifP = new GifImage(sampleData, sizeof(sampleData));
  const auto size = gifP->size;
  delete gifP;
  return size;
}

















