import sgleam/check

pub type EstadoElevador {
  Parado
  Subindo
  Descendo
}

// recebe o *andar_atual* e *andar_solicitado*, retorna o estado do elevador
// ou seja, retornará se o elevador vai subir ou descer conforme os andares
pub fn solicitacao_elevador(andar_atual: Int, andar_solicitado: Int) -> EstadoElevador {
  case andar_atual == andar_solicitado {
    True -> Parado
    False -> 
       case andar_atual < andar_solicitado {
         True -> Subindo
         False -> Descendo
       }
  }
}

pub fn solicitacao_elevador_examples() {
  check.eq(solicitacao_elevador(1, 2), Subindo)
  check.eq(solicitacao_elevador(5, 2), Descendo)
  check.eq(solicitacao_elevador(3, 3), Parado)
}
