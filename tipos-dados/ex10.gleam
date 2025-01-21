import sgleam/check

pub type Direcao {
  Norte
  Leste
  Sul
  Oeste
}
// recebe uma direcao *d* e retorna a direcao oposta
pub fn direcao_oposta(d: Direcao) -> Direcao {
  case d {
    Norte -> Sul
    Sul -> Norte
    Leste -> Oeste
    Oeste -> Leste
  }
}

// recebe uma direcao *d* e retorna a direcao que esta há 90 graus no sentido horario
pub fn direcao_horaria(d: Direcao) -> Direcao {
  case d {
    Norte -> Leste
    Leste -> Sul
    Sul -> Oeste
    Oeste -> Norte
  }
}

// recebe uma direcao *d* e retorna a direcao que esta há 90 graus no sentido anti horario
pub fn direcao_anti_horaria(d: Direcao) -> Direcao {
  direcao_oposta(direcao_horaria(d))
}

// recebe uma direcao de origem *d_origem* e retorna quantos graus é
// necessario andar para chegar na direcao de destino *d_destino*
pub fn indica_graus(d_origem: Direcao, d_destino: Direcao) -> Int {
  case d_origem, d_destino {
    Norte, Norte -> 0
    Norte, Leste -> 90
    Norte, Oeste -> 270
    Norte, Sul -> 180
    Leste, Leste -> 0
    Leste, Norte -> 270
    Leste, Sul -> 90
    Leste, Oeste -> 180
    Sul, Norte -> 180
    Sul, Leste -> 270
    Sul, Oeste -> 90
    Sul, Sul -> 0
    Oeste, Norte -> 90
    Oeste, Leste -> 180
    Oeste, Sul -> 270
    Oeste, Oeste -> 0
  }
}

pub fn direcao_examples() {
  check.eq(direcao_oposta(Norte), Sul)
  check.eq(direcao_oposta(Sul), Norte)
  check.eq(direcao_oposta(Leste), Oeste)
  check.eq(direcao_oposta(Oeste), Leste)

  check.eq(direcao_horaria(Norte), Leste)
  check.eq(direcao_horaria(Sul), Oeste)
  check.eq(direcao_horaria(Leste), Sul)
  check.eq(direcao_horaria(Oeste), Norte)

  check.eq(direcao_anti_horaria(Norte), Oeste)
  check.eq(direcao_anti_horaria(Oeste), Sul)
  check.eq(direcao_anti_horaria(Sul), Leste)
  check.eq(direcao_anti_horaria(Leste), Norte)

  check.eq(indica_graus(Norte, Norte), 0)
  check.eq(indica_graus(Norte, Leste), 90)
  check.eq(indica_graus(Norte, Sul), 180)
  check.eq(indica_graus(Norte, Oeste), 270)

  check.eq(indica_graus(Leste, Leste), 0)
  check.eq(indica_graus(Leste, Norte), 270)
  check.eq(indica_graus(Leste, Sul), 90)
  check.eq(indica_graus(Leste, Oeste), 180)

  check.eq(indica_graus(Sul, Sul), 0)
  check.eq(indica_graus(Sul, Norte), 180)
  check.eq(indica_graus(Sul, Leste), 270)
  check.eq(indica_graus(Sul, Oeste), 90)

  check.eq(indica_graus(Oeste, Oeste), 0)
  check.eq(indica_graus(Oeste, Norte), 90)
  check.eq(indica_graus(Oeste, Sul), 270)
  check.eq(indica_graus(Oeste, Leste), 180)
}
