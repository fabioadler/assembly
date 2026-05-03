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
    buffer2 resb 0xB
    valor1 resb 0xA
    valor2 resb 0xA
    resultado resb 0xA
    temp1 resb 0xA
    temp2 resb 0xA

section .text
    global _start

_start:
    mov eax,sys_write
    mov ebx,std_out
    mov ecx,msg1
    mov edx,len1
    int sys_call

    mov eax,sys_read
    mov ebx,std_in
    mov ecx,valor1
    mov edx,0xA
    int sys_call

    mov eax,sys_write
    mov ebx,std_out
    mov ecx,msg2
    mov edx,len2
    int sys_call

    mov eax,sys_read
    mov ebx,std_in
    mov ecx,valor2
    mov edx,0xA
    int sys_call

    ;Vamos converter o valor1 para inteiro
    mov esi,valor1
    call str_to_int
    mov [temp1],eax         ;Guarda o valor convertido na variavel

    mov esi,valor2
    call str_to_int
    mov [temp2],eax

    ;Vamos somar os valores
    mov eax,[temp1]
    add eax,[temp2]
    mov [resultado],eax

    ;Vamos converter de volta para string
    mov esi,resultado
    call int_to_str         ;Resultado está em buffer e o tamanho dele e o tamanho reservado

    mov eax,0x4
    mov ebx,0x1
    mov ecx,buffer
    mov edx,0x80
    int 0x80

    jmp exit

str_to_int:
    mov eax,0x0
    mov ecx,0xA             ;Determinamos que ecx vai armazenar o valor 10 = 0xA, para multiplicarmos depois

.loop_str_to_int:           ;Também e um ponto de codigo só coloquei um ponto na frente
    movzx edx,byte [esi]    ;Pega o próximo caractere
    inc esi                 ;Incrementa +1 em esi
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
    imul eax,ecx            ;multiplica o eax por ecx. eax = eax * 10
    add eax,edx             ;soma eax e edx. eax = eax + dígito
    jmp .loop_str_to_int

.fim:
    ret

int_to_str:
    mov ecx, buffer2 + 0xB

exit:
    mov eax,sys_exit
    mov ebx,ret_exit
    int sys_call