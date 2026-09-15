module F = Oski_ffi.M
module T = Oski_types.M

module Style = struct
  type t = T.Path_effect.style
end

type t = F.Path_effect.t

let compose first second =
  let result = F.Path_effect.of_compose first second in
  Gc.finalise F.Path_effect.unref result;
  result

let sum first second =
  let result = F.Path_effect.of_sum first second in
  Gc.finalise F.Path_effect.unref result;
  result

let create1d ~style ~advance ~phase path =
  let eff = F.Path_effect.of_1d_path path advance phase style in
  Gc.finalise F.Path_effect.unref eff;
  eff

let create2d_line ~width ~matrix =
  let eff = F.Path_effect.of_2d_line width (Matrix.to_native_ptr matrix) in
  Gc.finalise F.Path_effect.unref eff;
  eff

let create2d_path ~matrix path =
  let eff = F.Path_effect.of_2d_path (Matrix.to_native_ptr matrix) path in
  Gc.finalise F.Path_effect.unref eff;
  eff

let null_rect_ptr = Ctypes.from_voidp T.Rect.t Ctypes.null
let null_matrix_ptr = Ctypes.from_voidp T.Matrix.t Ctypes.null

(** [filter_path ?cull_rect ?ctm effect ~stroke_rec src] applies [effect] to
    [src]. It returns [None] if the operation fails. [stroke_rec] supplies
    the stroke settings; use [Stroke_rec.make_fill ()] for a fill-only path.
    [cull_rect] takes effect only when [ctm] is present. *)
let filter_path ?cull_rect ?ctm path_effect ~stroke_rec src =
  let builder = Path_builder.make () in
  let cull_ptr =
    match ctm, cull_rect with
    | Some _, Some r -> Rect.to_native_ptr r
    | _ -> null_rect_ptr
  in
  let ctm_ptr =
    match ctm with None -> null_matrix_ptr | Some m -> Matrix.to_native_ptr m
  in
  let ok =
    F.Path_effect.filter_path
      path_effect
      (Path_builder.to_native builder)
      src
      (Stroke_rec.to_native stroke_rec)
      cull_ptr
      ctm_ptr
  in
  if ok then Some (Path_builder.detach builder) else None

external to_native : t -> F.Path_effect.t = "%identity"
