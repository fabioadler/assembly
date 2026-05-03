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
    msg1 db "Digite o valor 1: ", null
    len1 equ $- msg1
    msg2 db "Digite o valor 2: ", null
    len2 equ $- msg2
    
section .bss
    buffer resb 0x80
    buffer2 resb 0xC
    valor1 resb 0xA
    valor2 resb 0xA
    resultado resb 0xA
    temp1 resb 0xA
    temp2 resb 0xA

section .text
    global _start

_start:
    mov rax,sys_write
    mov rbx,std_out
    mov rcx,msg1
    mov rdx,len1
    int sys_call

    mov rax,sys_read
    mov rbx,std_in
    mov rcx,valor1
    mov rdx,0xA
    int sys_call

    mov rax,sys_write
    mov rbx,std_out
    mov rcx,msg2
    mov rdx,len2
    int sys_call

    mov rax,sys_read
    mov rbx,std_in
    mov rcx,valor2
    mov rdx,0xA
    int sys_call

    ;Vamos converter o valor1 para inteiro
    mov rsi,valor1
    call str_to_int
    mov [temp1],eax         ;Guarda o valor convertido na variavel

    mov rsi,valor2
    call str_to_int
    mov [temp2],eax

    ;Vamos somar os valores
    mov rax,[temp1]
    add rax,[temp2]
    mov [resultado],eax

    ;Vamos converter de volta para string
    mov rax,[resultado]
    call int_to_str        ;Na said temo em rcx = o resultado, rdx = tamanho da str

    mov rax,0x4
    mov rbx,0x1
    int 0x80

    jmp exit

str_to_int:
    mov rax,0x0
    mov rbx,0xA             ;Determinamos que ecx vai armazenar o valor 10 = 0xA, para multiplicarmos depois

.loop_str_to_int:           ;Também e um ponto de codigo só coloquei um ponto na frente
    movzx rdx,byte [rsi]    ;Pega o próximo caractere
    inc rsi                 ;Incrementa +1 em esi
    cmp dl,0xA              ;Verifica se e uma nova linha
    je .fim
    cmp dl,0x0
    je .fim
    sub dl,'0'              ;Vamos subtrair o caractere "0" de dl
    cmp dl,0                ;Verifica se o valor e menos que 0
    jl .fim                 ;Se for pular para
    cmp dl,9                ;Verificar e o valor e maior que 9
    jg .fim                 ;Se for pular para
    ;Aqui vamos converter o caractere
    imul rax,rbx            ;multiplica o eax por ecx. eax = eax * 10
    add rax,rdx             ;soma eax e edx. eax = eax + dígito
    jmp .loop_str_to_int

.fim:
    ret

int_to_str:
    mov rcx,buffer2 + 0xB   ;começa do fim do buffer
    mov byte [rcx],0x0      ;Adiciona 0x0 como ultimo caracter para encerrar a string
    mov rbx,0xA             ;Guarda o valor de 10 em ebx pra dividir depois

.loop_int_to_str:
    mov rdx,0                   ;Começa no fim do buffer
    div rbx                     ;eax / 10 -> eax = quociente, edx = resto
    add dl,'0'                  ;Converte resto para ASCII
    dec rcx                     ;Decrementa -1 em ecx, anda uma posição de 1 byte para trás no buffer
    mov [rcx],dl            
    test rax,rax                ;testa eax
    jnz .loop_int_to_str        ;Se for diferente 0 = 0x0, volta para o inicio do loop

    mov byte [buffer2+0xB],0xA  ;adiciona no byte 11 o valor que 10, que muda o byte 11 que ante era 0x0 = 0 ou null (fim da string) em 0xA = 10 ou \n (quebra de linha)
    mov byte [buffer2+0xC],0X0  ;adiciona no byte 12 (que e o ultimo do buffer2) o 0x0 = 0 ou fim da string
    ;calcular tamanho do buffer
    mov rdx,buffer2+0xC
    sub rdx,rcx             ;tamanho = final - inicio
    ret

exit:
    mov rax,sys_exit
    mov rbx,ret_exit
    int sys_call