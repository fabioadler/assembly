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
    msg1 db "hellow word ", null        ;não vamos por o lf na primeira, por que assim que juntamos as str, queremos que elas fiquem na mesma linha
    len1 equ $- msg1
    msg2 db "my name is F", lf, null
    len2 equ $- msg2

section .bss            ;aqui vamos criar variaves
    buffer resb 128     ;criamos uma variavel chamada buffer com o tamanho de 128 bits (cabe 128 caracteres)

section .text
    global _start

_start:
    ;vamos começar copiando msg1
    mov rsi,msg1    ;carregamos a str (msg1) em esi
    mov rdi,buffer  ;aponta o destino da str
    mov rcx,len1    ;carregamos o tamanho da str
    cld             ;serve para limpar (definir como 0) a Direction Flag (DF) no registrador de flags. Com a CLD, os registradores de índice ESI (Source Index) e EDI (Destination Index) são incrementados automaticamente após cada operação de string.  É usada para garantir que o processamento ocorra de forma "normal" ou "para frente", pois o valor padrão da flag após inicialização costuma ser zero, mas é boa prática ativá-la antes de manipulações de memória que exigem essa ordem.
    rep movsb       ; Move bytes de ESI para EDI. A instrução REP MOVSB (Repeat Move String Byte) é um comando da linguagem assembly x86 usado para copiar blocos de memória com alta eficiência. Ela move dados byte a byte de um local de origem para um local de destino, repetindo a operação até que o contador atinja zero.

    ;vamos copiar msg2 agora
    mov rsi,msg2
    mov rcx,len2
    rep movsb

    ;vamos printar as strings juntas
    mov rax,sys_write
    mov rbx,std_out
    mov rcx,buffer      ;Vamos escrever na tela o valor que estar no nosso buffer que e a junção das 2 str
    mov rdx,128         ;Aqui vamos passar o tamanho que definimos anteriormente para o buffer
    int sys_call

    mov rax,sys_exit
    mov rbx,ret_exit
    int sys_call