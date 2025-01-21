
# Trabalho 03 - Calculadora

## Objetivos

O objetivo desse trabalho é avaliar a capacidade do aluno de:

- Implementar funções com recursão em cauda
- Implementar funções generativas

## Instruções

O trabalho é em equipe de até duas pessoas e deve ser entregue no classroom até às 23 horas e 59 minutos do dia 29/01/2025.

Cada aluno deve agendar a data da entrevista em uma planilha que será disponibilizada posteriormente.

Trabalhos que não tenham sido feitos pela equipe em sua totalidade serão zerados. O chatgpt e ferramentas afins não podem fazer parte de nenhum equipe!

## Descrição

A notação que usamos normalmente para escrever expressões aritméticas é chamada de notação infixa, isso porque os operadores ficam entre os operandos, como em `3 + 5 * 6`. Também podemos utilizar a notação posfixa, onde os operadores aparecem depois dos operandos. Na notação posfixa a expressão anterior é escrita como `5 6 * 3 +`. Dois aspectos são interessantes nessa notação: os parênteses não são necessários e o algoritmo de avaliação da expressão é mais simples.

Para avaliar uma expressão na notação pós-fixa podemos utilizar o seguinte algoritmo, que utiliza uma pilha para auxiliar na avaliação:

1. Analise a expressão da esquerda para a direita, um símbolo por vez:
    - Se o símbolo for um operando, empilhe-o;
    - Se o símbolo for um operador, desempilhe dois valores da pilha, aplique o operador, e empilhe o resultado.
2. Garanta que existe apenas um valor no topo da pilha e devolva esse valor.

Para o exemplo `5 6 * 3 +`, os passos do algoritmo seriam:

- Analisando o `5`: empilhar o `5`
- Analisando o `6`: empilhar o `6`
- Analisando o `*`: desempilhar o `6` e o `5`, multiplicar os dois e empilhar o `30`
- Analisando o `3`: empilhar o `3`
- Analisando o `+`: desempilhar o `3` e o `30`, somar os dois e empilhar o `33`
- Acabou a sequência: assegurar que só tem um elemento na pilha e devolver o valor

Para converter uma expressão na forma infixa para a forma pós-fixa o algoritmo é um pouco mais elaborado, ele usa uma pilha para os operadores e produz uma lista como saída:

1. Analise a expressão da esquerda para a direita, um símbolo por vez:
    - Se o símbolo for um operando, adicione o símbolo na saída.
    - Se o símbolo for um operador:
        - Enquanto o topo da pilha tiver um operador de maior ou igual precedência que o operador atual, remova-o da pilha e adicione-o à saída.
        - Empilhe o operador atual.
    - Se o símbolo for `(`, empilhe-o.
    - Se o símbolo for `)`, remova operadores da pilha e adicione-os à saída até encontrar um `(`.
2. Remova todos os operadores restantes na pilha e adicione-os à saída.

O trabalho consiste na implementação de uma função que receba como entrada uma expressão (string) na notação infixa, e calcule o valor da expressão. A implementação deve utilizar os dois algoritmos descritos anteriormente. Note que a pilha no primeiro algoritmo só pode armazenar números e no segundo algoritmo só pode armazenar operadores.

## Requisitos

O programa deve:

1. Definir um tipo de dado para representar um símbolo em uma expressão;
2. Tratar expressões inválidas;
3. Usar a função `fold` nos lugares adequados.

O programa não deve:

1. Falhar;
2. Utilizar funções recursivas que não sejam em cauda.

## Desenvolvimento

Segue uma sugestão de como proceder com o desenvolvimento do trabalho:

1. Comece pela definição do tipo de dado para representar um símbolo em uma expressão.
2. Depois projete a função que faz a avaliação de uma expressão (lista de símbolos) na notação pós-fixa.
3. Em seguida, implemente a função que converte uma expressão na notação infixa para a notação pós-fixa.
4. Por fim, projete a função que converta uma string para uma lista de símbolos (Dica: converta a string para uma lista de strings de 1 caractere e processe a lista).
