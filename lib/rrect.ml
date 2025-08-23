module Bindings = Oski_ffi.M
module T = Oski_types.M

type t = Bindings.RRect.t
type type_ = T.RRect.type_
type corner = T.RRect.corner

let to_native t = t

let make () =
  let rrect = Bindings.RRect.make () in
  Gc.finalise Bindings.RRect.delete rrect;
  rrect

let copy original =
  let rrect = Bindings.RRect.copy original in
  Gc.finalise Bindings.RRect.delete rrect;
  rrect

let get_type = Bindings.RRect.get_type

let get_rect t =
  let rect = Ctypes.make T.Rect.t in
  Bindings.RRect.get_rect t (Ctypes.addr rect);
  Rect.of_native rect

let get_radii t corner =
  let vec2 = Ctypes.make T.Vector.t in
  Bindings.RRect.get_radii t corner (Ctypes.addr vec2);
  Vec2.of_native vec2

let get_width = Bindings.RRect.get_width
let get_height = Bindings.RRect.get_height
let set_empty = Bindings.RRect.set_empty

let set_rect t rect =
  let native = Rect.to_native_ptr rect in
  Bindings.RRect.set_rect t native

let set_oval t rect =
  let native = Rect.to_native_ptr rect in
  Bindings.RRect.set_oval t native

let set_rect_xy t rect x y =
  let native = Rect.to_native_ptr rect in
  Bindings.RRect.set_rect_xy t native x y

let set_nine_patch t rect left top right bottom =
  let native = Rect.to_native_ptr rect in
  Bindings.RRect.set_nine_patch t native left top right bottom

let set_rect_radii t rect vec =
  Bindings.RRect.set_rect_radii
    t
    (Rect.to_native_ptr rect)
    (Vec2.to_native_ptr vec)

let inset = Bindings.RRect.inset
let outset = Bindings.RRect.outset
let offset = Bindings.RRect.offset
let is_valid = Bindings.RRect.is_valid
let contains t rect = Bindings.RRect.contains t (Rect.to_native_ptr rect)

let transform t matrix =
  let dest = make () in
  let ret = Bindings.RRect.transform t (Matrix.to_native_ptr matrix) dest in
  if ret then Some dest else None
