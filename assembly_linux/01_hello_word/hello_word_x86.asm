segment .data         ;aqui vamos criar algo como de fosse um define, ou seja ao inves de precisar digitar 0xA = 10 e represena a quebra de linha, no restante do codigo usaremos lf 
	lf equ 0xA        ;Quebra de linha
	null equ 0x0      ;Final da String
	sys_call equ 0x80 ;Enviar informação ao SO
	sys_exit equ 0x1  ;Chamada para finalizar |
	sys_read equ 0x3  ;Operação de leitura              | --> eax
	sys_write equ 0x4 ;Operação de escrita              |
	ret_exit equ 0x0  ;Operação realizada com sucesso |
	std_out equ 0x1   ;Saida pardrão                  | --> ebx
	std_in equ 0x0    ;Endica uma entrada padrão      |

section .data                           ;Vamos guardar e reservar partes da memoria (Ex: a mensagem hello word), guardaremos esses valores como constantes
    msg1 db "Hello Word", lf, null      ;Dizemos que msg1 vai receber uma str e adicionamos o lf para quebra de linha e o null para incerrar a str
    len1 equ $- msg1                    ;vamos atribuir a len1 $ a posição atual da memoria - msg1, que vai indiciar o inicio da str/tamaho dela

section .text
    global _start   ;Indica que o codigo começa no ponto do codigo chamado _start e o padrão dos compiladores

_start:                 ;E o ponto onde inicia o codigo
    mov eax,sys_write   ;Indicamos em eax que e um dos registradores, o valor de 0x4 = 4 que está representado sys_write, quando eax está com o valor 4, o sistema vai escrever (ter uma saida)
    mov ebx,std_out     ;Semelhantemente o de cima, em ebx vamos atribuir o valor de 0x1 = 1, que siginifica que vamos usar a saida padrão 1 que e o nosso terminal
    mov ecx,msg1        ;Aqui atribuimos a ecx o que queremos mostrar na nossa saida, no caso nossa mensagem hello word
    mov edx,len1        ;Atribuimos a edx o inicio/tamanho da nossa str(mensagem)
    int sys_call        ;Criamos um interrupção no processo que envia os comandos para o SO (sistema operacional), mais especifico no kernel do linux

    mov eax,sys_exit    ;Determinamos que o codigo vai encerrar/terminar
    mov ebx,ret_exit    ;Indica que não ouve erro na execução do codigo
    int sys_call