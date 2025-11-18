        Adicionado:
                ../app/soma/
                ../rtl/arbiter.sv
                ../sim/tb_arbiter.sv
                ../sim/sim_ex.do
        Alterado:
                ../rtl/RS5.sv

O pipeline do RS5 foi modificado para incluir três unidades de execução paralelas (Execute A, Execute B e Execute C).

Esses três valores são enviados ao módulo arbiter.sv, que implementa o mecanismo de votação TMR definido no enunciado. O árbitro compara as três saídas, identifica divergências, marca falhas nos módulos (fault_A, fault_B, fault_C) e gera a saída votada result_voted_o.

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

Foi desenvolvido um programa simples em C para gerar diversas somas consecutivas, conforme exigido no enunciado.
A geração do binário segue o fluxo:
    Compilação para ELF: riscv64-unknown-elf-gcc -O2 -march=rv32im -mabi=ilp32 -nostdlib -Ttext=0 -o test.elf soma.c
    Conversão para binário cru: riscv64-unknown-elf-objcopy -O binary test.elf test.bin

Apesar da infraestrutura estar implementada (três executes, árbitro, injeção de falhas e testbench), a simulação ainda não produziu resultados válidos.

A saída do questa permanece zerada, indicando algum problema no carregamento do programa ou na instância do RS5 dentro do testbench.

Calculos teoricos:

    Execute	 Taxa de falha	 Taxa de acerto   (confiabilidade)
    A	     1%	             99%              0.99
    B	     5%	             95%              0.95
    C	     10%	         90%              0.90

    P(falha do sistema)=pA​⋅pB​⋅pC​

        0.01⋅0.05⋅0.10=0.00005

    R=1−P(falha do sistema)

        R=1−0.00005=0.99995

        R=99.995%

-- para as 5000 somas --

    Falhas esperadas no Execute A

        5000⋅0.01= 50 falhas

    Falhas esperadas no Execute B

        5000⋅0.05= 250 falhas

    Falhas esperadas no Execute C

        5000⋅0.10= 500 falhas
