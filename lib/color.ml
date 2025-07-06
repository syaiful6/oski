open Unsigned

module HSV = struct
  type t =
    { h : float
    ; s : float
    ; v : float
    }

  let make h s v = { h; s; v }

  let to_color alpha t =
    let open Ctypes in
    let hsv = CArray.make float 3 in
    CArray.set hsv 0 t.h;
    CArray.set hsv 1 t.s;
    CArray.set hsv 2 t.v;
    Oski_ffi.M.Color.hsv_to_color (UInt.of_int alpha) (CArray.start hsv)
end

module RGB = struct
  type t =
    { r : uint8
    ; g : uint8
    ; b : uint8
    }

  let make r g b =
    { r = UInt8.of_int r; g = UInt8.of_int g; b = UInt8.of_int b }

  let to_hsv t =
    let open Ctypes in
    let to_unsigned x = x |> UInt8.to_int |> UInt.of_int in
    let hsv = CArray.make float 3 in
    Oski_ffi.M.Color.rgb_to_hsv
      (to_unsigned t.r)
      (to_unsigned t.g)
      (to_unsigned t.b)
      (CArray.start hsv);
    HSV.make (CArray.get hsv 0) (CArray.get hsv 1) (CArray.get hsv 2)
end

type t = uint32

let of_argb a r g b =
  Oski_ffi.M.Color.set_argb
    (UInt8.of_int a)
    (UInt8.of_int r)
    (UInt8.of_int g)
    (UInt8.of_int b)

let of_rgb = of_argb 0
let alpha t = Oski_ffi.M.Color.get_alpha t |> UInt8.to_int
let red t = Oski_ffi.M.Color.get_red t |> UInt8.to_int
let green t = Oski_ffi.M.Color.get_green t |> UInt8.to_int
let blue t = Oski_ffi.M.Color.get_blue t |> UInt8.to_int
let to_rgb t = RGB.make (red t) (green t) (blue t)
let to_hsv t = t |> to_rgb |> RGB.to_hsv

module Color4f = struct
  type t =
    { r : float
    ; g : float
    ; b : float
    ; a : float
    }

  let make r g b a = { r; g; b; a }

  let as_native t =
    let color = Ctypes.make Oski_types.M.Color4f.t in
    Ctypes.(
      setf color Oski_types.M.Color4f.red t.r;
      setf color Oski_types.M.Color4f.green t.g;
      setf color Oski_types.M.Color4f.blue t.b;
      setf color Oski_types.M.Color4f.alpha t.a);
    color

  let as_native_ptr t = as_native t |> Ctypes.addr

  let of_native color =
    make
      (Ctypes.getf color Oski_types.M.Color4f.red)
      (Ctypes.getf color Oski_types.M.Color4f.green)
      (Ctypes.getf color Oski_types.M.Color4f.blue)
      (Ctypes.getf color Oski_types.M.Color4f.alpha)

  let of_color color =
    let self = Ctypes.make Oski_types.M.Color4f.t in
    Oski_ffi.M.Color4f.of_color color (Ctypes.addr self);
    of_native self

  let to_color t = Oski_ffi.M.Color4f.to_color (as_native_ptr t)
  let transparent = make 0. 0. 0. 0.
  let black = make 0. 0. 0. 1.
  let grey = make 0.25 0.25 0.25 1.
  let light_grey = make 0.75 0.75 0.75 1.
  let white = make 1. 1. 1. 1.
  let red = make 1. 0. 0. 1.
  let green = make 0. 1. 0. 1.
  let blue = make 0. 0. 1. 1.
  let yellow = make 1. 1. 0. 1.
  let cyan = make 0. 1. 1. 1.
  let magenta = make 1. 0. 1. 1.
end
