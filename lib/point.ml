module T = Oski_types.M

type t =
  { x : int
  ; y : int
  }

let make x y = { x; y }

let as_native t =
  let ipoint = Ctypes.make T.IPoint.t in
  Ctypes.(
    setf ipoint T.IPoint.x (Int32.of_int t.x);
    setf ipoint T.IPoint.y (Int32.of_int t.y));
  ipoint

let of_native t =
  make
    (Ctypes.getf t T.IPoint.x |> Int32.to_int)
    (Ctypes.getf t T.IPoint.y |> Int32.to_int)

let as_native_ptr t = as_native t |> Ctypes.addr
let add a b = make (a.x + b.x) (a.y + b.y)
let sub a b = make (a.x - b.x) (a.y - b.y)
let mul a b = make (a.x * b.x) (a.y * b.y)
let mul_int t s = make (t.x * s) (t.y * s)
let is_zero t = t.x = 0 && t.y = 0
let zero = make 0 0
let unit_x = make 1 0
let unit_y = make 0 1
let to_vec2 t = Vec2.make (Float.of_int t.x) (Float.of_int t.y)
let of_vec2 t = make (Float.to_int t.Vec2.x) (Float.to_int t.Vec2.y)
