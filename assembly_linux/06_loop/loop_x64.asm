section .data
    msg1 db "Começando...",0xA,0x0
    len1 equ $- msg1

section .bss
    num resb 0x3

section .text
    global _start

_start:
    mov rcx,msg1
    mov rdx,len1
    call .print

    ;Vamos fazer um loop semelhante ao for de 0 in 9
    mov rsi,0x0
    mov rdi,0x9
    call .loop

    mov rax,0x1
    mov rbx,0x0
    int 0x80

.loop:
    mov rax,rsi                 ;carreganos o valor de esi em eax, para não alterarmos o valor de esi 
    add rax,'0'                 ;Adicionamos um '0' dessa forma, para convertermos para str
    mov [num],rax               ;Carregamos o conteudo de eax no endereço de memoria que reservamos para num
    mov byte [num+1],0xA        ;Adicionamos mais um caracter 1 byte a frente 0xA = 10, que siginifica uma quebra de linha ou \n
    mov byte [num+2],0x0        ;Adicionamos um caracter na frente do ultimo que adicionamos acima, ou seja pegamo o endereo atual e colocamos +2 que são 2 bytes a frente, adicionamos um 0x0 = 0 que siginifica que a string acabou

    mov rcx,num                 ;Carregamos a mensagem para ser escrita
    mov rdx,0x3                 ;Colocamos o tamanho de 0x3 = 3 bytes, por que e o numero e os outros 2 caracteres que Adicionamos
    call .print                 ;Chamamos a nossa função de print

    cmp rsi,rdi                 ;Confere se o valor de esi atual e igual ao de edi que passamos antés call para chamar a funão
    je .fim_loop                ;Se a confição for verdadeira pular para o .fim_loop
    inc rsi                     ;Incrementa esi com +1
    jmp .loop                   ;Volta para o loop novamente

.fim_loop:
    ret
    
.print:
    mov rax,0x4
    mov rbx,0x1
    int 0x80
    ret