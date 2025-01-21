import gleam/int
import sgleam/check

// ex 6
// Recebe uma lista de strings e retorna
// uma string com todos os elementos concatenados
pub fn concatena_lst(lista: List(String)) -> String {
  case lista {
    [] -> ""
    [primeiro, ..resto] -> {
      primeiro <> concatena_lst(resto)
    }
  }
}

pub fn concatena_lst_examples() {
  check.eq(concatena_lst([]), "")
  check.eq(concatena_lst(["a", "b"]), "ab")
  check.eq(concatena_lst(["victor", " ", "costa"]), "victor costa")
}

//ex 7
// Recebe uma lista de numeros e retorna a quantidade 
// de numeros da lista
pub fn qtd_elementos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [_, ..resto] -> {
      1 + qtd_elementos(resto)
    }
  }
}

pub fn qtd_elementos_examples() {
  check.eq(qtd_elementos([1, 2, 3, 4, 5, 6, 7, 8]), 8)
  check.eq(qtd_elementos([]), 0)
  check.eq(qtd_elementos([12, 32, 45]), 3)
}

// ex 8
// Recebe uma lista de strings
// e retorna uma lista de ints das respectivas strings convertidas
pub fn converte_lista(lst: List(String)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> {
      case int.parse(primeiro) {
        Ok(primeiro) -> [primeiro, ..converte_lista(resto)]
        Error(_) -> converte_lista(resto)
      }
    }
  }
}

pub fn converte_lista_examples() {
  check.eq(converte_lista([]), [])
  check.eq(converte_lista(["2", "3", "4"]), [2, 3, 4])
  check.eq(converte_lista(["2", "a", "3", "212"]), [2, 3, 212])
}

//ex 9
// Recebe uma *lst* de inteiros e retorna uma lista sem os valores "zeros"
pub fn remove_zero(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> {
      case primeiro {
        0 -> remove_zero(resto)
        _ -> [primeiro, ..remove_zero(resto)]
      }
    }
  }
}

pub fn remove_zero_examples() {
  check.eq(remove_zero([2, 3, 4, 5, 0, 7, 1, 0, 0]), [2, 3, 4, 5, 7, 1])
  check.eq(remove_zero([0, 0, 0]), [])
  check.eq(remove_zero([0, 1, 0, 3, 0, 5, 0]), [1, 3, 5])
}

//ex 10
// Recebe uma lista de booleanos e verifica se todos os elementos são *True*
pub fn verifica_true(lst: List(Bool)) -> Bool {
  case lst {
    [] -> True
    [primeiro, ..resto] -> primeiro && verifica_true(resto)
  }
}

pub fn verifica_true_examples() {
  check.eq(verifica_true([True, True, True]), True)
  check.eq(verifica_true([]), True)
  check.eq(verifica_true([True]), True)
  check.eq(verifica_true([True, True, False]), False)
}

//ex 11
pub fn maximo(lst: List(Int)) -> Result(Int, Nil) {
  case lst {
    [] -> Error(Nil)
    [primeiro, ..resto] ->
      case maximo(resto) {
        Error(Nil) -> Ok(primeiro)
        Ok(maximo_resto) -> Ok(int.max(primeiro, maximo_resto))
      }
  }
}

pub fn maximo_examples() {
  check.eq(maximo([]), Error(Nil))
  check.eq(maximo([2]), Ok(2))
  check.eq(maximo([2, 1]), Ok(2))
  check.eq(maximo([2, 1, 5]), Ok(5))
}

// ex 12
/// Produz True se os elementos de *lst* estão em ordem não decrescente,
/// produz False caso contrário.
pub fn ordenado(lst: List(Int)) -> Bool {
  case lst {
    [] | [_] -> True
    [primeiro, segundo, ..resto] ->
      primeiro <= segundo && ordenado([segundo, ..resto])
  }
}

pub fn ordenado_examples() {
  check.eq(ordenado([]), True)
  check.eq(ordenado([4]), True)
  check.eq(ordenado([3, 4]), True)
  check.eq(ordenado([5, 4]), False)
  check.eq(ordenado([3, 3, 4]), True)
  check.eq(ordenado([3, 5, 4]), False)
  check.eq(ordenado([5, 4, 3]), False)
  check.eq(ordenado([2, 3, 4, 6, 89]), True)
  check.eq(ordenado([1, 2, 3, 0]), False)
}

//ex 13
// recebe *lst* e *elemento* e cria uma nova lista inserindo *elemento* no final da nova lista.
pub fn insere_fim(lst: List(Int), elemento: Int) -> List(Int) {
  case lst {
    [] -> [elemento]
    [primeiro, ..resto] -> [primeiro, ..insere_fim(resto, elemento)]
  }
}

pub fn insere_fim_examples() {
  check.eq(insere_fim([], 2), [2])
  check.eq(insere_fim([3, 4, 5, 6, 1], 10), [3, 4, 5, 6, 1, 10])
}

// recebe uma *lst* de inteiros e cria uma nova lista com os elementos de *lst* ao inverso.
pub fn inverte(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> insere_fim(inverte(resto), primeiro)
  }
}

pub fn inverte_examples() {
  check.eq(inverte([]), [])
  check.eq(inverte([2, 3, 4, 5, 7]), [7, 5, 4, 3, 2])
  check.eq(inverte([2]), [2])
  check.eq(inverte([2, 3]), [3, 2])
}

//ex 14
pub type Par {
  Par(chave: String, valor: Int)
}

// Recebe uma *lst* de *Par* e cria uma nova lista onde
// é atualizado o Par com a chave igual a *chave* e substitui valor de seu Par por *valor*
// caso não exista uma *Par* com esta chave, é adicionado no final da lista um *Par* com *chave* e *valor*
pub fn atualiza_associacao(
  lst: List(Par),
  chave: String,
  valor: Int,
) -> List(Par) {
  case lst {
    [] -> [Par(chave, valor)]
    [primeiro, ..resto] if primeiro.chave == chave -> [
      Par(chave, valor),
      ..resto
    ]
    [primeiro, ..resto] -> [
      primeiro,
      ..atualiza_associacao(resto, chave, valor)
    ]
  }
}

pub fn atualiza_associacao_examples() {
  check.eq(atualiza_associacao([], "Carlos", 9), [Par("Carlos", 9)])
  check.eq(
    atualiza_associacao(
      [Par("Pedro", 3), Par("Carlos", 5), Par("Ana", 7)],
      "Valdecir",
      9,
    ),
    [Par("Pedro", 3), Par("Carlos", 5), Par("Ana", 7), Par("Valdecir", 9)],
  )
  check.eq(
    atualiza_associacao(
      [Par("Pedro", 3), Par("Carlos", 5), Par("Ana", 7)],
      "Carlos",
      9,
    ),
    [Par("Pedro", 3), Par("Carlos", 9), Par("Ana", 7)],
  )
}

//ex 15
const preco_venda = 10

const custo_manga = 6

const custo_uva = 7

const custo_morango = 8

/// O sabor de um sorvete vendido.
pub type Sabor {
  Manga
  Uva
  Morango
}

/// Calcula o ganho pela venda dos sorvetes de *lst*.
pub fn ganho_venda_sorvetes(lst: List(Sabor)) -> Int {
  case lst {
    [] -> 0
    [sabor, ..resto] -> {
      let ganho = case sabor {
        Manga -> preco_venda - custo_manga
        Uva -> preco_venda - custo_uva
        Morango -> preco_venda - custo_morango
      }
      ganho + ganho_venda_sorvetes(resto)
    }
  }
}

pub fn ganho_venda_sorvetes_examples() {
  check.eq(ganho_venda_sorvetes([]), 0)
  check.eq(ganho_venda_sorvetes([Manga]), 4)
  check.eq(ganho_venda_sorvetes([Uva, Manga]), 7)
  check.eq(ganho_venda_sorvetes([Morango, Uva, Manga]), 9)
  check.eq(ganho_venda_sorvetes([Manga, Morango, Uva, Manga]), 13)
}

//ex 16
// Recebe uma *lst* de inteiros com leituras repetidas
// é desejado que retorne uma nova lista sem a repetição desnecessária dos valores.
pub fn corrige_leitura(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro] -> [primeiro]
    [primeiro, segundo, ..resto] if primeiro < segundo -> [
      primeiro,
      ..corrige_leitura([segundo, ..resto])
    ]
    [_, segundo, ..resto] -> corrige_leitura([segundo, ..resto])
  }
}

pub fn corrige_leitura_examples() {
  check.eq(corrige_leitura([3, 3, 7, 7, 7, 10]), [3, 7, 10])
  check.eq(corrige_leitura([3, 3, 3, 5, 5, 7, 7, 7, 10, 11]), [3, 5, 7, 10, 11])
}

// ex 17
/// Cria uma lista com os elementos de *lst* em ordem não decrescente usando o
/// algoritmo de ordenação por inserção.
pub fn ordena(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> insere_ordenado(ordena(resto), primeiro)
  }
}

pub fn ordena_examples() {
  check.eq(ordena([]), [])
  check.eq(ordena([2]), [2])
  check.eq(ordena([3, 2]), [2, 3])
  check.eq(ordena([5, -2, 3]), [-2, 3, 5])
  check.eq(ordena([1, 9, 5, -2, 8, 3]), [-2, 1, 3, 5, 8, 9])
}

/// Devolve uma nova lista com os mesmos elementos de lst junto com n em ordem
/// não decrescente.
///
/// Requer que lst esteja em ordem não decrescente.
fn insere_ordenado(lst: List(Int), n: Int) -> List(Int) {
  case lst {
    [] -> [n]
    [primeiro, ..resto] if n < primeiro -> [n, primeiro, ..resto]
    [primeiro, ..resto] -> [primeiro, ..insere_ordenado(resto, n)]
  }
}

pub fn insere_ordenado_examples() {
  check.eq(insere_ordenado([], 2), [2])
  check.eq(insere_ordenado([2], 1), [1, 2])
  check.eq(insere_ordenado([2], 3), [2, 3])
  check.eq(insere_ordenado([2, 6, 9], 1), [1, 2, 6, 9])
  check.eq(insere_ordenado([2, 6, 9], 4), [2, 4, 6, 9])
  check.eq(insere_ordenado([2, 6, 9], 7), [2, 6, 7, 9])
  check.eq(insere_ordenado([2, 6, 9], 10), [2, 6, 9, 10])
}