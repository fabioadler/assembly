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
	msg1 db "Qual o meu nome:",lf,null
	tam1 equ $- msg1
	msg2 db "Meu nome e ",null
	tam2 equ $- msg2

section .bss
	nome resb 0xA  ;defino o tamanho de memoria, para a variavel nome
	msg3 resb 0x14 ;defino o tamanho de memoria, para a minha string final, que e msg3

section .text

global _start

_start:
	mov eax,sys_write ;|
	mov ebx,std_out   ;|
	mov ecx,msg1      ;| ---> otuput com a pergunta
	mov edx,tam1      ;| 
	int sys_call      ;|

	mov eax,sys_read ;|
	mov ebx,std_in   ;|
	mov ecx,nome     ;| ---> input para pegar o nome e guardar na variavel
	mov edx,0xA      ;|
	int sys_call     ;|

	xor ecx,ecx ;Zera o registrado ecx para usalo como um contado e também como o ponteiro da memoria da nova variavel
loop1:
	cmp byte[msg2+ecx],null ;Compara se no byte atual da memoria com null
	je str2                 ;Se o byte atual for igual a null saltar para o inicio da adição da segunda string no caso o nome
	mov bl,byte[msg2+ecx]   ;Move o byte atual que comparamos para o registrador bl para depois guardar na nova variavel
	mov byte[msg3+ecx],bl   ;Move o valor para o endereço de memoria da nossa nova variavel, na mesma possição da string antiga com o registrad ecx, para que não se sobrescreva nada
	inc ecx                 ;Incrementa o nosso contador ecx
	jmp loop1               ;Faz o jump para o inicio do loop1

str2:
	xor eax,eax ;Zeramos o contado de eax, para usar como um contado da string nome

loop2:
	cmp eax,0xA           ;Como sabemos o tamanho da nossa string nome, e também sabemos que nela não possui null, comparamos o contador dela o eax, com o seu tamanho
	je fim_da_string      ;Caso tenha chegado no tamanho final da variavel nome, saltar para formação do final da string
	mov bl,byte[nome+eax] ;Move o valor do byte atual da variavel nome para o registrador bl
	mov byte[msg3+ecx],bl ;Mov o valor do byte de bl para o endereço da memoria da nova string usando ainda o contador ecx como ponteiro da nova variavel
	inc ecx               ;Incrementa o nosso contador ecx
	inc eax               ;Incrementa o nosso contador eax
	jmp loop2             ;Faz o jump para o inicio do loop
fim_da_string:
	mov byte[msg3+ecx],lf   ;Move para o byte atual da nossa nova string a quebra de linha
	inc ecx                 ;Incrementa nosso contador ecx
	mov byte[msg3+ecx],null ;Move para o byte atual da nossa nova variavel o null para finalizar a string

	mov eax,sys_write ;|
	mov ebx,std_out   ;|
	mov ecx,msg3      ;| ---> output da nova string
	mov edx,0x14      ;|
	int sys_call      ;|

	mov eax,sys_exit ;|
	mov ebx,ret_exit ;| --> exit do codigo
	int sys_call     ;|