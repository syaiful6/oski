module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Path_iterator.t

let make path force_close =
  let maybe_iter = F.Path_iterator.make path (if force_close then 1 else 0) in
  match maybe_iter with
  | None -> None
  | Some iter ->
    F.Path_iterator.delete iter;
    Some iter

let next iterator =
  let paths = Ctypes.(CArray.make T.Point.t 4) in
  let verb = F.Path_iterator.next iterator (Ctypes.CArray.start paths) in
  verb, Ctypes.(CArray.to_list paths) |> List.map Point.of_native

let conic_weight = F.Path_iterator.conic_weight
let is_close_line = F.Path_iterator.is_close_line
let is_closed_contour = F.Path_iterator.is_closed_contour
