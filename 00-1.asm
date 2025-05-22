
+------------|-----------------|-------------------------
|RBP + 8     |  Return address  | Return address to caller (pushed by call)
|RBP + 0     |  Old RBP Previous| frame pointer
|RBP - 8     |  Saved rbx       |Callee-saved register pushed at function start

section .text
main:
    push    rbp
    mov     rbp, rsp
    push    rbx                ; save rbx, we'll store pointer here
    sub     rsp, 8             

    mov     edi, 16            ; size argument for operator new
    call    operator new       ; allocate GifImage object
    mov     rbx, rax           ; save pointer in rbx (GifImage*)

    lea     rsi, [rel gifData] ; rsi = pointer to gifData in .rodata
    mov     edx, 6             ; edx = size (6 bytes)
    mov     rdi, rbx           ; rdi = this pointer for GifImage::GifImage
    call    GifImage::GifImage ; call constructor

    mov     DWORD eax, [rbx+8]   ; directly access the `size` field
    mov     esi, eax             ; save for return

    mov     rdi, rbx
    test    rdi, rdi
    je      .L1

    call    GifImage::~GifImage ; call destructor

    mov     esi, 16
    mov     rdi, rbx
    call    operator delete     ; free GifImage memory

.L1:
    mov     eax, esi            ; return size in eax
    pop     rbx
    leave
    ret



section .rodata
gif_header:
	db "GIF89a", 0    ; Read-only GIF header (null-terminated)
