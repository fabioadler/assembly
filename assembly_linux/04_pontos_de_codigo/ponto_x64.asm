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
    msg1 db "Hellow word", lf, null
    len1 equ $- msg1
    msg2 db "How are you all", lf, null
    len2 equ $- msg2

section .text
    global _start

_start:     			;Esse já e um ponto de codigo
						;Podemos ir a um ponto de varias formas diferentes, veremos outras na parte de compração	
	mov rcx,msg1		;Vamos passar os parametros ecx e edx normalmente como se fossemos escrever na tela
	mov rdx,len1	
	call print			;O comando call funciona parecido com o jmp (salto incondicional), só que o call chama um ponto no codigo e assim que usamos ret ele retorna para onde foi a ultima chamda call

	mov rcx,msg2
	mov rdx,len2
	call print			;Agora como vocês podem ver evitamos ficar repetindo codigo

	jmp exit			;A função jump simplesmente vai pular para outro ponto do codigo, no caso o ponto exit para encerrarmos esse programa


print: 		;Criamos um ponto que vai agir como uma função print
	mov rax,sys_write	;prexemos eax e ebx, da mesma forma como se fossemos escrever na console
	mov rbx,std_out
	int sys_call		
	ret					;retorna para onde chamamos o call

exit:
	mov rax,sys_exit
	mov rbx,ret_exit
	int sys_call