
GifImage::GifImage(char const* data, unsigned long size):
        push    rbp
        mov     rbp, rsp
        
        ; Registers at function entry:
        ; rdi = this pointer (GifImage*)
        ; rsi = data pointer (const char*)
        ; rdx = size (unsigned long)

        mov     QWORD PTR [rdi+8], rdx        ; this->size = size
        mov     rdi, rdx                      ; rdi = size (for operator new[])
        call    operator new[]                ; allocate buffer = operator new[](size)
        mov     QWORD PTR [rbp-8], rax        ; save buffer pointer on stack temporarily

        mov     QWORD PTR [rdi-8], rax        ; this->buffer = allocated pointer
                                              ; NOTE: [rdi-8] because we used rbp in original
                                              ;       Here, original used [rax], careful with registers

        mov     rdi, rax                      ; dest = buffer
        mov     rsi, rsi                      ; src = data (already in rsi)
        mov     rdx, rdx                      ; size = size (already in rdx)
        call    memcpy                        ; memcpy(buffer, data, size)

        pop     rbp
        ret


GifImage::~GifImage() [base object destructor]:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     QWORD PTR [rbp-8], rdi      ; store 'this' pointer on stack

        mov     rax, QWORD PTR [rbp-8]      ; load 'this' pointer
        mov     rax, QWORD PTR [rax]        ; load this->buffer (pointer to allocated memory)
        test    rax, rax                    ; check if buffer is nullptr
        je      .L7                         ; if null, skip delete

        mov     rax, QWORD PTR [rbp-8]      ; reload 'this'
        mov     rax, QWORD PTR [rax]        ; load this->buffer again
        mov     rdi, rax                    ; argument to operator delete[] (buffer pointer)
        call    operator delete[](void*)    ; free allocated buffer memory

.L7:
        nop
        leave
        ret
        
main:	
	push    rbp
	mov     rbp, rsp
	push    rbx
	sub     rsp, 24                         ; Allocate space for GifImage
	
	lea     rdi, [rbp-32]                   ; Prepare address to construct GifImage
	call    GifImage::GetGif()              ; Construct GifImage at [rbp-32]

	mov     eax, [rbp-24]                   ; Load gif.size (stored at offset +8) into eax
	mov     ebx, eax                        ; Save result in ebx

	lea     rdi, [rbp-32]                   ; Prepare address of GifImage to destroy
	call    GifImage::~GifImage()           ; Call destructor

	mov     eax, ebx                        ; Return value -> eax
	mov     rbx, [rbp-8]                    ; Restore callee-saved register
	leave                                    mov    rsp, rbp ; pop    rbp
	ret






GifImage::GifImage(const GifImage& other):
       ; Parameters:
         ;   rdi = this (destination GifImage*)
         ;   rsi = other (const GifImage&)
        push    rbp
        mov     rbp, rsp
        mov     QWORD PTR [rbp-8], rdi      ; store 'this' pointer
        mov     QWORD PTR [rbp-16], rsi     ; store 'other' pointer
        
        mov     rcx, QWORD PTR [rbp-8]      ; rcx = this
        mov     rax, QWORD PTR [rbp-16]     ; rax = other
        mov     rdx, QWORD PTR [rax+8]      ; rdx = other.size
        mov     rax, QWORD PTR [rax]        ; rax = other.buffer
        
        mov     QWORD PTR [rcx], rax        ; this->buffer = other.buffer
        mov     QWORD PTR [rcx+8], rdx      ; this->size = other.size
        
        pop     rbp
        ret





GifImage::GetGifValue():
       ; GifImage::GetGifValue(GifImage* ret) -- ret pointer in rdi
        
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32                 ; reduce stack from 48 to 32 (O1 optimization)
        mov     QWORD PTR [rbp-32], rdi ; save ret pointer

        ; Construct temp GifImage at [rbp-24] with GIF89a data (6 bytes)
        mov     DWORD PTR [rbp-22], 944130375  ; 'G','I','F','8' 
        mov     WORD PTR [rbp-18], 24889        ; '9','a' 

        lea     rcx, [rbp-22]          ; rcx = data ptr "GIF89a"
        lea     rax, [rbp-24]          ; rax = temp GifImage address
        mov     edx, 6                 ; edx = data size 6
        mov     rsi, rcx               ; rsi = data ptr
        mov     rdi, rax               ; rdi = temp GifImage* (this)
        call    GifImage::GifImage(char const*, unsigned long) [ctor]

        ; Copy temp GifImage to caller's ret GifImage
        mov     rsi, rax               ; rsi = temp GifImage*
        mov     rdi, QWORD PTR [rbp-32] ; rdi = ret GifImage*
        call    GifImage::GifImage(GifImage const&) [copy ctor]

        ; Destroy temp GifImage
        mov     rdi, rsi               ; rdi = temp GifImage*
        call    GifImage::~GifImage() [dtor]

        ; Return ret pointer in rax
        mov     rax, QWORD PTR [rbp-32]

        leave
        ret



        
