

GifImage::GetGifPtr():
        push    rbp                     ; Save base pointer of the caller
        mov     rbp, rsp                ; Set new base pointer for this function's stack frame
        push    rbx                    ; Save rbx (callee-saved register)
        sub     rsp, 24                ; Allocate 24 bytes of stack space for local variables

        ; Store "GIF8" as a 4-byte integer at [rbp-22]
        mov     DWORD PTR [rbp-22], 944130375   
        ; 944130375 decimal = 0x38664947 (little-endian: 'G' 'I' 'F' '8')

        ; Store "9a" as a 2-byte integer at [rbp-18]
        mov     WORD PTR [rbp-18], 24889  
        ; 24889 decimal = 0x6139 (little-endian: '9' 'a')

        mov     edi, 16                ; Argument for operator new: allocate 16 bytes
        call    operator new(unsigned long)  ; Allocate memory for GifImage object
        mov     rbx, rax               ; Save allocated pointer in rbx

        lea     rax, [rbp-22]          ; Load address of the "GIF89a" string on stack
        mov     edx, 6                 ; Size of the data (6 bytes)
        mov     rsi, rax               ; Second argument: pointer to data
        mov     rdi, rbx               ; First argument: pointer to allocated GifImage memory
        call    GifImage::GifImage(char const*, unsigned long) [complete object constructor]
        ; Construct GifImage in-place with data and size

        mov     rax, rbx               ; Return pointer to the newly constructed GifImage object

        mov     rbx, QWORD PTR [rbp-8] ; Restore saved rbx value (unused here but standard)
        leave                         ; Restore previous stack frame (mov rsp, rbp; pop rbp)
        ret                           ; Return to caller with GifImage* in rax


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


main:
        push    rbp                ; Save caller's base pointer
        mov     rbp, rsp           ; Set up base pointer for this function
        sub     rsp, 16            ; Allocate 16 bytes on stack for local variables

        call    GifImage::GetGifPtr()  ; Call function that returns pointer to GifImage
        mov     QWORD PTR [rbp-8], rax ; Store returned GifImage* in local variable

        mov     rax, QWORD PTR [rbp-8] ; Load pointer to GifImage
        mov     rax, QWORD PTR [rax+8] ; Load the member at offset 8 (likely the internal buffer pointer)

        leave                      ; Restore stack frame and base pointer (mov rsp, rbp; pop rbp)
        ret                        ; Return, with rax holding the buffer pointer
