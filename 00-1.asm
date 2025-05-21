+----------+----------------------------------+---------------------------------+
| Offset   | Contents                         | Notes                           |
+----------+----------------------------------+---------------------------------+
| rbp +8   | return address                   | caller return address           |
| rbp +0   | saved RBP                        | base pointer of the caller      |
| rbp -8   | saved RBX                        | callee-saved register           |
| rbp -16  | pointer to GifImage (heap addr)  | result of operator new(16)      |
| rbp -24  | sampleData bytes                 | 6 bytes: 'G' 'I' 'F' '8' '9' 'a'|
+----------+----------------------------------+---------------------------------+

main:
    push    rbp
    mov     rbp, rsp
    push    rbx
    sub     rsp, 24              
    
    mov     DWORD PTR [rbp-24], 0x38464947     ; Store 'GIF8' = 0x38464947
    mov     WORD PTR [rbp-20], 0x6139            ; Store '9a'   = 0x6139

    mov     edi, 16                      ; Allocate GifImage object (16 bytes)
    call    operator new(unsigned long)
    mov     rbx, rax                    ; store pointer in rbx

    lea     rsi, [rbp-24]               ; pointer to sample data
    mov     edx, 6                      ; size
    mov     rdi, rbx                    ; destination
    call    GifImage::GifImage(char const*, unsigned long)

    mov     QWORD PTR [rbp-16], rbx ; Save gifP to stack

    mov     rax, QWORD PTR [rbx+8]     ; Access gifP->size
    mov     ebx, eax

    mov     rdi, rbx                       ; Cleanup
    call    GifImage::~GifImage()
    mov     edi, 16
    call    operator delete(void*, unsigned long)

    mov     eax, ebx                     ; Return size
    mov     rbx, QWORD PTR [rbp-8]
    leave
    ret
