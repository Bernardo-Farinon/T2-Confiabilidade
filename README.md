
Ainda nao consegui rodar teste para validacao. (nao da pra ter resultados de calculo de confiabilidade dependente de resultados)

Dentro do RS5 agora temos 3 executes paralelos, cada bloco recebe a mesma entrada e produz seu proprio resultado(result_A_o, result_B_o e result_C_o). Temos tambem o arbitro, que recebe o resultado de cada um desses executes e aplica o TMR devolvendo result_voted_o. 

    Possivel analizar implementacao em RS5.V :
        - Execute signals (linha 111)
        - Instancia dos 3 Execute (linha 345)
        - Instancia do Arbitro (linha 551)

    Alem dos modulos execute_A.sv, execute_B.sv e execute_C.svm que tem a mesma estrutura do execute original. Tambem o modulo arbiter.sv que aplica o TMR seguindo as instrucoes do enunciado.

    O resultado votado volta para o pipeline:

    FETCH -> DECODE ->  EXECUTE A \
                        EXECUTE B  | -> Arbiter -> RETIRE
                        EXECUTE C /

Para simular a confiabilidade cada execute tem uma logica interna de fala, introduzidas atravez de um contador e seguindo as instrucoes do enunciado. A falha 1 em 100 vezes (1%), B falha 1 em 20 vezes (5%) e C falha 1 em 10 vezes (10%).

