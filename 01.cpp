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
  GifImage gif = GifImage::GetGif();
  return gif.size;
}





/*
  GifImage::GifImage(char const* data, size_t size):
    ; Parameters:
    ; rdi = this    ;; allocated  object
    ; rsi = data
    ; rdx = size

    ; Save size to this->size
    mov     QWORD PTR [rdi+8], rdx        ; this->size = size

    ; Allocate memory for buffer
    mov     rax, rdx                      ; rax = size
    mov     rdi, rax                      ; rdi = size (arg to operator new[])
    call    operator new[](unsigned long)
    mov     QWORD PTR [rdi], rax          ; this->buffer = new char[size]

    ; memcpy(this->buffer, data, size)
    mov     rdi, QWORD PTR [rdi]          ; rdi = this->buffer (dest)
    mov     rsi, rsi                      ; rsi = data (src)
    mov     rdx, QWORD PTR [rdi+8]        ; rdx = size
    call    memcpy

    ret




GifImage::GifImage(GifImage const&):
        push    rbp                        ; Save the old base pointer (function prologue)
        mov     rbp, rsp                   ; Set up the new base pointer (frame pointer)
        
        ; Save the "this" pointer and the argument pointer
        mov     QWORD PTR [rbp-8], rdi      ; Store "this" pointer (GifImage*) into [rbp-8]
        mov     QWORD PTR [rbp-16], rsi     ; Store the reference to the other GifImage (const GifImage&) into [rbp-16]

        ; Copy the "this" pointer data
	
        mov     rcx, QWORD PTR [rbp-8]      ; Load "this" pointer into rcx (GifImage*)
        mov     rax, QWORD PTR [rbp-16]     ; Load "other" GifImage pointer into rax (const GifImage&)
        mov     rdx, QWORD PTR [rax+8]      ; Load "size" from the other GifImage (this is the data member)

        ; Copy "buffer" pointer
        mov     rax, QWORD PTR [rax]        ; Load the "buffer" pointer from the other GifImage
        mov     QWORD PTR [rcx], rax        ; Set "this->buffer" to the "buffer" from the other GifImage
        mov     QWORD PTR [rcx+8], rdx      ; Set "this->size" to the "size" from the other GifImage

        ; Function epilogue (restore stack)
        nop                                 ; No operation, just to align the code (optional)
        pop     rbp                        ; Restore the base pointer (function epilogue)
        ret                                 ; Return from the constructor


GifImage getGif() {
  const char sampleData[] = { 'G', 'I', 'F', '8', '9', 'a' }; 
  GifImage img(sampleData, sizeof(sampleData));
  return img;  
}

    
getGif():
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     QWORD PTR [rbp-40], rdi
        mov     DWORD PTR [rbp-6], 944130375
        mov     WORD PTR [rbp-2], 24889
        lea     rcx, [rbp-6]
        lea     rax, [rbp-32]
	
        mov     edx, 6
        mov     rsi, rcx
        mov     rdi, rax
	
        call    GifImage::GifImage(char const*, unsigned long) [complete object constructor]
        lea     rdx, [rbp-32]
        mov     rax, QWORD PTR [rbp-40]
        mov     rsi, rdx
        mov     rdi, rax
        call    GifImage::GifImage(GifImage const&) [complete object constructor]
        lea     rax, [rbp-32]
        mov     rdi, rax
        call    GifImage::~GifImage() [complete object destructor]
        nop
        mov     rax, QWORD PTR [rbp-40]
        leave
        ret
  

	
FUNCTION: GifImage::GifImage(GifImage const&)
----------------------------------------------
push    rbp                    ; Save base pointer
mov     rbp, rsp               ; Set up new stack frame
mov     QWORD PTR [rbp-8], rdi ; Save destination (this pointer)
mov     QWORD PTR [rbp-16], rsi; Save source object pointer
mov     rcx, QWORD PTR [rbp-8] ; rcx = this
mov     rax, QWORD PTR [rbp-16]; rax = &other
mov     rdx, QWORD PTR [rax+8] ; rdx = other.field2
mov     rax, QWORD PTR [rax]   ; rax = other.field1
mov     QWORD PTR [rcx], rax   ; this->field1 = other.field1
mov     QWORD PTR [rcx+8], rdx ; this->field2 = other.field2
nop                            ; No-op
pop     rbp                    ; Restore base pointer
ret                            ; Return


FUNCTION: getGif()
--------------------
push    rbp
mov     rbp, rsp
sub     rsp, 48                       ; Reserve stack space

mov     QWORD PTR [rbp-40], rdi       ; Save return location
mov     DWORD PTR [rbp-6], 944130375  ; Load constant (partial data)
mov     WORD PTR [rbp-2], 24889       ; Load remaining bytes

lea     rcx, [rbp-6]                  ; rcx = char const* gif raw data
lea     rax, [rbp-32]                 ; rax = destination GifImage on stack
mov     edx, 6                        ; edx = length
mov     rsi, rcx                      ; rsi = data
mov     rdi, rax                      ; rdi = destination
call    GifImage::GifImage(char const*, unsigned long)
                                      ; Construct temporary GifImage from data
lea     rdx, [rbp-32]                 ; rdx = &temp
mov     rax, QWORD PTR [rbp-40]       ; rax = return location
mov     rsi, rdx                      ; rsi = temp
mov     rdi, rax                      ; rdi = destination
call    GifImage::GifImage(GifImage const&)
                                      ; Copy temp into return location
lea     rax, [rbp-32]                 ; rax = &temp
mov     rdi, rax
call    GifImage::~GifImage()         ; Destroy temp (explicit destructor call)
mov     rax, QWORD PTR [rbp-40]       ; Return address
leave
ret


