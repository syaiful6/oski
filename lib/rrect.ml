open Oski_ffi.M
module T = Oski_types.M

type t = (RRect.t, [ `Struct ]) Ctypes_static.structured

type rrect_type =
  [ `Empty
  | `Rect
  | `Oval
  | `Simple
  | `Nine_patch
  | `Complex
  ]

type corner =
  [ `Upper_left
  | `Upper_right
  | `Lower_right
  | `Lower_left
  ]

let as_native t = t
let as_native_ptr t = Ctypes.addr t
let make = RRect.make
let get_rect = RRect.get_rect
let get_radii = RRect.get_radii
let get_type = RRect.get_type
let contains = RRect.contains
