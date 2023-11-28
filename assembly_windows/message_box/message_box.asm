;ld -L C:\windows\system32 -l kernel32 -l user32  message_box.o -o message_box.exe

extern _MessageBoxA
extern _ExitProcess

section .data
    title db 'Hello',0
    msg db 'Hello Word',0

section .text

global _start

_start:
    push 0
    push title
    push msg
    push 0
    call _MessageBoxA
    push 0
    call _ExitProcess