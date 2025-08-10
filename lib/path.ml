module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Path.t
type direction = F.Path.direction
type arc_size = F.Path.arc_size
type fill_type = F.Path.fill_type
type add_mode = F.Path.add_mode
type verb = F.Path.verb

let make () =
  let path = F.Path.make () in
  Gc.finalise F.Path.delete path;
  path

let make_from points verbs conic_weights fill_type is_volatile =
  let c_points =
    Ctypes.(
      CArray.of_list Oski_types.M.Point.t (List.map Point.to_native points))
    |> Ctypes.CArray.start
  in
  let c_verbs =
    Ctypes.(CArray.of_list uint8_t (List.map Unsigned.UInt8.of_int verbs))
    |> Ctypes.CArray.start
  in
  let c_conic_weights =
    Ctypes.(CArray.of_list float conic_weights) |> Ctypes.CArray.start
  in
  F.Path.make_from
    c_points
    (List.length points)
    c_verbs
    (List.length verbs)
    c_conic_weights
    (List.length conic_weights)
    fill_type
    is_volatile

let get_fill_type = F.Path.get_fill_type
let set_fill_type = F.Path.set_fill_type
let reset = F.Path.reset
let rewind = F.Path.rewind
let count_points = F.Path.count_points
let count_verbs = F.Path.count_verbs
let move_to path pt = F.Path.move_to path pt.Point.x pt.Point.y
let line_to path pt = F.Path.line_to path pt.Point.x pt.Point.y

let quad_to path pt1 pt2 =
  F.Path.quad_to path pt1.Point.x pt1.Point.y pt2.Point.x pt2.Point.y

let conic_to path pt1 pt2 weight =
  F.Path.conic_to path pt1.Point.x pt1.Point.y pt2.Point.x pt2.Point.y weight

let cubic_to path pt1 pt2 pt3 =
  F.Path.cubic_to
    path
    pt1.Point.x
    pt1.Point.y
    pt2.Point.x
    pt2.Point.y
    pt3.Point.x
    pt3.Point.y

let arc_to path oval ~start_angle ~sweep_angle ~force_move_to =
  let native_oval = Rect.to_native_ptr oval in
  F.Path.arc_to_with_oval path native_oval start_angle sweep_angle force_move_to

let arc_to_with_oval path rect ~start_angle ~sweep_angle ~force_move_to =
  let native_rect = Rect.to_native_ptr rect in
  F.Path.arc_to_with_oval path native_rect start_angle sweep_angle force_move_to

let add_rect path rect ?(dir_start = None) () =
  let dir = Option.fold ~none:`CW ~some:Fun.id (Option.map fst dir_start) in
  let start = Option.fold ~none:0 ~some:Fun.id (Option.map snd dir_start) in
  F.Path.add_rect_start
    path
    (Rect.to_native_ptr rect)
    dir
    (Unsigned.UInt32.of_int start)
