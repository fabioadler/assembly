section .data
	msg db 'hello world',0xA ; Guarda a mensagem, mais a quebra de linha \n
	tam_msg equ $- msg ;E guardado o tamanho da mensagem 

section .text

global _start

_start:
	mov eax,0x4 ;Informado que vai ter informação -|--> Indica que vai aver saida de dados
	mov ebx,0x1 ;Saida no local padrão            -|
	mov ecx,msg ;ECX recebe a msg
	mov edx,tam_msg ;EDX recebe o tamanho de msg
	int 0x80 ;Diz para o sistema executar
	mov eax,0x1 ;Termina o programa
	mov ebx,0x0 ;Retorna o valor 0
	int 0x80
