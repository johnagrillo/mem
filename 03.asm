GifImage::GifImage(GifImage&&)
    push    rbp
    mov     rbp, rsp
    mov     QWORD PTR [rbp-8], rdi      ; store this pointer (destination object)
    mov     QWORD PTR [rbp-16], rsi     ; store source object pointer (other)

    ; ——— Transfer buffer pointer ———
    mov     rax, QWORD PTR [rbp-16]     ; rax = address of other
    mov     rdx, QWORD PTR [rax]        ; rdx = other.buffer
    mov     rax, QWORD PTR [rbp-8]      ; rax = this
    mov     QWORD PTR [rax], rdx        ; this->buffer = other.buffer

    ; ——— Transfer size ———
    mov     rax, QWORD PTR [rbp-16]
    mov     rdx, QWORD PTR [rax+8]      ; rdx = other.size
    mov     rax, QWORD PTR [rbp-8]
    mov     QWORD PTR [rax+8], rdx      ; this->size = other.size

    ; ——— Leave the moved-from object in a safe state ———
    mov     rax, QWORD PTR [rbp-16]
    mov     QWORD PTR [rax], 0          ; other.buffer = nullptr
    mov     rax, QWORD PTR [rbp-16]
    mov     QWORD PTR [rax+8], 0        ; other.size   = 0

    nop
    pop     rbp
    ret


getGif():
    push    rbp                             ; Save base pointer
    mov     rbp, rsp                        ; Set up new stack frame
    sub     rsp, 48                         ; Allocate 48 bytes of stack space

    mov     QWORD PTR [rbp-40], rdi         ; Save first argument (likely a pointer for return)
    mov     DWORD PTR [rbp-6], 944130375    ; Store part of a string or binary ID (first 4 bytes)
    mov     WORD PTR [rbp-2], 24889         ; Store remaining 2 bytes (6 total)

    lea     rcx, [rbp-6]                    ; Load address of the 6-byte string into rcx
    lea     rax, [rbp-32]                   ; Load address of local GifImage into rax

    mov     edx, 6                          ; Length of string
    mov     rsi, rcx                        ; Pointer to char const*
    mov     rdi, rax                        ; Destination: address of local GifImage
    call    GifImage::GifImage(char const*, unsigned long) 
                                            ; Construct GifImage with string

    lea     rdx, [rbp-32]                   ; Address of constructed GifImage
    mov     rax, QWORD PTR [rbp-40]         ; Load return object pointer
    mov     rsi, rdx                        ; Source: local GifImage
    mov     rdi, rax                        ; Destination: caller-provided location
    call    GifImage::GifImage(GifImage&&) 
                                            ; Move-construct GifImage to caller space

    lea     rax, [rbp-32]                   ; Address of local GifImage
    mov     rdi, rax                        ; Prepare to destroy local temporary
    call    GifImage::~GifImage()           ; Destroy local temporary GifImage

    nop                                     ; No operation (padding/alignment)

    mov     rax, QWORD PTR [rbp-40]         ; Return the pointer to the object
    leave                                   ; Restore stack frame
    ret                                     ; Return


