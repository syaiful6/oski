module F = Oski_ffi.M

type t = F.Path_builder.t
type direction = F.Path.direction
type arc_size = F.Path.arc_size
type fill_type = F.Path.fill_type
type add_mode = F.Path.add_mode

let make () =
  let builder = F.Path_builder.make () in
  Gc.finalise F.Path_builder.delete builder;
  builder

let make_from_path path =
  let builder = F.Path_builder.make_from_path (Path.to_native path) in
  Gc.finalise F.Path_builder.delete builder;
  builder

let to_native builder = builder
let move_to builder pt = F.Path_builder.move_to builder pt.Point.x pt.Point.y
let line_to builder pt = F.Path_builder.line_to builder pt.Point.x pt.Point.y

let quad_to builder pt1 pt2 =
  F.Path_builder.quad_to builder pt1.Point.x pt1.Point.y pt2.Point.x pt2.Point.y

let conic_to builder pt1 pt2 weight =
  F.Path_builder.conic_to
    builder
    pt1.Point.x
    pt1.Point.y
    pt2.Point.x
    pt2.Point.y
    weight

let cubic_to builder pt1 pt2 pt3 =
  F.Path_builder.cubic_to
    builder
    pt1.Point.x
    pt1.Point.y
    pt2.Point.x
    pt2.Point.y
    pt3.Point.x
    pt3.Point.y

let arc_to_with_oval builder rect ~start_angle ~sweep_angle ~force_move_to =
  let native_rect = Rect.to_native_ptr rect in
  F.Path_builder.arc_to_with_oval
    builder
    native_rect
    start_angle
    sweep_angle
    force_move_to

let arc_to builder oval ~start_angle ~sweep_angle ~force_move_to =
  arc_to_with_oval builder oval ~start_angle ~sweep_angle ~force_move_to

let add_rect builder rect ?dir_start () =
  let dir = Option.fold ~none:`CW ~some:Fun.id (Option.map fst dir_start) in
  let start = Option.fold ~none:0 ~some:Fun.id (Option.map snd dir_start) in
  F.Path_builder.add_rect_start
    builder
    (Rect.to_native_ptr rect)
    dir
    (Unsigned.UInt32.of_int start)

let add_rrect builder rrect ?dir_start () =
  let dir = Option.fold ~none:`CW ~some:Fun.id (Option.map fst dir_start) in
  let start = Option.fold ~none:0 ~some:Fun.id (Option.map snd dir_start) in
  F.Path_builder.add_rrect_start
    builder
    (Rrect.to_native rrect)
    dir
    (Unsigned.UInt32.of_int start)

let add_oval builder rect ?(direction = `CW) () =
  F.Path_builder.add_oval builder (Rect.to_native_ptr rect) direction

let add_circle builder ~x ~y ~radius ?(direction = `CW) () =
  F.Path_builder.add_circle builder x y radius direction

let rmove_to builder point =
  F.Path_builder.rmove_to builder point.Point.x point.Point.y

let rline_to builder point =
  F.Path_builder.rline_to builder point.Point.x point.Point.y

let rquad_to builder pt1 pt2 =
  F.Path_builder.rquad_to
    builder
    pt1.Point.x
    pt1.Point.y
    pt2.Point.x
    pt2.Point.y

let rconic_to builder pt1 pt2 weight =
  F.Path_builder.rconic_to
    builder
    pt1.Point.x
    pt1.Point.y
    pt2.Point.x
    pt2.Point.y
    weight

let rcubic_to builder pt1 pt2 pt3 =
  F.Path_builder.rcubic_to
    builder
    pt1.Point.x
    pt1.Point.y
    pt2.Point.x
    pt2.Point.y
    pt3.Point.x
    pt3.Point.y

let close = F.Path_builder.close

let add_path builder src point ?(mode = `Append) () =
  F.Path_builder.add_path_offset
    builder
    (Path.to_native src)
    point.Point.x
    point.Point.y
    mode

let add_path_matrix builder src matrix ?(mode = `Append) () =
  let native_matrix = Matrix.to_native_ptr matrix in
  F.Path_builder.add_path_matrix builder (Path.to_native src) native_matrix mode

let add_path_reverse builder src =
  F.Path_builder.reverse_add_path builder (Path.to_native src)

let set_fill_type = F.Path_builder.set_fill_type
let get_fill_type = F.Path_builder.get_fill_type
let reset = F.Path_builder.reset

let detach builder =
  let path = F.Path_builder.detach_path builder in
  Gc.finalise F.Path.delete path;
  path

let snapshot builder =
  let path = F.Path_builder.snapshot_path builder in
  Gc.finalise F.Path.delete path;
  path
