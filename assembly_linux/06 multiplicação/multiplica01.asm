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
    msg1 db "Multiplicando com MUL", lf, null
    len1 equ $- msg1
    msg2 db "Digite o valor1: ", lf, null
    len2 equ $- msg2
    msg3 db "Digite o valor2: ", lf, null
    len3 equ $- msg3

section .bss
    buffer_conv resb 0xC
    tam_var equ 0xA
    valor1 resb tam_var
    valor2 resb tam_var


section .text
    global _start

_start:
    mov eax,sys_write
    mov ebx,std_out
    mov ecx,msg1
    mov edx,len1
    int sys_call

    ;input valor 1
    mov eax,sys_write
    mov ebx,std_out
    mov ecx,msg2
    mov edx,len2
    int sys_call

    mov eax,sys_read
    mov ebx,std_in
    mov ecx,valor1
    mov edx,tam_var
    int sys_call

    ;input valor 2
    mov eax,sys_write
    mov ebx,std_out
    mov ecx,msg3
    mov edx,len3
    int sys_call

    mov eax,sys_read
    mov ebx,std_in
    mov ecx,valor2
    mov edx,tam_var
    int sys_call

    ;multiplicando MUL
    mov eax,valor1 ;carrega o valor 1 em eax
    mov ebx,valor2 ;carrega o valor 2 em ebx
    mul ebx        ;realizada a multiplicação
    mov edi,eax   ;salva o resultado em edi



    mov eax,sys_exit
    mov ebx,ret_exit
    int sys_call

_convert_int_str:
    ; --- salva registradores que serão modificados ---
    push ebx                ;salva ebx (será usado como divisor)
    push ecx                ;salva ecx (será usado como contador)
    push edx                ;salva edx (será usado na divisão)
    push esi                ;salva esi (será usado como ponteiro fonte)
    mov esi,edi             ;esi guarda o endereço inicial do buffer
                            ;será usado depois para mover a string
    ; --- Coloca o terminador null no final do buffer ---
    mov byte [esi+11],0     ;escreve 0 na posição 11 (último byte)
                            ;byte indica operação de 1 byte
                            ;[esi+11] acessa memória no endereço ESI+11
    ; --- Posiciona o ponteiro no penúltimo byte do buffer ---
    add edi, 10             ;edi aponta para posição 10 (11º byte, índice 10)
                            ;deixa espaço para o último dígito
    ; --- Define o divisor como 10 (base decimal) ---
    mov ebx, 10             ;ebx = 10, usado para divisões sucessivas
    
.converte_digito:
    ; --- Prepara para divisão: limpa EDX (parte alta do dividendo) ---
    xor edx, edx            ;zera edx. xor é mais rápido que MOV EDX,0
                            ;div usa edx:eax como dividendo de 64 bits
    ; --- Divide o número por 10 ---
    div ebx                 ;divisão: edx:eax/ebx
                            ;quociente vai para eax
                            ;resto (0-9) vai para edx
                            ;ex: 123 / 10 -> eax=12,edx=3
    ; --- Converte o resto (dígito) para caractere ASCII ---
    add dl, '0'             ;soma 48 (código ASCII de '0') ao resto
                            ;ex: 3 + 48 = 51 (código ASCII de '3')
                            ;dl é o byte menos significativo de edx
    ; --- Armazena o caractere no buffer ---
    mov [edi], dl           ;escreve o caractere na posição atual
                            ;escrita de 1 byte (DL) na memória
    ; --- Move o ponteiro para a esquerda (próxima posição) ---
    dec edi                 ;decrementa EDI (move para byte anterior)
                            ;preenche o buffer da direita para esquerda
    ; --- Verifica se ainda há dígitos para processar ---
    test eax, eax           ;testa se EAX é zero (AND lógico sem guardar)
                            ;teste afeta as flags ZF (Zero Flag)
    jnz .converte_digito    ;jump if Not Zero: se eax != 0, continua loop
                            ;quando eax chega a 0, todos dígitos foram processados  
    ; --- Ajusta o ponteiro para o início da string ---
    inc edi                 ;incrementa edi: agora aponta para o primeiro dígito
                            ;compensa o último decremento do loop  
    ; --- Calcula o comprimento da string ---
    mov ecx,esi             ;ecx = endereço inicial do buffer
    add ecx,11              ;ecx = endereço final do buffer (esi+11)
    sub ecx,edi             ;ecx = posição_final - posição_início
                            ;isso dá o número de bytes a copiar   
    ; --- Salva o ponteiro de início da string ---
    push edi                ;guarda edi(início da string) na pilha
                            ;será restaurado no final como retorno   
.copia_string:
    ; --- Copia um byte da posição original para o início ---
    mov al, [edi]           ;carrega byte da posição edi em al
                            ;al é o byte menos significativo de eax
    mov [esi], al           ;escreve esse byte na posição esi
                            ;move o caractere para o início do buffer
    ; --- Avança ambos os ponteiros ---
    inc esi                 ;próxima posição de destino
    inc edi                 ;próxima posição de origem
    ; --- Decrementa contador e verifica se terminou ---
    dec ecx                 ;decrementa contador de bytes
    jnz .copia_string       ;se ecx != 0, continua copiando
    ; --- Adiciona terminador null no final da string copiada ---
    mov byte [esi], 0       ;escreve 0 (null terminator) após último caractere
                            ;essencial para funções de string em C
    ; --- Restaura o ponteiro de início da string ---
    pop edi                 ;recupera edi da pilha
                            ;edi agora aponta para início da string no buffer
    ; --- Restaura registradores originais ---
    pop esi                 ;restaura esi (ordem inversa dos push)
    pop edx                 ;restaura edx
    pop ecx                 ;restaura ecx
    pop ebx                 ;restaura EBX
    ret                     ;retorna para quem chamou
                            ;pop epi (endereço de retorno da pilha)

_convert_str_int:
    ;Entrada [esp+4] = ponteiro para string
    push ebp        ;Salva a posição do ponteiro anterior
    mov ebp, esp    ;ebp aponta para a frame atual
    ; --- salva os registradores a serem usados ---
    push ebx        ;ebx armazena os caracteres/digitos
    push ecx        ;ecx multiplicador constante (10)
    push edx        ;não usa diretamente, mas preservador
    push esi        ;ponteiro para percorrer a string
    mov esi,ebp+8   ;carrega o argumento da pilha
                    ;ebp+4 = endereço de retorno
                    ;ebp+8 = primeiro argumento (ponteiro string)
    ; --- Iniciando os acumuladores de constants ---
    xor eax,eax     ;eax = 0 (resultado final)
                    ;xor é mais eficiente que mov eax,0
    xor ebx,ebx     ;ebx = 0 (será usado para cada dígito)
    mov ecx,0xA     ;ecx = 10 (base decimal, multiplicador constante)

.proximo_char:
    ;carrega o caracter atual da string
    mov bl, esi         ;lê 1 byte da posição apontada esi
                        ;bl = byte menos significativo de ebx
    ;verifica se é o fim da string (null)
    test bl,bl          ;testa se bl é zero (and lógico)
                        ;se bl=0 zf (zero flag) = 1
    jz .fim_conversao   ;Jump if zero: se encontrou null, termina
    cmp bl,'0'          ;Compara bl com 48 (codigo ASCII de '0')
    jb .nao_e_digito    ;Jump if below: se bl < '0', não e dígito
                        ;jb salta se CF=1
    cmp bl,'9'          ;compara bl com 57 (código ASCII de '9')
    ja .nao_e_digito    ;jump if Above: se BL > '9', não é dígito
                        ;ja salta se CF=0 e ZF=0
    sub bl,'0'          ;subtrai 48 para obter o valor real
    mul ecx             ;multiplica eax por ebx (10)
                        ;resultado: eax = eax * 10
    jc .overflow        ;jump if Carry: se CF=1, houve overflow
                        ;mul seta CF se EDX != 0 (resultado > 32 bits)
    add eax,ebx         ;soma eax e ebx
    jc .overflow        ;jump if Carry: se houve carry na adição
    inc esi             ;incrementa o ponteiro da string (move para o proximo caractere)
    jmp .proximo_char   ;volta para o processamento de caracteres

.nao_e_digito:
    jmp .fim_conversao  ;simplesmente termina a conversão

.overflow:
    ; --- Em caso de overflow, retorna valor máximo ---
    mov eax, 0xFFFFFFFF     ; define eax como 4294967295
                            ; maior valor possível em 32 bits sem sinal
                            ; indica que houve erro de overflow

.fim_conversao:
    ; --- Restaura registradores na ordem inversa ---
    pop esi         ;restaura ESI original
    pop edx         ;restaura EDX
    pop ecx         ;restaura ECX
    pop ebx         ;restaura EBX
    pop ebp         ;restaura EBP original
    ret             ;retorna ao chamador
                    ;eax contém o número convertido