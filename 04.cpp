#include <cstring>

class GifImage {
public:
  static GifImage GetGif() {
    const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a' }; 
    return GifImage(sampleData, sizeof(sampleData)); }

  GifImage(const char * data, unsigned long dataSize) { 
    size = dataSize;
    buffer = new char[size];
    memcpy(buffer, data, size);}

  ~GifImage() { delete[] buffer;  }
  

  char* buffer;
  unsigned long size;
};

int main() {
  GifImage gif = GifImage::getGif();
  return 0;
}




/*



rdi, rsi, rdx, rcx, r8, r9 (in order).

  
---------------------------
getGif():
    push    rbp                                               ; Save base pointer
    mov     rbp, rsp                                          ; Setup new frame
    sub     rsp, 32                                           ; Allocate stack space
    mov     [rbp-24], rdi                                     ; Save destination address (used for RVO)
    mov     DWORD PTR [rbp-6], 944130375                      ; Load data literal part 1
    mov     WORD PTR [rbp-2], 24889                           ; Load data literal part 2
    lea     rcx, [rbp-6]                                      ; Load address of string literal
    mov     rax, [rbp-24]                                     ; Load destination (location to construct into)
    mov     edx, 6                                            ; Size argument
    mov     rsi, rcx                                          ; char* argument
    mov     rdi, rax                                          ; Destination address passed to constructor
    call    GifImage::GifImage(char const*, unsigned long)    ; Construct directly in caller's memory (RVO!)
    mov     rax, [rbp-24]                                     ; Return address of constructed object
    leave                                                     ; Restore stack
    ret                                                       ; Return (object already in-place)


 void main() {
  GifImage gif = getGif();  
}


main:
    push    rbp                          ; Standard prologue
    mov     rbp, rsp                     ;
    push    rbx                          ; Save rbx (callee-saved)
    sub     rsp, 24                      ; Allocate stack
    lea     rax, [rbp-32]                ; Compute address of 'img' local var
    mov     rdi, rax                     ; Pass address as destination for RVO
    call    getGif()                     ; Call getGif(), result directly in-place (RVO)
    mov     ebx, 0                       ; ebx = 0 (return value)
    lea     rax, [rbp-32]                ; Prepare to destroy img
    mov     rdi, rax                     ; Pass to destructor
    call    GifImage::~GifImage()        ; Destroy img explicitly
    mov     eax, ebx                     ; Return value setup
    mov     rbx, [rbp-8]                 ; Restore rbx
    leave                                ; Restore frame
    ret                                  ; Return from main
  
*/
