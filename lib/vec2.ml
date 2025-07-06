module T = Oski_types.M

type t =
  { x : float
  ; y : float
  }

let make x y = { x; y }
let dot a b = (a.x *. b.x) +. (a.y *. b.y)
let cross a b = (a.x *. b.y) -. (a.y *. b.x)
let add a b = make (a.x +. b.x) (a.y +. b.y)
let sub a b = make (a.x -. b.x) (a.y -. b.y)
let mul a b = make (a.x *. b.x) (a.y *. b.y)
let mul_float t s = make (t.x *. s) (t.y *. s)
let scalar_div t s = make (t.x /. s) (t.y /. s)
let scalar_div2 s t = make (s /. t.x) (s /. t.y)
let length_squared a = dot a a
let length a = length_squared a |> Float.sqrt
let normalize v = mul_float v (1. /. length v)
let is_zero t = t.x = 0. && t.y = 0.

let as_native t =
  let v2 = Ctypes.make T.Point.t in
  Ctypes.(
    setf v2 T.Point.x t.x;
    setf v2 T.Point.y t.y);
  v2

let of_native t = make (Ctypes.getf t T.Point.x) (Ctypes.getf t T.Point.y)
let as_native_ptr t = Ctypes.addr (as_native t)
