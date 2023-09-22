;Aluno: João Carlos Batista        					Cartão: 00343016

	.model small
	.stack 100h

	.data									;Área de dados
		
		LF equ 0Ah
		CR equ 0Dh
		handle_saida dw 0
		letra_inicial dw 0
		linhas_contadas dw 0
		copia_n dw 0
		sw_m dw 0
		sw_f db 0
		sw_n dw 0
		str_limpa db 10 dup(0)
		str_escrita db 10 dup(0)
		str_aux	db 10 dup(0)				;String auxiliar
		str_bases db 10 dup(0)
		str_grupos db 10 dup(0)
		str_linhas db 10 dup(0)
		funcao_atual db 0 					;Diz qual a função atualmente sendo processada
		letra_errada db 3 dup(0)			;Letra errada do arquivo de entrada
		funcao_wrong db 3 dup(0)			;Coloca a funcao errada digitada em funcao_wrong
		saida_informada db 0				;Flag artificial para saber se a saida foi informada ou não
		tamanho_entrada dw 0				;Tamanho da string do arquivo de entrada
		tamanho_saida dw 0					;Tamanho da string do arquivo de saida
		n_array db 10 dup(0)				;Vetor para digitos de n
		tamanho_n dw 0						;Recebe o tamanho da string que contem n
		n dw 0								;Valor final de n
		saida db 100 dup(0)					;Vetor para guardar o nome do arquivo de saida
		entrada db 100 dup(0)				;Vetor para guardar o nome do arquivo de entrada
		mem_aux dw 0						;Variável para guardar endereços auxiliar
		saida_padrao db "a.out", 0			;Saída padrão caso a função -o não seja chamada
		error db "ERRO ENCONTRADO!",LF,0	;String de erro
		teste db "chega aqui",LF,0			;Variavel para teste (Não é usada no código)
		buffer db 151						;Número de bytes do buffer
		input db 151 dup(0)					;Aloca o vetor de bytes para a string de entrada
		f_chamado db 0 						;Diz se F foi chamado ou não
		o_chamado db 0 						;Diz se O foi chamado ou não
		n_chamado db 0 						;Diz se N foi chamado ou não
		atcg_chamado db 0 					;Diz se ACTG+ foi chamado ou não
		FLAG_A db 0							;Diz se A estava no parametro de atcg+
		FLAG_C db 0							;Diz se C estava no parametro de atcg+
		FLAG_T db 0							;Diz se T estava no parametro de atcg+
		FLAG_G db 0							;Diz se G estava no parametro de atcg+
		FLAG_PLUS db 0						;Diz se + estava no parametro de atcg+

		;PARTE PARA AS STRINGS DE ERRO 

		arquivo_inexistente db "O arquivo informado nao existe", LF, 0
		arquivo_inexistente_2 db "O nome do arquivo eh: ", 0
		quantidade_minima db "Quantidade minima de letras do arquivo nao atendida.",LF,0
		quantidade_minima_2 db "A quantidade minima eh de: ", 0
		informacoes_insuficientes db "Nao foram informadas funcoes suficientes para o programa.",LF,0
		info_f db "-- Funcao F (file) faltante",LF,0
		info_n db "-- Funcao N (number) faltante",LF,0
		info_actg db "-- Funcao ACTG+ (bases nitrogenadas) faltante",LF,0
		funcao_inexistente db "A funcao digitada nao existe.",LF,0
		funcao_inexistente_2 db "A funcao que o usuario tentou digitar foi: -",0
		parametro_invalido db "Parametro invalido informado.",LF,0
		parametro_invalido_2 db "O parametro invalido estava na funcao: ",0
		parametro_f db "f (file)",LF, 0
		parametro_o db "o (output)",LF, 0
		parametro_n db "n (numero)",LF,0
		parametro_actg db "actg+ (bases nitrogenadas)",LF,0
		quebra_de_linha db LF,0
		parametro_invalido_3 db "O parametro invalido era: ",0
		quantidade_maxima db "O arquivo possui mais de 10.000 bases nitrogenadas.",LF,0
		letra_invalida db "Letra invalida no arquivo.",LF,0
		letra_invalida_2 db "A letra encontrada foi: ", 0
		letra_invalida_3 db "A letra foi encontrada na linha: ",0

		;ÁREA DE VARIÁVEIS PARA LIDAR COM ABERTURA E INSERÇÃO DE ARQUIVOS

		quantidade_a dw 0 					;Variável que contém a quantidade de A's em um cluster de tamanho n
		quantidade_c dw 0 					;Variável que contém a quantidade de C's em um cluster de tamanho n
		quantidade_t dw 0 					;Variável que contém a quantidade de T's em um cluster de tamanho n
		quantidade_g dw 0					;Variável que contém a quantidade de G's em um cluster de tamanho n
		quantidade_at dw 0 					;Variável que contém a quantidade de AT's em um cluster de tamanho n
		quantidade_cg dw 0 					;Variável que contém a quantidade de CG's em um cluster de tamanho n

		linhas dw 1 						;Variável que contém a quantidade de linhas no arquivo
		linha_sem_base dw 0 				;Variável que contém a quantidade de linhas sem base no arquivo
		linhas_com_base dw 0 				;Variável que contém a quantidade de linhas com base no arquivo
		total_bases dw 0 					;Variável que contém o número total de bases
		quantidade_grupos dw 0 				;Variável que contém a quantidade de clusters processados

		copia_arquivo db 20000 dup(0)

		;ÁREA DAS STRINGS DO RESUMO NA TELA

		informacoes_opcoes db "--------------------------INFORMACOES DE OPCOES--------------------------",LF,LF,0
		nome_arquivo_resumo db "Nome do arquivo de entrada: ",0
		nome_arquivo_saida_resumo db "Noma do arquivo de saida: ",0
		tamanho_bases_resumo db "Tamanho dos grupos de bases nitrogenadas: ", 0
		informacoes_arquivo_saida_resumo db "Informacoes colocadas no arquivo de saida: ",0

		informacoes_arquivo db "-------------------------INFORMACOES DE ARQUIVO-------------------------",LF,LF,0
		numero_bases_resumo db "Numero de bases no arquivo de entrada: ",0
		numero_grupos_resumo db "Numero de grupos de bases processados: ",0
		numero_linhas_com_base_resumo db "Numero de linhas que contem base: ",0
		ponto_e_virgula db ";",0
		base_a db "A",0
		base_t db "T",0
		base_c db "C",0 
		base_g db "G",0 
		base_atcg db "A+T;C+G",0 
		ja_chamado db 0
		ja_chamado_2 db 0

	.code


	.startup							;MAIN

		;mov ax, @data
		;mov ds, ax

	input_usuario:						;Pega a string digitada na linha de comando

		push ds 						;Salva as informações de segmentos
		push es
		mov ax,ds 						;Troca DS <-> ES, para poder usa o MOVSB
		mov bx,es
		mov ds,bx
		mov es,ax
		mov si,80h 						;Obtém o tamanho do string e coloca em CX
		mov ch,0
		mov cl,[si]
		mov si,81h 						;Inicializa o ponteiro de origem
		lea di,input 					;Inicializa o ponteiro de destino
		rep movsb
		pop es 							;Retorna as informações dos registradores de segmentos 
		pop ds

		lea bx, quebra_de_linha			;Da uma quebra de linha no inicio do programa
		call funcao_print				;Chama a funcao de printar na tela
		lea bx, input					;Coloca o endereço de inicio do buffer da string em bx

		
	checa_funcao:

		inc bx
		mov al, [bx]					;Move bx indireto para al
		cmp al, 0						;Testa se o byte é "\0"
		je continuacao_programa			;Se for, continua o programa (sai da área de checagem de funções)
		cmp al, 2Dh						;Testa se o primeiro caractere de input é 2Dh, ou seja, "-"
		je continuacao_checa_funcao		;Se a string não começar com "-", vai para caso_erro
		mov al, 3						;Chama o erro numero 4 (parametros invalidos)
		call funcao_erro				;Chama a funcao de erro

	continuacao_checa_funcao:

		inc bx							;Incrementa o buffer para ler o próximo caractere do string
		mov al, [bx]					;Move bx indireto para ax
		cmp al, 66h						;Verifica se o caractere é "f"
		jne checa_funcao_2				;Se não for igual, continua
		call funcao_f					;Senão, chama a subrotina "funcao_f"
		mov f_chamado, 1				;Liga o Flag artificial da funcao f
		jmp checa_funcao				;Repete
	
	checa_funcao_2:

		cmp al, 6Fh						;Verifica se o caractere é "o"
		jne checa_funcao_3				;Se não for igual, continua
		call funcao_o					;Senão, chama a subrotina "funcao_o"
		mov o_chamado, 1				;Liga o flag da funcao output
		jmp checa_funcao				;Repete

	checa_funcao_3:
		
		cmp al, 6Eh						;Verifica se o caractere é "n"
		jne checa_funcao_4				;Se não for igual, continua
		call funcao_n					;Senão, chama a subrotina "funcao_n"
		mov n_chamado, 1				;Liga o flag da funcao n
		jmp checa_funcao				;Repete

		
	checa_funcao_4:
		
		cmp al, 97						;Verifica se é A
		je actg							;Se for, chama actg
		cmp al, 99						;Verifica se é C
		je actg							;Se for, chama actg
		cmp al, 116						;Verifica se é T
		je actg							;Se for, chama actg
		cmp al, 103						;Verifica se é G
		je actg							;Se for, chama actg
		cmp al, 43						;Verifica se é +
		je actg							;Se for, chama actg
		
		mov al, 3 						;Move 4 para AL (Funcao de funcao invalida)
		call funcao_erro				;Chama a funcao de erro


	actg:
		call funcao_actg				;Vai para a função actg
		mov atcg_chamado, 1				;Liga o flag da funcao atcg+
		jmp checa_funcao				;Repete

continuacao_programa:					;Verifica se todas as funcoes necessárias foram chamadas
	cmp f_chamado, 1					;Verifica se a funcao F foi chamada
	je continuacao_programa_2			;Se sim, continua
	mov al, 2							;Se nao, retorna o código de erro 2 (funcoes obrigatórias não chamadas)
	call funcao_erro
continuacao_programa_2:
	cmp n_chamado, 1					;Verifica se a funcao N foi chamada
	je continuacao_programa_3			;Se sim, continua
	mov al, 2							;Se nao, retorna o código de erro 2 (funcoes obrigatórias não chamadas)
	call funcao_erro
continuacao_programa_3:
	cmp atcg_chamado, 1					;Verifica se a funcao ATCG+ foi chamada
	je continuacao_programa_4			;Se sim, continua
	mov al, 2							;Se nao, retorna o código de erro 2 (funcoes obrigatórias não chamadas)
	call funcao_erro

continuacao_programa_4:
	cmp saida_informada, 1				;Se a funcao -o foi chamada, vai direto para a abertura de arquivos
	je abertura_arquivo					;Senão, coloca a.out como nome de arquivo de saida
	mov tamanho_saida, 5				;Coloca 5 em tamanho_saida (tamanho de a.out)
	mov cx, 5							;Coloca 5 no cx (tamanho de a.out)
	lea si, saida_padrao				;Coloca saida padrao no source
	lea di, saida						;Coloca saida no destino
	push es								;Salva es na pilha
	mov ax, ds							;Move ds para ax
	mov es, ax							;Move ax para es
	CLD									;Limpa os flags de direção
	REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
	pop es								;Retira es da pilha
	jmp abertura_arquivo				;Vai para a área de arquivos


;ÁREA DESTINADA AS OPERAÇÕES COM ARQUIVOS


abertura_arquivo:
	mov ah, 3Dh							;Modo de abertura de arquivos
	mov al, 0							;Modo de leitura (read only)
	lea dx, entrada						;Endereço de inicio da string de entrada
	int 21h								;Chama a 21h
	jnc leitura_arquivo					;Se nao ligou a flag de carry, continua
	mov al, 0							;Senão, retorna erro de arquivo de entrada inexistente
	call funcao_erro

leitura_arquivo:						;Parte de leitura de arquivos (operação sobre o handle em AX)
	mov bx, ax							;Bx recebe o handle do arquivo, que está em ax
	mov ah, 3Fh							;Função de leitura do arquivo
	mov cx, 20000						;Cx recebe o numero de bytes a serem copiados
	lea dx, copia_arquivo				;Dx recebe o endereço inicial do buffer que irá receber a copia do arquivo
	int 21h								;Chama a int 21h
	jnc fechamento_arquivo				;Se deu certo (se não há flag de carry) continua para o fechamento
	mov al, 0							;Senão, retorna o erro de arquivo
	call funcao_erro

fechamento_arquivo:
	mov ah, 3Eh 						;Função de fechamento de arquivo
	int 21h 							;Chama a 21h
	jnc operacoes_entrada				;Se deu tudo certo, continua
	mov al, 0							;Senão, retorna erro de arquivo
	call funcao_erro

operacoes_entrada:
	lea bx, copia_arquivo				;Coloca o endereço do vetor copiado do arquivo em bx
	mov al, [bx]
	cmp al, LF
	jne teste_inicio
	inc linha_sem_base
	jmp loop_entrada

teste_inicio:
	cmp al, CR
	jne loop_entrada
	inc linha_sem_base

loop_entrada:							;Loop para todas as verificações do arquivo
	mov al, [bx]						;Coloca bx indireto em al
	cmp al, 0							;Verifica se al é \0
	je final_do_loop					;Se sim, vai para o final do loop (final do arquivo), se não, continua
	cmp al, "A"							;Verifica se é A
	jne loop_t 							;Se não for, continua para o loop de verificação de T
	inc total_bases						;Se for, incrementa o total de bases
	inc bx								;Incrementa bx (ponteiro do arquivo)
	jmp loop_entrada					;Repete
loop_t:									;Parte do loop que verifica o caractere T
	cmp al, "T"							;Verifica se é T
	jne loop_g							;Se não for, continua para o loop de verificação de G
	inc total_bases						;Se for, incrementa o total de bases
	inc bx								;Incrementa bx (ponteiro do arquivo)
	jmp loop_entrada					;Repete
loop_g:									;Parte do loop que verifica o caractere G
	cmp al, "G"							;Verifica se é G
	jne loop_c							;Se não for, continua para o loop de verificação de C
	inc total_bases						;Se for, incrementa o total de bases
	inc bx								;Incrementa bx (ponteiro do arquivo)
	jmp loop_entrada					;Repete
loop_c:									;Parte do loop que verifica o caractere C
	cmp al, "C"							;Verifica se é C
	jne loop_LF							;Se não for, continua para o loop de verificação de line feed (LF)
	inc total_bases						;Se for, incrementa o total de bases
	inc bx								;Incrementa bx (ponteiro do arquivo)
	jmp loop_entrada					;Repete
loop_LF:								;Parte do loop que verifica o caractere line feed (LF)
	cmp al, LF 							;Verifica se é line feed (LF)
	jne loop_CR							;Se não for, continua para o loop de verificação de carriage return (CR)
	inc linhas							;Se for, incrementa o total de linhas
	dec bx								;Decrementa bx para verificar o ascii anterior
	mov al, [bx]						;Move bx indireto para al
	cmp al, LF 							;Verifica se é line feed (LF)
	jne loop_continua					;Se não for, continua para a verificação do anterior
	inc linha_sem_base					;Se for, incrementa a variável que linha sem bases
	jmp loop_continua_2					;Pula para o final dessa verificação
loop_continua:							;Área caso o valor anterior não seja line feed (LF)
	cmp al, CR 							;Se não for line feed (LF), verifica carriage return (CR)
	jne loop_continua_2					;Se não for igual, apenas continua normalmente
	inc linha_sem_base					;Senão, incrementa a variável de linhas sem base
loop_continua_2:						;Laço final de verificação de line feed (LF) e carriage return (CR)
	inc bx								;Em ambos os casos, incrementa duas vezes o bx, uma para voltar para o...
	inc bx								;Caractere original, e outra para passar o caractere
	jmp loop_entrada					;Repete
loop_CR:								;Parte do loop que verifica o caractere carriage return (CR)
	cmp al, CR							;Verifica se é carriage return (CR)
	jne loop_nenhum						;Se não for, vai para a parte do loop que retorna erro
	inc linhas							;Se for, incrementa a variável de quantidade de linhas
	dec bx								;Decrementa o bx para verificar o valor anterior ao da quebra de linha
	mov al, [bx]						;Move bx indireto para al
	cmp al, LF 							;Verifica se é line feed (LF)
	jne loop_continua					;Se não for, vai para o mesmo loop do caso line feed (LF) anterior
	inc linha_sem_base					;Se for, incrementa a variável de linhas que não possuem base
	jmp loop_continua_2					;Pula para a área de retorno (compartilhada com o line feed (LF))
	inc bx								;Parte desnecessária de código
	jmp loop_entrada					;Também desnecessário
loop_nenhum:							;Parte do loop que retorna erro de caractere inválido encontrado
	mov al, 6							;Manda o código do erro para al (6)
	call funcao_erro					;Chama a função de erro

final_do_loop:							;Depois de pegar todas as informações do arquivo, faz algumas verificações extras

	dec bx
	mov al, [bx]
	cmp al, CR
	jne outro_teste
	inc linha_sem_base
outro_teste:
	cmp al, LF
	jne continuar
	inc linha_sem_base
continuar:
	mov cx, total_bases					;Move o total de bases para cx
	cmp cx, 10000						;Compara cx com 10.000
	jle continua_final_loop				;Se for o total de bases for menor ou igual a 10.000, continua
	mov al, 5							;Senão, retorna o erro de arquivo muito grande (código de erro 5)
	call funcao_erro					;Chama a função de erro

continua_final_loop:					;Depois de pegar todas as informações do arquivo, faz algumas verificações extras
	mov cx, n 							;Manda o valor n (digitado pelo usuário) para cx
	cmp cx, total_bases					;Compara cx (n) com o número de bases nitrogenadas encontradas no arquivo
	jl continuacao						;Se o total de bases for maior do que n, continua
	mov al, 1							;Se não, retorna o erro de arquivo muito pequeno (código de erro 1)
	call funcao_erro					;Chama a função de erro

continuacao:							;Continuação para fazer umas miscelâneas

	mov cx, linhas						;Manda as linhas sem base para cx
	sub cx, linha_sem_base				;Subtrai cx do total de linhas
	mov linhas_com_base, cx				;move cx para linhas_com_base

	mov cx, total_bases					;Move o número total de bases para cx
	sub cx, n							;Subtrai n de cx
	inc cx 								;Incrementa cx
	mov quantidade_grupos, cx			;Salva em numero_grupos_resumo (isso dá o número de grupos que devem ser processados)




;PARTE DE ESCRITA EM ARQUIVO FICA AQUI-----------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

escrita_no_arquivo:						;área de abertura do arquivo
	mov ah, 3Ch
	mov cx, 0
	lea dx, saida
	int 21h
	mov handle_saida, ax				;Salva o handle em "handle_saida"

escreve_cabecalho:						;Parte que basicamente escreve o cabecalho, esta parte está certa
	cmp FLAG_A, 1						;Um pouco de preguiça de comentar essa parte, o que ela faz é basicamente 
	jne cabecalho_t						;Verificar se a flag de cada um está ligada e, se sim, escreve na tela
										;Mesma ideia para a escrita das informações
	mov ah, 40h
	mov cx, 1
	mov bx, handle_saida
	lea dx, base_a
	int 21h
	mov ja_chamado, 1

cabecalho_t:
	cmp FLAG_T, 1
	jne cabecalho_c
	cmp ja_chamado, 1
	je cabecalho_t_2
	mov ah, 40h
	mov cx, 1
	mov bx, handle_saida
	lea dx, base_t
	int 21h
	mov ja_chamado, 1
	jmp cabecalho_c
cabecalho_t_2:
	mov ah, 40h
	mov cx, 1
	mov bx, handle_saida
	lea dx, ponto_e_virgula
	int 21h
	mov ah, 40h
	mov cx, 1
	mov bx, handle_saida
	lea dx, base_t
	int 21h

cabecalho_c:
	cmp FLAG_C, 1
	jne cabecalho_g
	cmp ja_chamado, 1
	je cabecalho_c_2
	mov ah, 40h
	mov cx, 1
	mov bx, handle_saida
	lea dx, base_c
	int 21h
	mov ja_chamado, 1
	jmp cabecalho_g
cabecalho_c_2:
	mov ah, 40h
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h
	mov ah, 40h
	mov cx, 1
	lea dx, base_c
	int 21h
cabecalho_g:
	cmp FLAG_G, 1
	jne cabecalho_plus
	cmp ja_chamado, 1
	je cabecalho_g_2
	mov ah, 40h
	mov cx, 1
	mov bx, handle_saida
	lea dx, base_g
	int 21h
	mov ja_chamado, 1
	jmp cabecalho_plus
cabecalho_g_2:
	mov ah, 40h
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h
	mov ah, 40h
	mov cx, 1
	lea dx, base_g
	int 21h

cabecalho_plus:
	cmp FLAG_PLUS, 1
	jne final_cabecalho
	cmp ja_chamado, 1
	je cabecalho_plus_2
	mov ah, 40h
	mov cx, 7
	mov bx, handle_saida
	lea dx, base_atcg
	int 21h
	jmp final_cabecalho
cabecalho_plus_2:
	mov ah, 40h
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h
	mov ah, 40h
	mov cx, 7
	lea dx, base_atcg
	int 21h

final_cabecalho:
	mov ah, 40h
	mov cx, 1
	lea dx, quebra_de_linha
	int 21h

	lea bx, copia_arquivo
;LAÇO DE INFORMAÇÕES------------------------------------------------
laco_escrita_numeros:
	mov cx, n										;Basicamente lê n bases (Se começar com LF ou CR pula e vai para a prox)
	mov copia_n, cx

pega_informacoes:
	cmp copia_n, 0
	je terminou_info
	mov al, [bx]
	cmp al, "A"
	jne escrita_t
	inc quantidade_a
	inc quantidade_at
	jmp caso_sem_quebra
escrita_t:
	cmp al, "T"
	jne escrita_c
	inc quantidade_t
	inc quantidade_at
	jmp caso_sem_quebra
escrita_c:
	cmp al, "C"
	jne escrita_g
	inc quantidade_c
	inc quantidade_cg
	jmp caso_sem_quebra
escrita_g:
	cmp al, "G"
	jne escrita_lf
	inc quantidade_g
	inc quantidade_cg
	jmp caso_sem_quebra
escrita_lf:
	cmp al, LF
	jne escrita_cr
	jmp caso_quebra

escrita_cr:
	cmp al, CR
	jne final_escrita
	jmp caso_quebra

caso_quebra:
	cmp letra_inicial, 0
	jne continua_caso_quebra
	mov letra_inicial, 0
	inc bx
	jmp pega_informacoes
continua_caso_quebra:
	inc bx
	inc linhas_contadas
	jmp pega_informacoes

caso_sem_quebra:
	mov letra_inicial, 1
	inc bx
	dec copia_n
	jmp pega_informacoes

terminou_info:
	mov letra_inicial, 0
	sub bx, n      
	sub bx, linhas_contadas
	inc bx
;ESCRITA EM SI-----------------------------------------------------------------

escrever_numeros:
	mov linhas_contadas, 0
	push bx

	cmp FLAG_A, 1
	jne t_saida
	mov ax, quantidade_a
	lea bx, str_escrita
	call stoi
	mov cx, 0
laco_a:
	mov al, [bx]
	cmp al, 0
	je laco_a_final
	inc bx
	inc cx
	jmp laco_a

laco_a_final:
	mov ah, 40h
	mov bx, handle_saida
	lea dx, str_escrita
	int 21h

limpa_a:
	lea si, str_limpa					;Source vira bx
	lea di, str_escrita					;Destino vira "funcao_wrong"
	mov cx, 10							;Coloca tamanho 1 em cx
	push es								;Salva es na pilha
	mov ax, ds							;Move ds para ax
	mov es, ax							;Move ax para es
	CLD									;Limpa os flags de direção
	REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
	pop es								;Retira es da pilha
	mov ja_chamado_2, 1

t_saida:
	cmp FLAG_T, 1
	jne c_saida
	cmp ja_chamado_2, 0
	je t_primeiro
	mov ah, 40h
	mov bx, handle_saida
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h
t_primeiro:
	mov ax, quantidade_t
	lea bx, str_escrita
	call stoi
	mov cx, 0
laco_t:
	mov al, [bx]
	cmp al, 0
	je laco_t_final
	inc bx
	inc cx
	jmp laco_t

laco_t_final:
	mov ah, 40h
	mov bx, handle_saida
	lea dx, str_escrita
	int 21h

limpa_t:
	lea si, str_limpa					;Source vira bx
	lea di, str_escrita					;Destino vira "funcao_wrong"
	mov cx, 10							;Coloca tamanho 1 em cx
	push es								;Salva es na pilha
	mov ax, ds							;Move ds para ax
	mov es, ax							;Move ax para es
	CLD									;Limpa os flags de direção
	REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
	pop es								;Retira es da pilha
	mov ja_chamado_2, 1

c_saida:
	cmp FLAG_C, 1
	jne g_saida
	cmp ja_chamado_2, 0
	je c_primeiro
	mov ah, 40h
	mov bx, handle_saida
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h

c_primeiro:
	mov ax, quantidade_c
	lea bx, str_escrita
	call stoi
	mov cx, 0

laco_c:
	mov al, [bx]
	cmp al, 0
	je laco_c_final
	inc bx
	inc cx
	jmp laco_c

laco_c_final:
	mov ah, 40h
	mov bx, handle_saida
	lea dx, str_escrita
	int 21h

limpa_c:
	lea si, str_limpa					;Source vira bx
	lea di, str_escrita					;Destino vira "funcao_wrong"
	mov cx, 10							;Coloca tamanho 1 em cx
	push es								;Salva es na pilha
	mov ax, ds							;Move ds para ax
	mov es, ax							;Move ax para es
	CLD									;Limpa os flags de direção
	REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
	pop es								;Retira es da pilha
	mov ja_chamado_2, 1


g_saida:
	cmp FLAG_G, 1
	jne plus_saida
	cmp ja_chamado_2, 0
	je g_primeiro
	mov ah, 40h
	mov bx, handle_saida
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h
g_primeiro:
	mov ax, quantidade_g
	lea bx, str_escrita
	call stoi
	mov cx, 0
laco_g:
	mov al, [bx]
	cmp al, 0
	je laco_g_final
	inc bx
	inc cx
	jmp laco_g

laco_g_final:
	mov ah, 40h
	mov bx, handle_saida
	lea dx, str_escrita
	int 21h

limpa_g:
	lea si, str_limpa					;Source vira bx
	lea di, str_escrita					;Destino vira "funcao_wrong"
	mov cx, 10							;Coloca tamanho 1 em cx
	push es								;Salva es na pilha
	mov ax, ds							;Move ds para ax
	mov es, ax							;Move ax para es
	CLD									;Limpa os flags de direção
	REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
	pop es								;Retira es da pilha
	mov ja_chamado_2, 1

plus_saida:
	cmp FLAG_PLUS, 1
	jne final_laco
	cmp ja_chamado_2, 0
	je at_primeiro
	mov ah, 40h
	mov bx, handle_saida
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h

at_primeiro:
	mov ax, quantidade_at
	lea bx, str_escrita
	call stoi
	mov cx, 0

laco_at:
	mov al, [bx]
	cmp al, 0
	je laco_at_final
	inc bx
	inc cx
	jmp laco_at

laco_at_final:
	mov ah, 40h
	mov bx, handle_saida
	lea dx, str_escrita
	int 21h

limpa_at:	
	lea si, str_limpa					;Source vira bx
	lea di, str_escrita					;Destino vira "funcao_wrong"
	mov cx, 10							;Coloca tamanho 1 em cx
	push es								;Salva es na pilha
	mov ax, ds							;Move ds para ax
	mov es, ax							;Move ax para es
	CLD									;Limpa os flags de direção
	REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
	pop es								;Retira es da pilha
	mov ja_chamado_2, 1

separacao:
	mov ah, 40h
	mov bx, handle_saida
	mov cx, 1
	lea dx, ponto_e_virgula
	int 21h

cg_primeiro:
	mov ax, quantidade_cg
	lea bx, str_escrita
	call stoi
	mov cx, 0

laco_cg:
	mov al, [bx]
	cmp al, 0
	je laco_cg_final
	inc bx
	inc cx
	jmp laco_cg

laco_cg_final:
	mov ah, 40h
	mov bx, handle_saida
	lea dx, str_escrita
	int 21h

limpa_cg:	
	lea si, str_limpa					;Source vira bx
	lea di, str_escrita					;Destino vira "funcao_wrong"
	mov cx, 10							;Coloca tamanho 1 em cx
	push es								;Salva es na pilha
	mov ax, ds							;Move ds para ax
	mov es, ax							;Move ax para es
	CLD									;Limpa os flags de direção
	REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
	pop es								;Retira es da pilha
	mov ja_chamado_2, 1


final_laco:
	mov ah, 40h
	mov cx, 1
	lea dx, quebra_de_linha
	int 21h
	mov ja_chamado_2, 0
	mov quantidade_a, 0
	mov quantidade_c, 0
	mov quantidade_t, 0
	mov quantidade_g, 0
	mov quantidade_at, 0
	mov quantidade_cg, 0

	pop bx
	jmp laco_escrita_numeros

final_escrita:								;Fechamento do arquivo
	mov ah, 3Eh
	mov bx, handle_saida
	int 21h
	mov ja_chamado, 0
	jmp resumo_tela




resumo_tela:								;Área de printagem do resumo na tela
	lea bx, informacoes_opcoes				;Coloca o endereço do primeiro cabeçalho em bx
	call funcao_print						;Chama a função de printagem

	lea bx, nome_arquivo_resumo				;Coloca o endereço da string de nome do arquivo em bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, entrada							;Manda para bx o endereço de inicio do nome do arquivo em si
	call funcao_print						;Chama a funcao de printagem

	lea bx, quebra_de_linha					;Manda o endereço da string de quebra de linha para bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, nome_arquivo_saida_resumo		;Manda o endereço de inicio da string de nome de saida
	call funcao_print						;Chama a funcao de printagem

	lea bx, saida							;Manda o endereço de inicio da string com o nome do arquivo de saida
	call funcao_print						;Chama a funcao de printagem

	lea bx, quebra_de_linha					;Manda o endereço da string de quebra de linha para bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, tamanho_bases_resumo			;Manda endereço inicial da string de tamanho de bases para bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, n_array							;Coloca o endereço inicial da string que contem o numero n em bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, quebra_de_linha					;Manda o endereço de inicio da string de quebra de linha para bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, informacoes_arquivo_saida_resumo;Coloca o endereço de inicio da string de informações de bases em bx
	call funcao_print						;Chama a funcao de printagem

	cmp FLAG_A, 1							;Verifica se a flag de A está ligada
	jne atcg_resumo							;Se não, continua
	lea bx, base_a							;Se sim, escreve ela na tela
	call funcao_print
	mov ja_chamado, 1						;Liga o flag de funcao ja chamada

atcg_resumo:
	cmp FLAG_T, 1							;Verifica se a flag de T está ligada
	jne atcg_resumo_2						;Se não, continua
	cmp ja_chamado, 1						;Verifica se a flag de "ja_chamado" está ligada
	je flag_t_chamado						;Se sim, printa com ";"
	lea bx, base_t							;Se não, printa sem ";" e liga o flag "ja_chamado"
	call funcao_print
	mov ja_chamado, 1
	jmp atcg_resumo_2						;Continua

flag_t_chamado:								;Printa com ponto e vírgula
	lea bx, ponto_e_virgula
	call funcao_print
	lea bx, base_t
	call funcao_print

atcg_resumo_2:
	cmp FLAG_C, 1							;Verifica se a flag de C está ligada, a lógica do resto é a mesma que a do T
	jne atcg_resumo_3
	cmp ja_chamado, 1
	je flag_c_chamado
	lea bx, base_c
	call funcao_print
	mov ja_chamado, 1
	jmp atcg_resumo_3
flag_c_chamado:
	lea bx, ponto_e_virgula
	call funcao_print
	lea bx, base_c
	call funcao_print

atcg_resumo_3:
	cmp FLAG_G, 1							;Verifica se a flag de G está ligada, a lógica do resto é a mesma que a do T
	jne atcg_resumo_4
	cmp ja_chamado, 1
	je flag_g_chamado
	lea bx, base_g
	call funcao_print
	mov ja_chamado, 1
	jmp atcg_resumo_4
flag_g_chamado:
	lea bx, ponto_e_virgula
	call funcao_print
	lea bx, base_g
	call funcao_print

atcg_resumo_4:
	cmp FLAG_PLUS, 1						;Verifica se a flag de + está ligada, a lógica do resto é a mesma que a do T
	jne continuacao_resumo
	cmp ja_chamado, 1
	je flag_plus_chamado
	lea bx, base_atcg
	call funcao_print
	jmp continuacao_resumo
flag_plus_chamado:
	lea bx, ponto_e_virgula
	call funcao_print
	lea bx, base_atcg
	call funcao_print

continuacao_resumo:

	lea bx, quebra_de_linha					;Depois da parte de opções, printa uma quebra de linha
	call funcao_print						;Chama a funcao de printagem

	lea bx, quebra_de_linha					;Printa mais uma quebra de linha, por estilização 
	call funcao_print						;Chama a função de printagem

	lea bx, informacoes_arquivo				;Coloca o endereço de incio da string do segundo cabeçalho em bx
	call funcao_print						;Chama a função de printagem

	lea bx, numero_bases_resumo				;Coloca o endereço de inicio da string de numero de bases
	call funcao_print						;Chama a funcao de printagem

	mov ax, total_bases						;Coloca o numero de bases em ax
	lea bx, str_bases						;Configura "str_bases" como saida
	call stoi								;Chama a funcao de transformar inteiros em string
	call funcao_print						;Chama a funcao de printagem

	lea bx, quebra_de_linha					;Coloca o endereço da string de quebra de linha em bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, numero_grupos_resumo			;Coloca em bx o endereço de inicio da string de numero de grupos
	call funcao_print						;Chama a funcao de printagem

	mov ax, quantidade_grupos				;Coloca o numero de grupos em ax
	lea bx, str_grupos						;Configura "str_grupos" como saida
	call stoi								;Chama a funcao de transformar inteiros em string
	call funcao_print						;Chama a funcao de printagem

	lea bx, quebra_de_linha					;Coloca o endereço de inicio da string de quebra de linha em bx
	call funcao_print						;Chama a funcao de printagem

	lea bx, numero_linhas_com_base_resumo	;Coloca o endereço de inicio da string de numero de linhas c/ base em bx
	call funcao_print						;Chama a funcao de printagem

	mov ax, linhas_com_base					;Manda o numero de linhas com base para ax
	lea bx, str_linhas						;Configura "str_linhas" como saida
	call stoi								;Chama a funcao de conversao de inteiro para string
	call funcao_print						;Chama a funcao de printagem

	lea bx, quebra_de_linha					;Coloca o endereço de inico da string de quebra de linha em bx
	call funcao_print						;Chama a funcao de printagem


.exit										;FIM DO PROGRAMA

;---------------------------------------------------------------------------------
	funcao_f	proc near				;Subrotina para a função f (ela é near pois está no mesmo segmento de código)
		
		mov funcao_atual, "f"
		inc bx							;Incrementa o endereço de bx
		mov al, [bx]					;Move bx indireto para al para poder usar o comando
		cmp al, 20h						;Verifica se é espaço
		je continuacao_funcao_f			;Se não for, a sintaxe está errada, vai para o caso de erro
		mov al, 4						;Move 4 para al (Funcao de parametro invalido)
		call funcao_erro				;Chama erro

	continuacao_funcao_f:
		mov cx, 0						;Limpa o valor de cx (cx vai receber o tamanho do arquivo)
		inc bx							;Senão incrementa mais um (passando do espaço)
		mov si, bx						;Salva bx no registrador de source
		lea di, entrada					;Manda o endereço de "entrada" para o registrador de destino

	laco_tamanho_f:

		mov al, [bx]					;Move bx indireto para al
		cmp al, 20h						;Verifica se é espaço
		je laco_funcao_f				;Se for, chegou no final da string
		cmp al, 0						;Verifica se é \0
		je laco_funcao_f				;Se for, chegou no final da string
		inc cx							;Se não, incrementa o contador de tamanho
		inc bx							;Passa para o próximo caractere
		jmp laco_tamanho_f				;Repete
			

	laco_funcao_f:						;Escreve o nome do arquivo em "entrada"
		
		mov tamanho_entrada, cx			;Salva o tamanho do arquivo, que está em cx, na memória
		push es							;Salva es na pilha
		mov ax, ds						;Move ds para ax
		mov es, ax						;Move ax para es
		CLD								;Limpa os flags de direção
		REP movsb						;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
		pop es							;Retira es da pilha

				
	final_funcao_f:
		ret								;Retorno da subrotina
	
	funcao_f endp

;---------------------------------------------------------------------------------
	funcao_o	proc near				;Subrotina para a função o (ela é near pois está no mesmo segmento de código)
		
		mov funcao_atual, "o"
		mov saida_informada, 1			;Liga o flag que diz se a saida foi informada ou não
		inc bx							;Incrementa o endereço de bx
		mov al, [bx]					;Move bx indireto para al para poder usar o comando
		cmp al, 20h						;Verifica se é espaço
		je continuacao_funcao_o			;Se não for, a sintaxe está errada, vai para o caso de erro
		mov al, 4						;Chama a funcao de erro de parametro
		call funcao_erro				;Chama o erro

	continuacao_funcao_o:
		mov cx, 0						;Limpa o valor de cx (cx vai receber o tamanho do arquivo)
		inc bx							;Senão incrementa mais um (passando do espaço)
		mov si, bx						;Salva bx no registrador de source
		lea di, saida					;Manda o endereço de "saida" para o registrador de destino

	laco_tamanho_o:

		mov al, [bx]					;Move bx indireto para al
		cmp al, 20h						;Verifica se é espaço
		je laco_funcao_o				;Se for, chegou no final da string
		cmp al, 0						;Verifica se é \0
		je laco_funcao_o				;Se for, chegou no final da string
		inc cx							;Se não, incrementa o contador de tamanho
		inc bx							;Passa para o próximo caractere
		jmp laco_tamanho_o				;Repete
			

	laco_funcao_o:						;Escreve o nome do arquivo em "saida"
		
		mov tamanho_saida, cx			;Salva o tamanho do arquivo, que está em cx, na memória
		push es							;Salva es na pilha
		mov ax, ds						;Move ds para ax
		mov es, ax						;Move ax para es
		CLD								;Limpa os flags de direção
		REP movsb						;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
		pop es							;Retira es da pilha

				
	final_funcao_o:
		ret								;Retorno da subrotina
	
	funcao_o endp

;---------------------------------------------------------------------------------
	funcao_n	proc near				;Subrotina para a função n

		mov funcao_atual, "n"
		inc bx							;Incrementa o endereço de bx
		mov al, [bx]					;Move o byte apontado por bx para al
		cmp al, 20h						;Verifica se é espaço
		je continuacao_funcao_n 		;Se não for, erro de sintaxe
		mov al, 4						;Move para al o valor 4 (erro de parametro)
		call funcao_erro				;Chama a funcao de erro

	continuacao_funcao_n:
		mov cx, 0						;Limpa cx
		inc bx							;Incrementa bx (passa o espaço)
		mov si, bx						;Move bx para o registrador de source
		lea di, n_array					;Move n_array para o endereço de destino

	tamanho_funcao_n:

		mov al, [bx]					;Move bx indireto para al
		cmp al, 20h						;Verifica se é espaço
		je continua_n					;Se for, chegou no final da string
		cmp al, 0						;Verifica se é \0
		je continua_n					;Se for, chegou no final da string

		cmp al, 48						;Verifica se é maior ou igual a 48 (0)
		jge continua_tamanho_n
		mov al, 4						;Move numero de erro de parametro para al
		call funcao_erro				;Chama erro
	continua_tamanho_n:
		cmp al, 57						;verifica se é menor ou igual a 57 (9)
		jle continua_tamanho_n_2		;Se for menor, continua
		mov al, 4						;Move numero de erro de parametro para al
		call funcao_erro				;Chama erro

	continua_tamanho_n_2:
		inc cx							;Se não, incrementa o contador de tamanho
		inc bx							;Passa para o próximo caractere
		jmp tamanho_funcao_n			;Repete

	continua_n:

		mov tamanho_n, cx				;Salva o tamanho do arquivo, que está em cx, na memória
		push es							;Salva es na pilha
		mov ax, ds						;Move ds para ax
		mov es, ax						;Move ax para es
		CLD								;Limpa os flags de direção
		REP movsb						;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
		pop es							;Retira es da pilha

		mov	ax,	0						;Limpa ax (registrador que vai receber o valor decimal final)
		push bx              			;Move bx para a pilha
		lea bx, n_array					;Manda o endereço de inicio da string copiada para dx
		
	atoi_2:
		
		mov dl, [bx]					;Salva o byte apontado por dx em dl
		cmp	dl, 0						;Compara o byte apontado por dx com 0 (final de string)
		jz	fim_funcao_n				;Se for final de string, termina

		mov		cx,10					;Move 10 para o cx (para o cálculo do decimal)
		mul		cx						;Multiplica cx por A
		mov		ch,0					;Zera o high de cx
		mov		cl, [bx]				;Move o byte apontado por dx para o low de cx
		add		ax,cx					;Soma ax (que começa em zero) com cx
		sub		ax,'0'					;Subtrai 48 do resultado, uma vez que o cálculo foi feito com base no ascii
		inc		bx						;Incrementa dx
		jmp		atoi_2					;Repete

	fim_funcao_n:
		mov n, ax						;Manda ax para n (que contém o valor do número n digitado pelo usuário)
		pop bx 							;Pega bx que foi salvo na pilha

		ret								;Retorna

	funcao_n endp
;---------------------------------------------------------------------------------

	funcao_actg	proc near				;Subrotina para a função actg+

		mov funcao_atual, "a"
	inicio_actg:						;Basicamente verifica se é cada caso (a,t,c,g ou +)
		mov al, [bx]					;Move o valor de bx para al
		cmp al, 20h						;Verifica se o caractere é espaço
		je final_actg					;Se for, termina a funcao actg
		cmp al, 0						;Verifica se o caractere é "\0"
		je final_actg					;Se for, termina a funcao actg
		cmp al, 97						;Verifica se é A
		je caso_a						;Se sim, vai para o caso a, senão, continua
		cmp al, 99						;Verifca se é C
		je caso_c						;Se sim, vai para o caso c, senão, continua
		cmp al, 116						;Verifica se é T
		je caso_t						;Se sim, vai para o caso t, senão, continua
		cmp al, 103						;Verifica se é G
		je caso_g						;Se sim, vai para o caso g, senão, continua
		cmp al, 43						;Verifica se é +
		je caso_plus					;Se sim, vai para o caso +, senão, continua
		mov al, 4						;Se nenhum dos caracteres for chamado, manda codigo de erro 4 para al (parametro invalido)
		call funcao_erro				;Chama funcao de erro

	incremento_actg:					;Laço para passar para o proximo caractere
		inc bx							;Incrementa bx
		jmp inicio_actg					;Volta para o inicio
	
	caso_a:
		mov FLAG_A, 1					;Se for A, liga o flag artificial de A
		jmp incremento_actg				;Refaz o laço

	caso_c:
		mov FLAG_C, 1					;Se for A, liga o flag artificial de C
		jmp incremento_actg				;Refaz o laço

	caso_t:
		mov FLAG_T, 1					;Se for A, liga o flag artificial de T
		jmp incremento_actg				;Refaz o laço

	caso_g:
		mov FLAG_G, 1					;Se for A, liga o flag artificial de G
		jmp incremento_actg				;Refaz o laço

	caso_plus:
		mov FLAG_PLUS, 1				;Se for A, liga o flag artificial de +
		jmp incremento_actg				;Refaz o laço


	final_actg:							;Final da funcao
		ret								;Retorna

	funcao_actg endp
;---------------------------------------------------------------------------------

;Essa funcao precisa tratar alguns casos especificos de erro, como anotacao, vou lista-los em seguida
;Caso registrador = 0, erro de arquivo de entrada inexistente
;Caso registrador = 1, erro de quantidade de arquivos de entrada pequena
;Caso registrador = 2, erro de opcoes nao suficientes informadas (Mostrar quais nao foram informadas)
;Caso registrador = 3, erro de chamada de funcao inexistente
;Caso registrador = 4, erro de parametro invalido (Escrever opcao e parametro na tela)
;Caso registrador = 5, erro de arquivo muito grande
;Caso registrador = 6, erro de letra invalida no arquivo (Mostrar na tela linha e letra)
;O registrador será o AL

	funcao_erro	proc near						;Funcao que trata todos os erros possiveis

		push bx 								;Salva bx na pilha
		lea bx, error 							;Coloca o endereco de "error" em bx
		call funcao_print						;Printa error na tela
		lea bx, quebra_de_linha					;Coloca o endereco de "quebra_de_linha" em bx
		call funcao_print						;Printa quebra de linha na tela
		pop bx									;Tira bx da pilha

		cmp al, 0								;Faz todas as verificacoes da chamada de subrotina
		je arq_nao_existe						;0 se arquivo não existe
		cmp al, 1
		je entrada_pequena						;1 se o arquivo de entrada é muito pequeno
		cmp al, 2
		je funcoes_n_existem					;2 se não foram chamadas todas as funções obrigatórias
		cmp al, 3
		je funcao_errada_jump					;3 se a função chamada não existe
		cmp al, 4
		je parametro_malformado_jump			;4 se o parâmetro dado é malformado
		cmp al, 5
		je arquivo_grande_jump					;5 se o arquivo é muito grande (mais de 10.000 bases nitrogenadas)
		cmp al, 6
		je letra_malformada_jump				;6 se há alguma letra diferente de ACTG no arquivo
		jmp final_erro							;Se nao for encontrada nenhum valor de al correspondente, só vai para o final




		arq_nao_existe:							;Subrotina para arquivo inexistente

			lea bx, arquivo_inexistente			;Escreve primeira linha do erro
			call funcao_print					;Chama funcao de print
			lea bx, arquivo_inexistente_2		;Escreve segunda linha do erro
			call funcao_print					;Chama funcao de print
			lea bx, entrada						;Escreve o parametro a ser escrito
			call funcao_print					;Chama funcao de print
			lea bx, quebra_de_linha				;Escreve uma quebra de linha
			call funcao_print					;Chama funcao de print

			jmp final_erro						;Vai para o final da funcao
		
		entrada_pequena:						;Subrotina para entrada muito pequena

			lea bx, quantidade_minima			;Escreve primeira linha do erro
			call funcao_print					;Chama funcao de print
			lea bx, quantidade_minima_2			;Escreve segunda linha do erro
			call funcao_print 					;Chama funcao de print
			lea bx, n_array						;Escreve o parametro a ser escrito
			call funcao_print 					;Chama funcao de print
			lea bx, quebra_de_linha				;Escreve uma quebra de linha
			call funcao_print					;Chama funcao de print

			jmp final_erro						;Vai para o final da funcao

		funcao_errada_jump:
			jmp funcao_errada
		parametro_malformado_jump:
			jmp parametro_malformado
		arquivo_grande_jump:
			jmp arquivo_grande
		letra_malformada_jump:
			jmp letra_malformada

		funcoes_n_existem:						;Subrotina que informa se todos as funcoes necessarias foram chamadas

			lea bx, informacoes_insuficientes	;Printa a primeira linha
			call funcao_print

			cmp f_chamado, 1					;F foi chamada?
			je prox_funcoes_n_existem			;Se sim, continua
			lea bx, info_f						;Se nao, printa o erro para F e continua
			call funcao_print
				prox_funcoes_n_existem:
			cmp n_chamado, 1					;N foi chamada?
			je prox_funcoes_n_existem_2			;Se sim, continua
			lea bx, info_n						;Se nao, printa o erro para N e continua
			call funcao_print
				prox_funcoes_n_existem_2:
			cmp atcg_chamado, 1					;ACTG foi chamada?
			je prox_funcoes_n_existem_3			;Se sim, continua
			lea bx, info_actg					;Se nao, printa o erro para ACTG e continua
			call funcao_print
				prox_funcoes_n_existem_3:

			jmp final_erro						;Vai para o final da funcao

		funcao_errada:							;Subrotina para caso haja uma funcao nao existente

			mov al, [bx]
			mov str_aux, al
			lea bx, str_aux
			mov si, bx							;Source vira bx
			lea di, funcao_wrong				;Destino vira "funcao_wrong"
			mov cx, 1							;Coloca tamanho 1 em cx
			push es								;Salva es na pilha
			mov ax, ds							;Move ds para ax
			mov es, ax							;Move ax para es
			CLD									;Limpa os flags de direção
			REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
			pop es								;Retira es da pilha

			lea bx, funcao_inexistente			;Primeira linha do erro
			call funcao_print					;Printa a primeira linha
			lea bx, funcao_inexistente_2		;Segunda linha do erro
			call funcao_print					;Printa a segunda linha
			lea bx, funcao_wrong				;parametro a ser passado para o erro
			call funcao_print					;Printa a parametro
			lea bx, quebra_de_linha				;Quebra de linha
			call funcao_print					;Printa a quebra de linha

			jmp final_erro						;Vai para o final da funcao

		parametro_malformado:					;Subrotina para caso parametros nao sejam compatíveis com funcoes

			mov al, [bx]
			mov str_aux, al
			lea bx, str_aux
			mov si, bx							;Source vira bx
			lea di, funcao_wrong				;Destino vira "funcao_wrong"
			mov cx, 1							;Coloca tamanho 1 em cx
			push es								;Salva es na pilha
			mov ax, ds							;Move ds para ax
			mov es, ax							;Move ax para es
			CLD									;Limpa os flags de direção
			REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
			pop es								;Retira es da pilha

			lea bx, parametro_invalido			;Printa a primeira parte de parametro invalido
			call funcao_print

			cmp funcao_atual, "f"				;Checa se é f
			je caso_parametro_f
			cmp funcao_atual, "o"				;Checa se é o
			je caso_parametro_o
			cmp funcao_atual, "n"				;Checa se é n
			je caso_parametro_n
			cmp funcao_atual, "a"				;Checa se é actg
			je caso_parametro_actg

			caso_parametro_f:
				lea bx, parametro_invalido_2	;Escreve a primeira linha da funcao de parametro invalido
				call funcao_print				;Chama a funcao de printar
				lea bx, parametro_f				;Salva em bx a string de funcao f
				call funcao_print				;Chama a funcao de printar
				jmp final_parametro				;Pula para o final da subrotina de parametro

			caso_parametro_o:
				lea bx, parametro_invalido_2	;Escreve a primeira linha da funcao de parametro invalido
				call funcao_print				;Chama a funcao de printar
				lea bx, parametro_o				;Salva em bx a string de funcao o
				call funcao_print				;Chama a funcao de printar
				jmp final_parametro				;Pula para o final da subrotina de parametro

			caso_parametro_n:
				lea bx, parametro_invalido_2	;Escreve a primeira linha da funcao de parametro invalido
				call funcao_print				;Chama a funcao de printar
				lea bx, parametro_n				;Salva em bx a string de funcao n
				call funcao_print				;Chama a funcao de printar
				jmp final_parametro				;Pula para o final da subrotina de parametro

			caso_parametro_actg:
				lea bx, parametro_invalido_2	;Escreve a primeira linha da funcao de parametro invalido
				call funcao_print				;Chama a funcao de printar
				lea bx, parametro_actg			;Salva em bx a string de funcao actg
				call funcao_print				;Chama a funcao de printar
				jmp final_parametro				;Pula para o final da subrotina de parametro



		final_parametro:

			lea bx, parametro_invalido_3		;Salva a última string do erro de parametros em bx
			call funcao_print					;Chama a funcao de print
			lea bx, funcao_wrong				;Salva em bx qual o parametro errado
			call funcao_print					;Chama a funcao de print

			jmp final_erro						;Vai para o final

		arquivo_grande:							;Subrotina para caso o arquivo de entrada seja muito grande
			
			lea bx, quantidade_maxima			;Coloca o endereço da primeira linha em bx
			call funcao_print					;Printa a linha, simplesmente

			jmp final_erro						;Vai para o final da funcao

		letra_malformada:						;TERMINAR ESSE DEPOIS

			mov al, [bx]
			mov str_aux, al
			lea bx, str_aux
			mov si, bx							;Source vira bx
			lea di, funcao_wrong				;Destino vira "funcao_wrong"
			mov cx, 1							;Coloca tamanho 1 em cx
			push es								;Salva es na pilha
			mov ax, ds							;Move ds para ax
			mov es, ax							;Move ax para es
			CLD									;Limpa os flags de direção
			REP movsb							;Função de cópia de string de si para di, respeitando o limite de caracteres de cx
			pop es								;Retira es da pilha

			lea bx, letra_invalida				;Coloca o endereço da string de erro em bx
			call funcao_print					;Chama a função de print

			lea bx, letra_invalida_2			;Coloca o endereço da string de erro em bx
			call funcao_print					;Chama a função de print

			lea bx, funcao_wrong				;Coloca o endereço da letra errada em bx
			call funcao_print					;Chama a funcao de print

			lea bx, quebra_de_linha				;Endereço da string de quebra de linha
			call funcao_print					;Chama a funcao de print

			lea bx, letra_invalida_3			;Coloca o endereço da string de erro em bx
			call funcao_print					;Chama a funcao de print

			mov ax, linhas 
			lea bx, str_aux 
			call stoi
			call funcao_print

			lea bx, quebra_de_linha				;Coloca o endereço da string de quebra de linha em bx
			call funcao_print					;Chama a funcao de print

			jmp final_erro


		final_erro:
		.exit
		ret
	funcao_erro endp

;---------------------------------------------------------------------------------

	funcao_print proc near						;Função de print na tela

		push bx
		push dx
		push ax
	laco_funcao_print:
		mov		dl,[bx]
		cmp		dl, 0
		je		funcao_print_final

		push	bx
		mov		ah,2
		int		21H
		pop		bx

		inc		bx
		
		jmp		laco_funcao_print
		
	funcao_print_final:
		pop ax
		pop dx
		pop bx
		ret

	funcao_print endp


		stoi	proc	near						;Função do professor para transformar inteiros em strings
push bx	
push cx 
push ax
;void sprintf_w(char *string, WORD n) {
	mov		sw_n,ax

;	k=5;
	mov		cx,5
	
;	m=10000;
	mov		sw_m,10000
	
;	f=0;
	mov		sw_f,0
	
;	do {
sw_do:

;		quociente = n / m : resto = n % m;	// Usar instrução DIV
	mov		dx,0
	mov		ax,sw_n
	div		sw_m
	
;		if (quociente || f) {
;			*string++ = quociente+'0'
;			f = 1;
;		}
	cmp		al,0
	jne		sw_store
	cmp		sw_f,0
	je		sw_continue
sw_store:
	add		al,'0'
	mov		[bx],al
	inc		bx
	
	mov		sw_f,1
sw_continue:
	
;		n = resto;
	mov		sw_n,dx
	
;		m = m/10;
	mov		dx,0
	mov		ax,sw_m
	mov		bp,10
	div		bp
	mov		sw_m,ax
	
;		--k;
	dec		cx
	
;	} while(k);
	cmp		cx,0
	jnz		sw_do

;	if (!f)
;		*string++ = '0';
	cmp		sw_f,0
	jnz		sw_continua2
	mov		[bx],'0'
	inc		bx
sw_continua2:


;	*string = '\0';
	mov		byte ptr[bx],0
		
;}
pop ax 
pop cx
pop bx
	ret
		
stoi	endp


;---------------------------------------------------------------------------------
end

;---------------------------------------------------------------------------------

