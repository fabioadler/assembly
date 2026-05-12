section .data
	msg1 db "Olá seja bem vindo(a)!",0xA,"Qual o seu nome? ",0x0
	len_msg1 equ $- msg1
	msg2 db "Senhor(a) ",0x0
	msg3 db " está pronto para administrar o sistema!",0x0
	msg4 db "Estámos ao seu comando Sr(a) ",0x0
	msg5 db " aguardando ordens!",0x0

section .bss
	buffer resb 0x80
	nome resb 0x16

section .text
global _inicio

_inicio:
	mov rax,0x4
	mov rbx,0x1
	mov rcx,msg1
	mov rdx,len_msg1
	int 0x80

	mov rax,0x3
	mov rbx,0x0
	mov rcx,nome
	mov rdx,0x16
	int 0x80

	mov rsi,msg2
	mov rdx,buffer
	call _concatena

	mov rsi,nome
	call _concatena

	mov rsi,msg3
	call _concatena

	mov byte [buffer+0x7E],0xA
	mov byte [buffer+0x7F],0x0

	mov rax,0x4
	mov rbx,0x1
	mov rcx,buffer
	mov rdx,0x80
	int 0x80

	mov rdi,buffer	;carrega o buffer/variavel em edi
	mov al,0x0		;carrega em bl o valor a ser escritp no buffer
	mov	rcx,0x80	;carrega em ecx o tamanho do buffer/variavel
	rep stosb		;escreve o valor carregado em bl em todos os espaço/tamanho do buffer/variavel passado em ecx

	mov rsi,msg4
	mov rdx,buffer
	call _concatena

	mov rsi,nome
	call _concatena

	mov rsi,msg5
	call _concatena

	mov byte [buffer+0x7E],0xA
	mov byte [buffer+0x7F],0x0

	mov rax,0x4
	mov rbx,0x1
	mov rcx,buffer
	mov rdx,0x80
	int 0x80

	mov rax,0x1
	mov rbx,0x0
	int 0x80


_concatena:
	mov bl,byte [rsi]
	cmp bl,0x0
	je .fim_com
	cmp bl,0xA
	je .skip_carac
	mov byte [rdx],bl
	inc rsi
	inc rdx
	jmp _concatena

.skip_carac:
	inc rsi
	jmp _concatena

.fim_com:
	ret
