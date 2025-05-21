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
        
