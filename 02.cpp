#include <iostream>
#include <cstring>

class GifImage {
 public:
  GifImage getGif() {
    const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a',  };  // Simulated GIF header
    GifImage img(sampleData, sizeof(sampleData));
    return img;  }
  
  GifImage(const char* data, size_t dataSize)
  {
    size = dataSize;
    buffer = new char[size];
    memcpy(buffer, data, size); }

  // Deep Copy
  GifImage(const GifImage& other) {
    size = other.size;
    buffer = new char[size];
    memcpy(buffer, other.buffer, size); }

  ~GifImage() {
    delete[] buffer;
  }

  char* buffer;
  size_t size;

};

int main() {
    GifImage gif = getGif();  
    return 0;
}


GifImage::~GifImage() [base object destructor]:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     QWORD PTR [rbp-8], rdi
        mov     rax, QWORD PTR [rbp-8]
        mov     rax, QWORD PTR [rax]
        test    rax, rax
        je      .L5
        mov     rax, QWORD PTR [rbp-8]
        mov     rax, QWORD PTR [rax]
        mov     rdi, rax
        call    operator delete[](void*)
.L5:
        nop
        leave
        ret


GetGif
──────────────────────────────────────────────────────────────────────────────
Instruction                               | Explanation
------------------------------------------|-------------------------------------
push    rbp                               | Save base pointer
mov     rbp, rsp                          | Set up new stack frame
sub     rsp, 48                           | Allocate 48 bytes on stack
mov     QWORD PTR [rbp-40], rdi           | Store destination pointer
mov     DWORD PTR [rbp-6], 944130375      | Write first 4 bytes of GIF header
mov     WORD PTR [rbp-2], 24889           | Write last 2 bytes (6 total)
lea     rcx, [rbp-6]                      | rcx = pointer to GIF data
lea     rax, [rbp-32]                     | rax = target address for temp object
mov     edx, 6                            | Size = 6 bytes
mov     rsi, rcx                          | rsi = pointer to data
mov     rdi, rax                          | rdi = destination object
call    GifImage(char const*, size_t)     | Construct GifImage from data
lea     rdx, [rbp-32]                     | rdx = source (temp object)
mov     rax, QWORD PTR [rbp-40]           | rax = destination object
mov     rsi, rdx                          | rsi = source object
mov     rdi, rax                          | rdi = target (return value)
call    GifImage(GifImage const&)         | Copy constructor
lea     rax, [rbp-32]                     | rax = address of temp object
mov     rdi, rax                          | rdi = for destructor
call    ~GifImage()                       | Destroy temp object
nop                                       | No-op
mov     rax, QWORD PTR [rbp-40]           | Move return value to rax
leave                                     | Clean up stack frame
ret                                       | Return from getGif

──────────────────────────────────────────────────────────────────────────────
Function: main
──────────────────────────────────────────────────────────────────────────────
Instruction                               | Explanation
------------------------------------------|-------------------------------------
push    rbp                               | Save base pointer
mov     rbp, rsp                          | Set up new frame
push    rbx                               | Save rbx
sub     rsp, 24                           | Allocate stack space
lea     rax, [rbp-32]                     | rax = buffer for GifImage
mov     rdi, rax                          | rdi = pass to getGif
call    getGif                            | Call function
mov     ebx, 0                            | Set return code = 0
lea     rax, [rbp-32]                     | rax = address of return object
mov     rdi, rax                          | rdi = pass to destructor
call    ~GifImage()                       | Destroy returned object
mov     eax, ebx                          | Set return value
mov     rbx, QWORD PTR [rbp-8]            | Restore rbx
leave                                     | Clean up stack
ret                                       | Return from main
