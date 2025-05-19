


 GifImage::GifImage(GifImage const&) [base ctor]:                     | GifImage(const GifImage& other) {           |

Assembly                                      | C++ Code
---------------------------------------------|---------------------------------------------
mov rdx, [rsi+8]                              | size = other.size;
mov [rdi+8], rdx                              |
mov rdi, rdx                                  | buffer = new char[size];
call operator new[]                           |
mov [rdi], rax                                | this->buffer = allocated;
mov rcx, [rsi]                                |
mov rsi, rcx                                  | memcpy(buffer, other.buffer, size);
mov rdi, rax                                  |
call memcpy                                   |
	

GetGif
──────────────────────────────────────────────────────────────────────────────
Instruction                               | Explanation
------------------------------------------|-------------------------------------
push    rbp                               | Save base pointer
mov     rbp, rsp                          | Set up new stack frame
sub     rsp, 48                           | Allocate 48 bytes on stack
mov     QWORD PTR [rbp-40], rdi           | Store destination pointer
mov     DWORD PTR [rbp-6], 944130375      | Write first 4 bytes of GIF header
mov     WORD PTR [rbp-2], 24889           | Write last 2 bytes (6 total)
lea     rcx, [rbp-6]                      | rcx = pointer to GIF data
lea     rax, [rbp-32]                     | rax = target address for temp object
mov     edx, 6                            | Size = 6 bytes
mov     rsi, rcx                          | rsi = pointer to data
mov     rdi, rax                          | rdi = destination object
call    GifImage(char const*, size_t)     | Construct GifImage from data
lea     rdx, [rbp-32]                     | rdx = source (temp object)
mov     rax, QWORD PTR [rbp-40]           | rax = destination object
mov     rsi, rdx                          | rsi = source object
mov     rdi, rax                          | rdi = target (return value)
call    GifImage(GifImage const&)         | Copy constructor
lea     rax, [rbp-32]                     | rax = address of temp object
mov     rdi, rax                          | rdi = for destructor
call    ~GifImage()                       | Destroy temp object
nop                                       | No-op
mov     rax, QWORD PTR [rbp-40]           | Move return value to rax
leave                                     | Clean up stack frame
ret                                       | Return from getGif
---------------------------------------------------------------------------------------	


	
