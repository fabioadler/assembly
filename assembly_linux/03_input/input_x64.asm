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
	mov rax,sys_write
	mov rbx,std_out
	mov rcx,msg1
	mov rdx,len1
	int sys_call
	
	mov rax,sys_read	;Quando o registrador rax está com o valor 0x3 = 3 está no modo de leitura, oposto de quando vamos escrever algo 
	mov rbx,std_in		;Quando o registrador rbx está com o valor 0x1 = 1 está na opção de saida padrão 1 ou seja no nosso terminal/console
	mov rcx,nome 		;Guarda o valor na variavel
	mov rdx,0xF	 		;Variavel guarda no maximo 15 = 0xF caracteres que foi o que determinamos mais a cima na criação da variavel
	int sys_call

	mov rsi,msg2
	mov rdi,buffer
	mov rcx,len2
	cld
	rep movsb
	mov rsi,nome
	mov rcx,0xF
	rep movsb

	mov rax,sys_write
	mov rbx,std_out
	mov rcx,buffer
	mov rdx,0x80
	int sys_call

	mov rax, sys_exit
	mov rbx, ret_exit
	int sys_call
