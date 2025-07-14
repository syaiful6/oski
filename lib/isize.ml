module T = Oski_types.M

type t =
  { w : int
  ; h : int
  }

let make w h = { w; h }

let as_native t =
  let isize = Ctypes.make T.ISize.t in
  Ctypes.(
    setf isize T.ISize.w (Int32.of_int t.w);
    setf isize T.ISize.h (Int32.of_int t.h));
  isize

let of_native isize =
  make
    (Ctypes.getf isize T.ISize.w |> Int32.to_int)
    (Ctypes.getf isize T.ISize.h |> Int32.to_int)

let as_native_ptr t = as_native t |> Ctypes.addr
let area t = t.w * t.h
let is_empty t = t.w <= 0 || t.h <= 0
let is_zero t = t.w = 0 && t.h = 0
let add a b = make (a.w + b.w) (a.h + b.h)
let sub a b = make (a.w - b.w) (a.h - b.h)
let mul a b = make (a.w * b.w) (a.h * b.h)
let mul_int t s = make (t.w * s) (t.h * s)

let aspect_ratio t =
  if t.h = 0 then Float.infinity else Float.of_int t.w /. Float.of_int t.h

let zero = make 0 0
let unit = make 1 1
let to_size t = Size.make (Float.of_int t.w) (Float.of_int t.h)
let of_size t = make (Float.to_int t.Size.w) (Float.to_int t.Size.h)
