Offset    | Contents                      | Notes
----------|-------------------------------|------------------------------
RBP + 8   | Return address                | Caller return address (pushed by call)
RBP + 0   | Saved RBP                     | Previous frame pointer (push rbp)
RBP - 8   | (Unused / padding)            | Temporary or alignment padding (8 bytes)
RBP - 16  | GifImage.size                 | 8-byte unsigned long size field inside GifImage
RBP - 24  | GifImage.buffer               | 8-byte pointer to buffer inside GifImage
----------|-------------------------------|------------------------------
	
section .text
main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                 ; Allocate 24 bytes for locals

    lea     rdi, [rbp - 24]         ; GifImage object on stack
    lea     rsi, [rel gif_header]   ; Pointer to read-only GIF header
    mov     edx, 6                  ; Length
    call    GifImage::GifImage

    mov     eax, DWORD [rbp - 16]   ; Load field into eax, size
    mov     ebx, eax                ; Save return value

    lea     rdi, [rbp - 24]         ; Call destructor Pass object pointer
    call    GifImage::~GifImage

    mov     eax, ebx                ; Return value
    leave
    ret

section .rodata
gif_header:
	db "GIF89a", 0    ; Read-only GIF header (null-terminated)

	
