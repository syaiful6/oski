module T = Oski_types.M

type t =
  { x : float
  ; y : float
  ; z : float
  }

let make x y z = { x; y; z }

let as_native t =
  let v3 = Ctypes.make T.Point3.t in
  Ctypes.(
    setf v3 T.Point3.x t.x;
    setf v3 T.Point3.y t.y;
    setf v3 T.Point3.z t.z);
  v3

let of_native t =
  make
    (Ctypes.getf t T.Point3.x)
    (Ctypes.getf t T.Point3.y)
    (Ctypes.getf t T.Point3.z)

let as_native_ptr t = as_native t |> Ctypes.addr
let dot a b = (a.x *. b.x) +. (a.y *. b.y) +. (a.z *. b.z)

let cross a b =
  make
    ((a.y *. b.z) -. (a.z *. b.y))
    ((a.z *. b.x) -. (a.x *. b.z))
    ((a.x *. b.y) -. (a.y *. b.x))

let add a b = make (a.x +. b.x) (a.y +. b.y) (a.z +. b.z)
let sub a b = make (a.x -. b.x) (a.y -. b.y) (a.z -. b.z)
let mul a b = make (a.x *. b.x) (a.y *. b.y) (a.z *. b.z)
let mul_float t s = make (t.x *. s) (t.y *. s) (t.z *. s)
let scalar_div t s = make (t.x /. s) (t.y /. s) (t.z /. s)
let scalar_div2 s t = make (s /. t.x) (s /. t.y) (s /. t.z)
let length_squared a = dot a a
let length a = length_squared a |> Float.sqrt
let normalize v = mul_float v (1. /. length v)
let is_zero t = t.x = 0. && t.y = 0. && t.z = 0.
let zero = make 0. 0. 0.
let unit_x = make 1. 0. 0.
let unit_y = make 0. 1. 0.
let unit_z = make 0. 0. 1.
