segment .data
	lf equ 0xA        ;Quebra de linha
	null equ 0xD      ;Final da String
	sys_call equ 0x80 ;Enviar informação ao SO
	sys_exit equ 0x1  ;Codigo de chamada para finalizar |
	sys_read equ 0x3  ;Operação de leitura              | --> EAX
	sys_write equ 0x4 ;Operação de escrita              |
	ret_exit equ 0x0  ;Operação realizada com sucesso |
	std_out equ 0x1   ;Saida pardrão                  | --> EBX
	std_in equ 0x0    ;Endica uma entrada padrão      |

section .data
    msg1 db "Digite um numero para realizar o calculo: ",lf,null
    tam1 equ $- msg1
    msg2 db "O resultado dinal e ",null
    tam2 equ $- msg2

section .bss
    tam_var equ 0xA
    n1 resb tam_var
    n2 resb tam_var
    resultado resb tam_var

section .text

global _start

so_input:
    mov eax,sys_write ;|
    mov ebx,std_out   ;|
    mov ecx,msg1      ;| ---> output solicia um numero
    mov edx,tam1      ;|
    int sys_call      ;|
    ret

_start:
    call so_input

    mov eax,sys_read ;|
    mov ebx,std_in   ;|
    mov ecx,n1       ;| ---> input para pegar o valor de n1
    mov edx,tam_var  ;|
    int sys_call     ;|

    call so_input

    mov eax,sys_read ;|
    mov ebx,std_in   ;|
    mov ecx,n1       ;| ---> input para pegar o valor de n2
    mov edx,tam_var  ;|
    int sys_call     ;|

    mov ecx,n1
    call conv_str_to_int
    
    mov eax,sys_exit
    mov edx,ret_exit
    int sys_call

conv_str_to_int:
    xor eax,eax
loop1:
    cmp eax,tam_var
    je fim_conv
    
    inc eax
    jmp loop1
fim_conv:
    ret