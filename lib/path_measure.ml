module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Path_measure.t
type matrix_flags = T.Path_measure.matrix_flags

let of_path path force_closed rescale =
  match F.Path_measure.of_path (Path.to_native path) force_closed rescale with
  | Some pm ->
    F.Path_measure.delete pm;
    Some pm
  | None -> None

let make () =
  match F.Path_measure.make () with
  | Some pm ->
    F.Path_measure.delete pm;
    Some pm
  | None -> None

let set_path pm path force_closed =
  F.Path_measure.set_path pm (Path.to_native path) force_closed

let get_length = F.Path_measure.get_length

let get_pos_tan pm distance =
  let pos = Ctypes.make T.Point.t in
  let tan = Ctypes.make T.Vector.t in
  let res =
    F.Path_measure.get_pos_tan pm distance (Ctypes.addr pos) (Ctypes.addr tan)
  in
  if res then Some (Point.of_native pos, Vec2.of_native tan) else None

let get_matrix pm distance flags =
  let matrix = Ctypes.make T.Matrix.t in
  let res = F.Path_measure.get_matrix pm distance (Ctypes.addr matrix) flags in
  if res then Some (Matrix.of_native matrix) else None
