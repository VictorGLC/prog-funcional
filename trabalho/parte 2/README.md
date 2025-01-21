# Trabalho 02 - Classificação no Brasileirão - Versão 2.0

## Objetivos
O objetivo desse trabalho é avaliar a capacidade do aluno de utilizar corretamente:
- Funções de alta ordem
- Açúcares sintáticos da linguagem
- O paradigma funcional

## Instruções
- O trabalho é em equipe de até duas pessoas e deve ser entregue no classroom até às **23 horas e 59 minutos do dia 13/01/2025**.
- Cada aluno deve agendar a data da entrevista em uma planilha que será disponibilizada posteriormente.
- Trabalhos que não tenham sido feitos pela equipe em sua totalidade serão zerados. 
- **O ChatGPT e ferramentas afins não podem fazer parte de nenhuma equipe!**

## Descrição
No trabalho 01, você teve que projetar um programa para calcular a classificação no Brasileirão, com algumas restrições, entre elas, **não utilizar funções de alta ordem**. O código pode ter ficado extenso e repetitivo, pois o objetivo naquele momento era utilizar apenas construções mais básicas da programação funcional.

Agora você deve alterar o seu programa para utilizar construções mais adequadas, especialmente as **funções de alta ordem** e os **açúcares sintáticos da linguagem**. Seu objetivo deve ser deixar o código mais legível e compacto, eliminando as construções repetitivas e diminuindo significativamente o tamanho do programa.

Além disso, você deve alterar a saída do programa para que ela fique mais amigável, alinhando as colunas na saída (o tamanho de cada largura não deve ser fixo, mas determinado pelo conteúdo da coluna). Por exemplo, para a entrada:

```
Sao-Paulo 1 Atletico-MG 2
Flamengo 2 Palmeiras 1
Palmeiras 0 Sao-Paulo 0
Atletico-MG 1 Flamengo 2
```

O seu programa deve produzir a saída:

```
Flamengo       6   2   2
Atletico-MG    3   1   0
Palmeiras      1   0  -1
Sao-Paulo      1   0  -1
```

## Requisitos

### O programa deve:
1. Tratar entradas inválidas, como valores não numéricos ou negativos para os gols, falta de algum dado, etc.
2. Funcionar de forma genérica para qualquer quantidade de resultados e para quaisquer times que apareçam nos resultados.

### O programa não deve:
1. Falhar.
2. Utilizar funções recursivas.
3. Utilizar a função `list.sort`.
4. Utilizar os tipos `dict` e `set`.

## Desenvolvimento
- Você pode partir da implementação do trabalho 1 e ir substituindo as funções recursivas por funções de alta ordem e o tratamento de erros com `use`. 
- Se você ficar com dúvida sobre qual função de alta ordem utilizar, siga as instruções que vimos em sala.
- Se a implementação estiver confusa, faça uma implementação do zero.

### Observações:
- Você pode utilizar qualquer função da biblioteca padrão, **exceto `list.sort`**.
- Para implementar a ordenação, veja especificamente as funções `list.fold_until` e `order.lazy_break_tie`.
- Não crie muitas funções anônimas. Elas devem ser usadas apenas se forem simples e utilizadas em apenas um lugar. Caso contrário, prefira funções nomeadas.
- Prefira fechamentos abreviados quando possível.
