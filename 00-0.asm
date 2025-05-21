Offset    | Contents                       | Notes
----------|--------------------------------|-----------------------------
Rbp +8    | return address                    | caller return address
rbp +0    | [saved RBP]                       | caller base pointer
rbp -8    | ???                               | possibly padding/temporary
rbp -14   | '9' 'a' (0x6169)                  | sample data bytes (last 2 bytes)
rbp -18   | 'G' 'I' 'F' '8' (0x38464947)      | sample data bytes (first 4 bytes)
rbp -24   | GifImage object start             |  
          |   [rbp-24 + 0] buffer pointer     | GifImage.buffer (8 bytes)
          |   [rbp-24 + 8] size               | GifImage.size (8 bytes, value 6)
----------|-----------------------------------|-----------------------------
main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24               ; allocate 24 bytes for locals

    mov     DWORD PTR [rbp-14], 0x38464947   ; 'GIF8'
    mov     WORD PTR [rbp-10], 0x6169        ; 'a9'

    lea     rdi, [rbp-24]          ; GifImage object at rbp-24
    lea     rsi, [rbp-14]          ; pointer to sample data
    mov     edx, 6                 ; size = 6
    call    GifImage::GifImage

    mov     eax, DWORD PTR [rbp-16] ; load size field (at offset 8 from object start)
    mov     ebx, eax

    lea     rdi, [rbp-24]
    call    GifImage::~GifImage

    mov     eax, ebx
    leave
    ret
