
int main()
{
  const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a' };
  const auto gif = GifImage(sampleData, sizeof(sampleData));
  return gif.size ;
}















