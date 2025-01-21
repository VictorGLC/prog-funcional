import gleam/io
import gleam/string

pub fn dobro(x) {
 x*2
}

pub fn area_retangulo(altura: Float, largura: Float) -> Float {
 altura *. largura
}

pub fn produto_anterior_posterior(x: Int) -> Int{
 {x * {x-1} * {x+1}}
}

pub fn primeira_maiuscula(s: String) -> String {
 let prim = string.slice(s, 0, 1)
 let resto = string.slice(s, 1, string.length(s))
 string.append(string.uppercase(prim), string.lowercase(resto))
}

pub fn eh_par(x: Int) -> Bool {
 x % 2 == 0
}

pub fn tem_tres_digitos(x: Int) -> Bool {
 x >= 100 && x <= 999 || x <= -100 && x >= -999
}

pub fn maximo(a: Int, b: Int) -> Int {
 case a > b {
  True -> a
  False -> b
}
}

pub fn ordem(a: Int, b: Int, c: Int) -> String {
 case { a < b  && b < c && a < c } || { a > b &&  b > c && a > c }  {
  True -> 
        case  a < b  && b < c && a < c {
          True -> "crescente"
          False -> "decrescente"
        }
  False -> "sem ordem"
 }
}

pub fn main() {
 io.debug(dobro(9))
}