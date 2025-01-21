import gleam/list
import gleam/int

pub fn conta(lst: List(a), pred: fn(a) -> Bool) -> Int {
  list.filter(lst, pred) |> list.fold_right(0, fn(acc, _) {acc+1})
}

pub fn duas_vezes(f: fn (Int) -> Int) -> fn(Int) -> Int {
    fn(x) {
        f(f(x))
    }
}
