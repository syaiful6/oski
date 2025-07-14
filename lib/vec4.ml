module T = Oski_types.M

type t =
  { x : float
  ; y : float
  ; z : float
  ; w : float
  }

let make x y z w = { x; y; z; w }

let as_native t =
  let v4 = Ctypes.make T.Vector4.t in
  Ctypes.(
    setf v4 T.Vector4.x t.x;
    setf v4 T.Vector4.y t.y;
    setf v4 T.Vector4.z t.z;
    setf v4 T.Vector4.w t.w);
  v4

let of_native t =
  make
    (Ctypes.getf t T.Vector4.x)
    (Ctypes.getf t T.Vector4.y)
    (Ctypes.getf t T.Vector4.z)
    (Ctypes.getf t T.Vector4.w)

let as_native_ptr t = as_native t |> Ctypes.addr
let dot a b = (a.x *. b.x) +. (a.y *. b.y) +. (a.z *. b.z) +. (a.w *. b.w)
let add a b = make (a.x +. b.x) (a.y +. b.y) (a.z +. b.z) (a.w +. b.w)
let sub a b = make (a.x -. b.x) (a.y -. b.y) (a.z -. b.z) (a.w -. b.w)
let mul a b = make (a.x *. b.x) (a.y *. b.y) (a.z *. b.z) (a.w *. b.w)
let mul_float t s = make (t.x *. s) (t.y *. s) (t.z *. s) (t.w *. s)
let scalar_div t s = make (t.x /. s) (t.y /. s) (t.z /. s) (t.w /. s)
let scalar_div2 s t = make (s /. t.x) (s /. t.y) (s /. t.z) (s /. t.w)
let length_squared a = dot a a
let length a = length_squared a |> Float.sqrt
let normalize v = mul_float v (1. /. length v)
let is_zero t = t.x = 0. && t.y = 0. && t.z = 0. && t.w = 0.
let zero = make 0. 0. 0. 0.
let unit_x = make 1. 0. 0. 0.
let unit_y = make 0. 1. 0. 0.
let unit_z = make 0. 0. 1. 0.
let unit_w = make 0. 0. 0. 1.
