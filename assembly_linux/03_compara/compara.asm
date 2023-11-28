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
    x dd 50 
    y dd 10
    ; db 1 byte
    ; dw difine word 1 char 2 bytes
    ; dd difine double word 4 bytes 
    ; dq difine quadre word 8 bytes
    ; dt difine ten word 10 bytes
    msg1 db "x maior que y", lf, null
    tam_msg1 equ $- msg1
    msg2 db "y maior que x", lf, null
    tam_msg2 equ $- msg2

section .text

global _start

_start:
    mov eax,dword[x] ;| --> valores das constantes do section .data para os registradores se usa dword[]
    mov ebx,dword[y] ;|
    cmp eax,ebx ;| Semelhante a o if, compara os valores dos registradores
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
