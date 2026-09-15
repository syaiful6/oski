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

let to_native path = path

let verb_to_uint8 = function
  | `Move -> Unsigned.UInt8.of_int 0
  | `Line -> Unsigned.UInt8.of_int 1
  | `Quad -> Unsigned.UInt8.of_int 2
  | `Conic -> Unsigned.UInt8.of_int 3
  | `Cubic -> Unsigned.UInt8.of_int 4
  | `Close -> Unsigned.UInt8.of_int 5
  | `Done -> invalid_arg "Path.make_from: `Done is not a valid raw path verb"

let make_from points verbs weights fill_type ~is_volatile =
  let open Ctypes in
  let c_points =
    CArray.of_list Oski_types.M.Point.t (List.map Point.to_native points)
  in
  let c_verbs = CArray.of_list uint8_t (List.map verb_to_uint8 verbs) in
  let c_weights = CArray.of_list float weights in
  let path =
    F.Path.make_from
      (CArray.start c_points)
      (CArray.length c_points)
      (CArray.start c_verbs)
      (CArray.length c_verbs)
      (CArray.start c_weights)
      (CArray.length c_weights)
      fill_type
      is_volatile
  in
  Gc.finalise F.Path.delete path;
  path

let equal = F.Path.equal
let get_fill_type = F.Path.get_fill_type
let set_fill_type = F.Path.set_fill_type
let reset = F.Path.reset
let rewind = F.Path.rewind
let count_points = F.Path.count_points
let count_verbs = F.Path.count_verbs

let transform path matrix =
  let native_matrix = Matrix.to_native_ptr matrix in
  F.Path.transform path native_matrix

let get_bounds path =
  let open Ctypes in
  let rect = F.Rect.of_empty () in
  F.Path.get_bounds path rect;
  Rect.of_native !@rect

let is_rect path =
  let open Ctypes in
  let rect = F.Rect.of_empty () in
  let is_closed = allocate bool false in
  let direction = allocate F.Path.direction `CW in
  let ret = F.Path.is_rect path rect is_closed direction in
  if ret then Some (Rect.of_native !@rect, !@is_closed, !@direction) else None

let get_points path max =
  let points = Ctypes.(CArray.make Oski_types.M.Point.t max) in
  let count = F.Path.get_points path (Ctypes.CArray.start points) max in
  count, Ctypes.CArray.to_list points |> List.map Point.of_native
