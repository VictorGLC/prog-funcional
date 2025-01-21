// Aluno: Victor Gabriel Leite da Costa RA: 133070

import gleam/int
import gleam/list.{Continue, Stop}
import gleam/order
import gleam/result
import gleam/string
import sgleam/check

// Análise
// É necessário fazer um programa que receba uma lista de partidas de jogos do brasileirão em formato de lista de strings,
// o formato de cada jogo consiste em: Time_Anfitriao Gols_Anfitriao Time_Visitante Gols_Visitante.
// Caso o nome dos times tiver mais de uma palavra, deve ser utilizado '-' para não utilizar espaços e estiver no formato correto,
// por exemplo: Sao-Paulo.
// Os gols devem ser númericos e não devem ser negativos. Também é necessário verificar se todos os dados dos jogos foram preenchidos
// de modo que não ultrapasse ou falte os dados para cada jogo.
// Para o calculo do desempenho de cada time deve ter-se em mente a seguinte classificação:
// Vitória: 3 pontos
// Empate: 1 ponto
// Derrota: 0 pontos
// Saldo de gols: gols_marcados - gols_sofridos
// Este programa deve produzir como saída uma nova lista de strings com a classificacao de cada time no brasileirão, de forma ordenada,
// a ordenação deve respeitar a seguinte hierarquia: pontos, vitórias, saldo_gols e ordem alfabética

// tipo de dado representando os erros que são possiveis de receber na entrada.
pub type Erros {
  DadosInsuficientes
  DadosExcessivos
  GolNaoNumerico
  GolNegativo
  TimesIguais
}

// tipo de dado representando uma partida de jogo entre dois times no brasileirão.
pub type Jogo {
  Jogo(
    anfitriao: String,
    gols_anfitriao: Int,
    visitante: String,
    gols_visitante: Int,
  )
}

// tipo de dado representando o desempenho de um time durante o brasileirão.
pub type Desempenho {
  Desempenho(time: String, pontos: Int, vitorias: Int, saldo_gols: Int)
}

// Função principal
// Recebe uma lista de *jogos* do brasileirão e produz uma lista ordenada com as classificações baseada no desempenho de cada time.
// A lista é ordenada seguindo as regras de: pontos, vitórias, saldo_gols e ordem alfabética.
pub fn main(jogos: List(String)) -> Result(List(String), Erros) {
  use jogos <- result.try(verifica_lista_jogos(jogos))

  calcula_lista_desempenhos(jogos, encontra_times(jogos))
  |> ordena_desempenhos
  |> converte_desempenhos_em_string
  |> Ok
}

pub fn main_examples() {
  check.eq(
    main([
      "Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
      "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2",
    ]),
    Ok([
      "Flamengo    6 2  2", "Atletico-MG 3 1  0", "Palmeiras   1 0 -1",
      "Sao-Paulo   1 0 -1",
    ]),
  )
  check.eq(
    main([
      "Corinthians 3 Santos 2", "Gremio 1 Internacional 1",
      "Fluminense 0 Flamengo 4", "Palmeiras 2 Corinthians 2",
    ]),
    Ok([
      "Corinthians   4 1  1", "Flamengo      3 1  4", "Gremio        1 0  0",
      "Internacional 1 0  0", "Palmeiras     1 0  0", "Santos        0 0 -1",
      "Fluminense    0 0 -4",
    ]),
  )

  check.eq(
    main([
      "Botafogo 0 Vasco 0", "Cruzeiro 1 Atletico-MG 2",
      "Atletico-MG 3 Botafogo 0", "Vasco 2 Cruzeiro 1",
    ]),
    Ok([
      "Atletico-MG 6 2  4", "Vasco       4 1  1", "Botafogo    1 0 -3",
      "Cruzeiro    0 0 -2",
    ]),
  )

  check.eq(
    main([
      "Bahia 1 Fortaleza 1", "Ceara 0 Bahia 2", "Fortaleza 3 Ceara 0",
      "Cuiaba 0 Fortaleza 1",
    ]),
    Ok([
      "Fortaleza 7 2  4", "Bahia     4 1  2", "Cuiaba    0 0 -1",
      "Ceara     0 0 -5",
    ]),
  )

  check.eq(
    main([
      "Sport 2 Nautico 1", "Santa-Cruz gol2 Sport 1", "Nautico 0 Santa-Cruz 2",
      "Sport 3 Bahia 0",
    ]),
    Error(GolNaoNumerico),
  )
  check.eq(
    main([
      "Santos 3 Sao-Paulo 3", "Palmeiras 1 Santos 1", "Sao-Paulo 0 Palmeiras 1",
      "Santos 2 Palmeiras -2",
    ]),
    Error(GolNegativo),
  )

  check.eq(
    main([
      "Santos 3 Sao-Paulo 3", "Palmeiras 1 Santos", "Sao-Paulo 0 Palmeiras 1",
      "Santos 2 Palmeiras 2",
    ]),
    Error(DadosInsuficientes),
  )

  check.eq(
    main([
      "Santos 3 Sao-Paulo 3", "Palmeiras 1 Santos 2",
      "Sao-Paulo 0 Palmeiras 1 2", "Santos 2 Palmeiras 2",
    ]),
    Error(DadosExcessivos),
  )

  check.eq(
    main([
      "Santos 3 Sao-Paulo 3", "Palmeiras 1 Santos 2", "Palmeiras 0 Palmeiras 1",
      "Santos 2 Palmeiras 2",
    ]),
    Error(TimesIguais),
  )
}

// ------------ verificação de erros ----------------

// Verifica possivéis erros de entrada da lista de *jogos*
// Retorna Ok caso a lista de *jogos* esteja no padrão correto
// e retorna *Erros* caso não esteja no padrão correto.
pub fn verifica_lista_jogos(jogos: List(String)) -> Result(List(Jogo), Erros) {
  let resultado = list.try_map(jogos, verifica_jogo)
  result.map_error(resultado, fn(erro) { erro })
}

pub fn verifica_lista_jogos_examples() {
  check.eq(
    verifica_lista_jogos([
      "Criciuma 2 Flamengo 1", "Flamengo 5 Barcelona 7", "Gremio 1 Bragantino 0",
    ]),
    Ok([
      Jogo("Criciuma", 2, "Flamengo", 1),
      Jogo("Flamengo", 5, "Barcelona", 7),
      Jogo("Gremio", 1, "Bragantino", 0),
    ]),
  )
  check.eq(
    verifica_lista_jogos([
      "Criciuma -2 Flamengo 1", "Barcelona 5 Flamengo 7",
      "Gremio 1 Bragantino 0", "Brangatino 3 Criciuma 2",
    ]),
    Error(GolNegativo),
  )
  check.eq(
    verifica_lista_jogos([
      "Criciuma 0 Flamengo 2", "Cuiaba 5 Flamengo ola", "Gremio 1 Bragantino 0",
      "Brangatino 3 Criciuma 2",
    ]),
    Error(GolNaoNumerico),
  )
  check.eq(
    verifica_lista_jogos([
      "Criciuma 0 Flamengo 2", "Flamengo 5 Cuiaba 2", "Gremio 1 Gremio 0",
      "Brangatino 3 Criciuma 2",
    ]),
    Error(TimesIguais),
  )
  check.eq(
    verifica_lista_jogos([
      "Criciuma 0 Flamengo 2", "Flamengo 5 Cuiaba", "Gremio 1 Bragantino 0",
      "Brangatino 3 Criciuma 2",
    ]),
    Error(DadosInsuficientes),
  )
  check.eq(
    verifica_lista_jogos([
      "Criciuma 0 Flamengo 2", "Flamengo 5 Cuiaba 2 34", "Gremio 1 Bragantino 0",
      "Brangatino 3 Criciuma 2",
    ]),
    Error(DadosExcessivos),
  )
  check.eq(
    verifica_lista_jogos([
      "Criciuma 0 Flamengo 2", "Flamengo 5 Cuiaba 2", "Gremio 1 Bragantino 0",
      "Bragantino 3 Criciuma 2",
    ]),
    Ok([
      Jogo("Criciuma", 0, "Flamengo", 2),
      Jogo("Flamengo", 5, "Cuiaba", 2),
      Jogo("Gremio", 1, "Bragantino", 0),
      Jogo("Bragantino", 3, "Criciuma", 2),
    ]),
  )

  check.eq(
    verifica_lista_jogos([
      "Sport 2 Nautico 1", "Santa-Cruz 2 Sport 1", "Nautico 0 Santa-Cruz 2",
      "Sport 3 Bahia 0",
    ]),
    Ok([
      Jogo("Sport", 2, "Nautico", 1),
      Jogo("Santa-Cruz", 2, "Sport", 1),
      Jogo("Nautico", 0, "Santa-Cruz", 2),
      Jogo("Sport", 3, "Bahia", 0),
    ]),
  )
}

// Recebe *jogo* e verifica se é valido, ou seja, verifica se *jogo* esta na formatação correta da entrada, sendo ela:
// Anfitriao Gols_Anfitriao Visitante Gols_Visitante  
pub fn verifica_jogo(jogo: String) -> Result(Jogo, Erros) {
  case string.split(jogo, " ") {
    [anfitriao, gols_anfitriao, visitante, gols_visitante] ->
      case int.parse(gols_anfitriao), int.parse(gols_visitante) {
        Ok(_), Error(Nil) -> Error(GolNaoNumerico)
        Error(Nil), Ok(_) -> Error(GolNaoNumerico)
        Error(Nil), Error(Nil) -> Error(GolNaoNumerico)
        Ok(gols_anfitriao), Ok(gols_visitante) ->
          case gols_anfitriao < 0 || gols_visitante < 0 {
            True -> Error(GolNegativo)
            False ->
              case anfitriao == visitante {
                True -> Error(TimesIguais)
                False ->
                  Ok(Jogo(anfitriao, gols_anfitriao, visitante, gols_visitante))
              }
          }
      }
    [_, _, _, _, ..] -> Error(DadosExcessivos)
    _ -> Error(DadosInsuficientes)
  }
}

pub fn verifica_jogo_example() {
  check.eq(verifica_jogo(""), Error(DadosInsuficientes))
  check.eq(verifica_jogo("Cuiaba 2 Vitoria"), Error(DadosInsuficientes))
  check.eq(verifica_jogo("Santos 0 Atletico-MG 1 5"), Error(DadosExcessivos))
  check.eq(verifica_jogo("Barcelona -2 Coritiba 4"), Error(GolNegativo))
  check.eq(verifica_jogo("Real-Madrid 0 Vasco -3"), Error(GolNegativo))
  check.eq(verifica_jogo("Cruzeiro oi Corinthians 3"), Error(GolNaoNumerico))
  check.eq(verifica_jogo("Gremio 1 Bragantino tchau"), Error(GolNaoNumerico))
  check.eq(verifica_jogo("Flamengo 5 Flamengo 7"), Error(TimesIguais))
  check.eq(
    verifica_jogo("Criciuma 2 Flamengo 1"),
    Ok(Jogo("Sao-Paulo", 2, "Flamengo", 3)),
  )
}

// ------------------------- encontrando todos os times -------------------------

// Produz uma lista de strings com todos os times que participaram dos *jogos*, sem repetição de times.
pub fn encontra_times(jogos: List(Jogo)) -> List(String) {
  list.flat_map(jogos, fn(jogo) { [jogo.anfitriao, jogo.visitante] })
  |> list.unique()
}

pub fn encontra_times_examples() {
  check.eq(
    encontra_times([
      Jogo("Criciuma", 0, "Flamengo", 2),
      Jogo("Flamengo", 5, "Cuiaba", 2),
      Jogo("Gremio", 1, "Bragantino", 0),
      Jogo("Bragantino", 3, "Criciuma", 2),
    ]),
    ["Criciuma", "Flamengo", "Cuiaba", "Gremio", "Bragantino"],
  )
  check.eq(
    encontra_times([
      Jogo("Sao-Paulo", 0, "Atletico-MG", 2),
      Jogo("Flamengo", 5, "Palmeiras", 2),
      Jogo("Palmeiras", 1, "Sao-Paulo", 0),
      Jogo("Atletico-MG", 3, "Flamengo", 2),
    ]),
    ["Sao-Paulo", "Atletico-MG", "Flamengo", "Palmeiras"],
  )
  check.eq(
    encontra_times([
      Jogo("Santos", 2, "Bota-Fogo", 0),
      Jogo("Atletico-MG", 1, "Vasco", 1),
      Jogo("Vasco", 0, "Santos", 2),
      Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
    ]),
    ["Santos", "Bota-Fogo", "Atletico-MG", "Vasco"],
  )
  check.eq(
    encontra_times([
      Jogo("Atletico-MG", 0, "Palmeiras", 1),
      Jogo("Santos", 2, "Bota-Fogo", 0),
      Jogo("Atletico-MG", 1, "Vasco", 1),
      Jogo("Vasco", 0, "Santos", 2),
      Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
    ]),
    ["Atletico-MG", "Palmeiras", "Santos", "Bota-Fogo", "Vasco"],
  )
  check.eq(
    encontra_times([
      Jogo("Atletico-MG", 0, "Palmeiras", 1),
      Jogo("Santos", 2, "Bota-Fogo", 0),
      Jogo("Atletico-MG", 1, "Vasco", 1),
      Jogo("Palmeiras", 0, "Santos", 2),
      Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
    ]),
    ["Atletico-MG", "Palmeiras", "Santos", "Bota-Fogo", "Vasco"],
  )
  check.eq(encontra_times([]), [])
}

// Recebe lista de *jogos* e *time* produzindo uma nova lista com todos os jogos que *time* participou.
pub fn filtra_jogos_por_time(jogos: List(Jogo), time: String) -> List(Jogo) {
  list.filter(jogos, fn(jogo: Jogo) -> Bool {
    jogo.anfitriao == time || jogo.visitante == time
  })
}

pub fn filtra_jogos_por_time_examples() {
  check.eq(
    filtra_jogos_por_time(
      [
        Jogo("Atletico-MG", 0, "Palmeiras", 1),
        Jogo("Santos", 2, "Bota-Fogo", 0),
        Jogo("Atletico-MG", 1, "Vasco", 1),
        Jogo("Vasco", 0, "Santos", 2),
        Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
      ],
      "Atletico-MG",
    ),
    [
      Jogo("Atletico-MG", 0, "Palmeiras", 1),
      Jogo("Atletico-MG", 1, "Vasco", 1),
      Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
    ],
  )
}

// ------------------------- calculo de desempenhos -------------------------

// recebe lista de *jogos* e lista de *times* de todos os jogos
// produz lista de desempenhos calculada com base todos os jogos que *time* participou.
pub fn calcula_lista_desempenhos(
  jogos: List(Jogo),
  times: List(String),
) -> List(Desempenho) {
  list.map(times, fn(time: String) -> Desempenho {
    filtra_jogos_por_time(jogos, time)
    |> calcula_desempenho(time, Desempenho(time, 0, 0, 0))
  })
}

pub fn calcula_lista_desempenhos_examples() {
  check.eq(
    calcula_lista_desempenhos(
      [
        Jogo("Atletico-MG", 0, "Palmeiras", 1),
        Jogo("Santos", 2, "Bota-Fogo", 0),
        Jogo("Atletico-MG", 1, "Vasco", 1),
        Jogo("Vasco", 0, "Santos", 2),
        Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
      ],
      ["Palmeiras", "Vasco", "Santos", "Bota-Fogo", "Atletico-MG"],
    ),
    [
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Vasco", 1, 0, -2),
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
    ],
  )
  check.eq(
    calcula_lista_desempenhos(
      [
        Jogo("Atletico-MG", 0, "Palmeiras", 1),
        Jogo("Santos", 2, "Bota-Fogo", 0),
        Jogo("Atletico-MG", 1, "Vasco", 1),
        Jogo("Vasco", 0, "Santos", 2),
        Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
      ],
      ["Palmeiras", "Vasco", "Santos", "Bota-Fogo", "Atletico-MG"],
    ),
    [
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Vasco", 1, 0, -2),
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
    ],
  )
  check.eq(
    calcula_lista_desempenhos(
      [
        Jogo("Atletico-MG", 0, "Palmeiras", 1),
        Jogo("Santos", 2, "Bota-Fogo", 0),
        Jogo("Atletico-MG", 1, "Vasco", 1),
        Jogo("Vasco", 0, "Santos", 2),
        Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
      ],
      ["Palmeiras", "Vasco", "Santos", "Bota-Fogo", "Atletico-MG"],
    ),
    [
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Vasco", 1, 0, -2),
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
    ],
  )
  check.eq(
    calcula_lista_desempenhos(
      [
        Jogo("Atletico-MG", 0, "Palmeiras", 1),
        Jogo("Santos", 2, "Bota-Fogo", 0),
        Jogo("Atletico-MG", 1, "Vasco", 1),
        Jogo("Vasco", 0, "Santos", 2),
        Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
      ],
      ["Palmeiras", "Vasco", "Santos", "Bota-Fogo", "Atletico-MG"],
    ),
    [
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Vasco", 1, 0, -2),
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
    ],
  )
}

// recebe todos os *jogos* de *time*, atualiza e retorna o *desempenho* baseado em todos os jogos de *time*.
pub fn calcula_desempenho(
  jogos: List(Jogo),
  time: String,
  desempenho: Desempenho,
) -> Desempenho {
  list.fold(
    jogos,
    desempenho,
    fn(desempenho_atual: Desempenho, jogo: Jogo) -> Desempenho {
      case jogo.anfitriao == time, jogo.visitante == time {
        True, False ->
          desempenho_time(
            jogo.gols_anfitriao,
            jogo.gols_visitante,
            desempenho_atual,
          )
        False, True ->
          desempenho_time(
            jogo.gols_visitante,
            jogo.gols_anfitriao,
            desempenho_atual,
          )
        _, _ -> desempenho_atual
      }
    },
  )
}

pub fn calcula_desempenho_examples() {
  check.eq(
    calcula_desempenho(
      [
        Jogo("Bota-Fogo", 1, "Atletico-MG", 0),
        Jogo("Atletico-MG", 1, "Vasco", 1),
        Jogo("Atletico-MG", 0, "Palmeiras", 1),
      ],
      "Atletico-MG",
      Desempenho("Atletico-MG", 0, 0, 0),
    ),
    Desempenho("Atletico-MG", 1, 0, -2),
  )
  check.eq(
    calcula_desempenho(
      [Jogo("Atletico-MG", 0, "Palmeiras", 1)],
      "Palmeiras",
      Desempenho("Palmeiras", 0, 0, 0),
    ),
    Desempenho("Palmeiras", 3, 1, 1),
  )
  check.eq(
    calcula_desempenho(
      [Jogo("Atletico-MG", 1, "Vasco", 1), Jogo("Vasco", 0, "Santos", 2)],
      "Vasco",
      Desempenho("Vasco", 0, 0, 0),
    ),
    Desempenho("Vasco", 1, 0, -2),
  )
}

// realiza o calculo e atualiza o *desempenho* de um time em um determinado jogo. 
pub fn desempenho_time(
  gols_marcados: Int,
  gols_sofridos: Int,
  desempenho: Desempenho,
) -> Desempenho {
  let desempenho =
    Desempenho(
      ..desempenho,
      saldo_gols: desempenho.saldo_gols + { gols_marcados - gols_sofridos },
    )
  case gols_marcados > gols_sofridos {
    True ->
      Desempenho(
        ..desempenho,
        pontos: desempenho.pontos + 3,
        vitorias: desempenho.vitorias + 1,
      )
    False ->
      case gols_marcados == gols_sofridos {
        True -> Desempenho(..desempenho, pontos: desempenho.pontos + 1)
        False -> desempenho
      }
  }
}

pub fn desempenho_time_examples() {
  check.eq(
    desempenho_time(0, 1, Desempenho("Atletico-MG", 0, 0, 0)),
    Desempenho("Atletico-MG", 0, 0, -1),
  )
  check.eq(
    desempenho_time(1, 1, Desempenho("Atletico-MG", 0, 0, -1)),
    Desempenho("Atletico-MG", 1, 0, -1),
  )
  check.eq(
    desempenho_time(0, 1, Desempenho("Atletico-MG", 1, 0, -1)),
    Desempenho("Atletico-MG", 1, 0, -2),
  )
  check.eq(
    desempenho_time(1, 1, Desempenho("Vasco", 0, 0, 0)),
    Desempenho("Vasco", 1, 0, 0),
  )
  check.eq(
    desempenho_time(0, 2, Desempenho("Vasco", 1, 0, 0)),
    Desempenho("Vasco", 1, 0, -2),
  )
  check.eq(
    desempenho_time(0, 2, Desempenho("Bota-Fogo", 0, 0, 0)),
    Desempenho("Bota-Fogo", 0, 0, -2),
  )
  check.eq(
    desempenho_time(1, 0, Desempenho("Bota-Fogo", 0, 0, -2)),
    Desempenho("Bota-Fogo", 3, 1, -1),
  )
}

// ------------------------- inserção e ordenação -------------------------

// recebe lista de *desempenhos* e retorna a lista de *desempenhos* ordenada nos criterios de classificação do brasileirão
// caso haja empate, o desempate é feito por ordem hierarquica segundo os criterios: vitórias, saldo de gols e ordem alfabética.
pub fn ordena_desempenhos(desempenhos: List(Desempenho)) -> List(Desempenho) {
  list.fold(desempenhos, [], insere_desempenho_ordenado)
}

pub fn ordena_desempenhos_examples() {
  check.eq(
    ordena_desempenhos([
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Vasco", 1, 0, -2),
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
    ]),
    [
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
      Desempenho("Vasco", 1, 0, -2),
    ],
  )
}

// Recebe *novo_desempenho* e lista de *desempenhos*, deve produzir uma nova lista de desempenhos com *novo_desempenho* sendo inserido ordenado. A lista de *desempenhos* deve estar ordenada.
pub fn insere_desempenho_ordenado(
  desempenhos: List(Desempenho),
  novo_desempenho: Desempenho,
) -> List(Desempenho) {
  let lst =
    list.fold_until(desempenhos, [], fn(acc, atual) {
      case compara_desempenhos(novo_desempenho, atual) == novo_desempenho {
        True -> Stop(acc)
        False -> Continue(list.append(acc, [atual]))
      }
    })
    |> list.append([novo_desempenho])
  list.append(lst, list.drop(desempenhos, list.length(lst) - 1))
}

pub fn insere_desempenho_ordenado_examples() {
  check.eq(
    insere_desempenho_ordenado(
      [
        Desempenho("Santos", 6, 2, 4),
        Desempenho("Bota-Fogo", 3, 1, -1),
        Desempenho("Atletico-MG", 1, 0, -2),
        Desempenho("Vasco", 1, 0, -2),
      ],
      Desempenho("Palmeiras", 3, 1, 1),
    ),
    [
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
      Desempenho("Vasco", 1, 0, -2),
    ],
  )

  check.eq(
    insere_desempenho_ordenado(
      [
        Desempenho("Santos", 6, 2, 4),
        Desempenho("Bota-Fogo", 3, 1, -1),
        Desempenho("Atletico-MG", 1, 0, -2),
      ],
      Desempenho("Vasco", 1, 0, -2),
    ),
    [
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
      Desempenho("Vasco", 1, 0, -2),
    ],
  )
  check.eq(
    insere_desempenho_ordenado(
      [Desempenho("Bota-Fogo", 3, 1, -1), Desempenho("Atletico-MG", 1, 0, -2)],
      Desempenho("Santos", 6, 2, 4),
    ),
    [
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
    ],
  )
}

// recebe *desempenho1* e *desempenho2* retorna entre os dois desempenhos qual teve o melhor desempenho na classificação
// seguindo os criterios: pontos, vitorias, saldo_gols e ordem alfabetica
pub fn compara_desempenhos(
  desempenho1: Desempenho,
  desempenho2: Desempenho,
) -> Desempenho {
  case
    desempenho1.pontos > desempenho2.pontos
    || {
      desempenho1.pontos == desempenho2.pontos
      && desempenho1.vitorias > desempenho2.vitorias
    }
    || {
      desempenho1.pontos == desempenho2.pontos
      && desempenho1.vitorias == desempenho2.vitorias
      && desempenho1.saldo_gols > desempenho2.saldo_gols
    }
    || {
      desempenho1.pontos == desempenho2.pontos
      && desempenho1.vitorias == desempenho2.vitorias
      && desempenho1.saldo_gols == desempenho2.saldo_gols
      && string.compare(desempenho1.time, desempenho2.time) == order.Lt
    }
  {
    True -> desempenho1
    False -> desempenho2
  }
}

pub fn compara_desempenhos_examples() {
  check.eq(
    compara_desempenhos(
      Desempenho("Flamengo", 6, 2, 1),
      Desempenho("Fluminense", 3, 1, 0),
    ),
    Desempenho("Flamengo", 6, 2, 1),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Flamengo", 3, 2, 1),
      Desempenho("Fluminense", 6, 1, 0),
    ),
    Desempenho("Fluminense", 6, 1, 0),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Flamengo", 3, 2, 1),
      Desempenho("Fluminense", 3, 1, 0),
    ),
    Desempenho("Flamengo", 3, 2, 1),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Flamengo", 6, 2, 1),
      Desempenho("Fluminense", 6, 2, 0),
    ),
    Desempenho("Flamengo", 6, 2, 1),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Flamengo", 6, 2, 1),
      Desempenho("Fluminense", 6, 2, 1),
    ),
    Desempenho("Flamengo", 6, 2, 1),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Fluminense", 6, 2, 1),
      Desempenho("Flamengo", 6, 2, 1),
    ),
    Desempenho("Flamengo", 6, 2, 1),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Flamengo", 6, 2, 1),
      Desempenho("Corinthians", 6, 2, 1),
    ),
    Desempenho("Corinthians", 6, 2, 1),
  )
}

// ------------------------- convertendo desempenhos para strings -------------------------

// Retorna um inteiro baseado no tamanho maximo convertido da string de um dos atributos de *desempenho* utilizando a funcao *f*
pub fn tam_max_atributo(lst: List(Desempenho), f: fn(Desempenho) -> Int) -> Int {
  list.map(lst, f)
  |> list.fold(0, int.max)
}

// Recebe lista de *desempenhos* e converte do tipo Desempenho para string, produzindo uma nova lista com os desempenhos
// convertidos em formato de strings e com as colunas alinhadas.
pub fn converte_desempenhos_em_string(
  desempenhos: List(Desempenho),
) -> List(String) {
  let tam_max_time =
    tam_max_atributo(desempenhos, fn(d) { d.time |> string.length })
  let tam_max_pontos =
    tam_max_atributo(desempenhos, fn(d) {
      d.pontos |> int.to_string |> string.length
    })
  let tam_max_vitorias =
    tam_max_atributo(desempenhos, fn(d) {
      d.vitorias |> int.to_string |> string.length
    })
  let tam_max_gols =
    tam_max_atributo(desempenhos, fn(d) {
      d.saldo_gols |> int.to_string |> string.length
    })

  list.map(desempenhos, fn(d) {
    string.join(
      [
        string.pad_right(d.time, to: tam_max_time, with: " "),
        string.pad_left(int.to_string(d.pontos), to: tam_max_pontos, with: " "),
        string.pad_left(
          int.to_string(d.vitorias),
          to: tam_max_vitorias,
          with: " ",
        ),
        string.pad_left(
          int.to_string(d.saldo_gols),
          to: tam_max_gols,
          with: " ",
        ),
      ],
      with: " ",
    )
  })
}

pub fn converte_desempenhos_em_string_examples() {
  check.eq(
    converte_desempenhos_em_string([
      Desempenho("Palmeiras", 3, 1, 1),
      Desempenho("Vasco", 1, 0, -2),
      Desempenho("Santos", 6, 2, 4),
      Desempenho("Bota-Fogo", 3, 1, -1),
      Desempenho("Atletico-MG", 1, 0, -2),
    ]),
    [
      "Palmeiras   3 1  1", "Vasco       1 0 -2", "Santos      6 2  4",
      "Bota-Fogo   3 1 -1", "Atletico-MG 1 0 -2",
    ],
  )
}