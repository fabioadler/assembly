segment .data
	lf equ 0xA
	null equ 0x0
	sys_call equ 0x80
	sys_exit equ 0x1
	sys_read equ 0x3
	sys_write equ 0x4
	ret_exit equ 0x0
	std_out equ 0x1
	std_in equ 0x0

section .data
    x equ 50 
    y equ 10
    msg1 db "x maior que y", lf, null
    tam_msg1 equ $- msg1
    msg2 db "y maior que x", lf, null
    tam_msg2 equ $- msg2

section .text
    global _start

_start:
    mov eax,x
    mov ebx,y
    cmp eax,ebx      ;| Semelhante a o if, compara os valores dos registradores
    jg maior         ;saltos condicionais
    mov ecx,msg2     ;je =
    mov edx,tam_msg2 ;jg >
    jmp final        ;jge >=
                     ;jl <
                     ;jle <=
                     ;jne !=
                     ;salto incondicional
                     ;jmp (jump) - salto para algum ponto
    
maior:
    mov ecx,msg1
    mov edx,tam_msg1
    jmp final

final:
    mov eax,sys_write
    mov ebx,std_out
    int sys_call

    mov eax,sys_exit
    mov ebx,ret_exit
    int sys_call
