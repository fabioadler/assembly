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
	msg db "Qual seu nome: ", lf, null ;Constante da msg
	tam_msg equ $- msg                 ;Tamanho da constante msg

section .bss  ;Usado para armazenar os valores editaveis (variaveis)
	nome resb 1 ;nome e uma variabel de bytes

section .text

global _start

_start:
	mov eax,sys_write
	mov ebx,std_out
	mov ecx,msg
	mov edx,tam_msg
	int sys_call
	
	mov eax,sys_read
	mov ebx,std_in
	mov ecx,nome ;Guarda o valor na variavel
	mov edx, 0xA ;Variavel guarda no maximo 10 caracteres
	int sys_call

	mov eax, sys_exit
	mov ebx, ret_exit
	int sys_call
