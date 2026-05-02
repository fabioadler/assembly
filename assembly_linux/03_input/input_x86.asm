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
	msg1 db "Qual seu nome: ", lf, null
	len1 equ $- msg1
	msg2 db "Seja bem vindo ", null
	len2 equ $- msg2

section .bss
	buffer resb 0x80 ;0x80 = 128
	nome resb 0xF

section .text
	global _start

_start:
	mov eax,sys_write
	mov ebx,std_out
	mov ecx,msg1
	mov edx,len1
	int sys_call
	
	mov eax,sys_read	;Quando o registrador eax está com o valor 0x3 = 3 está no modo de leitura, oposto de quando vamos escrever algo 
	mov ebx,std_in		;Quando o registrador ebx está com o valor 0x1 = 1 está na opção de saida padrão 1 ou seja no nosso terminal/console
	mov ecx,nome 		;Guarda o valor na variavel
	mov edx,0xF	 		;Variavel guarda no maximo 15 = 0xF caracteres que foi o que determinamos mais a cima na criação da variavel
	int sys_call

	mov esi,msg2
	mov edi,buffer
	mov ecx,len2
	cld
	rep movsb
	mov esi,nome
	mov ecx,0xF
	rep movsb

	mov eax,sys_write
	mov ebx,std_out
	mov ecx,buffer
	mov edx,0x80
	int sys_call

	mov eax, sys_exit
	mov ebx, ret_exit
	int sys_call
