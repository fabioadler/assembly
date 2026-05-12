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
	mov eax,0x4
	mov ebx,0x1
	mov ecx,msg1
	mov edx,len_msg1
	int 0x80

	mov eax,0x3
	mov ebx,0x0
	mov ecx,nome
	mov edx,0x16
	int 0x80

	mov esi,msg2
	mov edx,buffer
	call _concatena

	mov esi,nome
	call _concatena

	mov esi,msg3
	call _concatena

	mov byte [buffer+0x7E],0xA
	mov byte [buffer+0x7F],0x0

	mov eax,0x4
	mov ebx,0x1
	mov ecx,buffer
	mov edx,0x80
	int 0x80

	mov edi,buffer	;carrega o buffer/variavel em edi
	mov al,0x0		;carrega em bl o valor a ser escritp no buffer
	mov	ecx,0x80	;carrega em ecx o tamanho do buffer/variavel
	rep stosb		;escreve o valor carregado em bl em todos os espaço/tamanho do buffer/variavel passado em ecx

	mov esi,msg4
	mov edx,buffer
	call _concatena

	mov esi,nome
	call _concatena

	mov esi,msg5
	call _concatena

	mov byte [buffer+0x7E],0xA
	mov byte [buffer+0x7F],0x0

	mov eax,0x4
	mov ebx,0x1
	mov ecx,buffer
	mov edx,0x80
	int 0x80

	mov eax,0x1
	mov ebx,0x0
	int 0x80


_concatena:
	mov bl,byte [esi]
	cmp bl,0x0
	je .fim_com
	cmp bl,0xA
	je .skip_carac
	mov byte [edx],bl
	inc esi
	inc edx
	jmp _concatena

.skip_carac:
	inc esi
	jmp _concatena

.fim_com:
	ret
