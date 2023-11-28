NULL equ 0
STD_OUT_HANDLE equ -11
extern _ExitProcess
extern _WriteFile
extern _GetStdHandle

global _start

section .data
    msg db 'hello word!', 0xA
    tam equ $- msg

section .text

_start:
    push STD_OUT_HANDLE
    call _GetStdHandle
    mov ebx,eax
    sub esp,4
    push NULL
    push NULL
    push tam
    push msg
    push ebx
    call _WriteFile
    sub esp,20
    push NULL
    call _ExitProcess