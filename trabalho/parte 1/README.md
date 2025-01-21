# Classificação do Brasileirão

## Objetivos

Este trabalho tem como objetivo avaliar a capacidade do aluno de:
- Projetar tipos de dados;
- Especificar funções;
- Implementar funções recursivas;
- Utilizar o paradigma funcional e a linguagem estudada.

---

## Descrição do Problema

No Campeonato Brasileiro de Futebol (Brasileirão), diversos times disputam o título de melhor time do Brasil. Os jogos são realizados em dois turnos (ida e volta), e os pontos são acumulados da seguinte forma:
- **Vitória:** 3 pontos;
- **Empate:** 1 ponto;
- **Derrota:** 0 pontos.

### Critérios de Classificação
A classificação dos times será determinada pelo desempenho, utilizando os seguintes critérios:
1. Pontos totais;
2. Número de vitórias;
3. Saldo de gols (gols marcados - gols sofridos);
4. Ordem alfabética (em caso de empate nos critérios anteriores).

---

### Entrada
A função receberá uma lista de strings, onde cada string descreve o resultado de um jogo no formato:
```
Anfitrião Gols Visitante Gols
```
Exemplo:
```
Sao-Paulo 1 Atletico-MG 2
Flamengo 2 Palmeiras 1
Palmeiras 0 Sao-Paulo 0
Atletico-MG 1 Flamengo 2
```

### Saída
O programa deve retornar uma lista de strings representando a classificação dos times no formato:
```
Time Pontos Vitórias SaldoDeGols
```
Exemplo:
```
Flamengo 6 2 2
Atletico-MG 3 1 0
Palmeiras 1 0 -1
Sao-Paulo 1 0 -1
```

---

## Requisitos

### O programa deve:
1. Tratar entradas inválidas (como valores não numéricos, negativos ou falta de dados);
2. Funcionar para qualquer quantidade de resultados e times.

### O programa **não deve**:
1. Falhar;
2. Utilizar funções de alta ordem.

---

## Desenvolvimento

### Observações
- A entrada e a saída da função principal serão manipuladas como listas de strings, permitindo futuras adaptações para leitura e escrita de arquivos.
- Internamente, o programa deverá trabalhar com estruturas específicas, evitando manipulação direta de strings para os cálculos e classificações.

### Etapas Sugeridas
1. **Identificar os times**: Descobrir todos os times presentes nos resultados.
2. **Calcular o desempenho**:
   - Pontos;
   - Número de vitórias;
   - Saldo de gols de cada time.
3. **Classificar os times**: Ordenar os times com base nos critérios de desempenho utilizando um método de ordenação, como ordenação por inserção ou outra técnica.

---

## Importante
- Resolva o problema de forma modular, decompondo-o em subproblemas menores para facilitar a implementação.
- Utilize boas práticas de programação e documente suas funções.