module T = Oski_types.M

type t =
  { w : float
  ; h : float
  }

let make w h = { w; h }

let to_native t =
  let size = Ctypes.make T.Size.t in
  Ctypes.(
    setf size T.Size.w t.w;
    setf size T.Size.h t.h);
  size

let of_native size =
  make (Ctypes.getf size T.Size.w) (Ctypes.getf size T.Size.h)

let to_native_ptr t = to_native t |> Ctypes.addr
let area t = t.w *. t.h
let is_empty t = t.w <= 0. || t.h <= 0.
let is_zero t = t.w = 0. && t.h = 0.
let add a b = make (a.w +. b.w) (a.h +. b.h)
let sub a b = make (a.w -. b.w) (a.h -. b.h)
let mul a b = make (a.w *. b.w) (a.h *. b.h)
let mul_float t s = make (t.w *. s) (t.h *. s)
let scalar_div t s = make (t.w /. s) (t.h /. s)
let aspect_ratio t = if t.h = 0. then Float.infinity else t.w /. t.h
let zero = make 0. 0.
let unit = make 1. 1.
let to_vec2 t = Vec2.make t.w t.h
let of_vec2 t = make t.Vec2.x t.Vec2.y
