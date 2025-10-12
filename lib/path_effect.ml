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
  let effect = F.Path_effect.of_1d_path path advance phase style in
  Gc.finalise F.Path_effect.unref effect;
  effect

let create2d_line ~width ~matrix =
  let effect = F.Path_effect.of_2d_line width (Matrix.to_native_ptr matrix) in
  Gc.finalise F.Path_effect.unref effect;
  effect

let create2d_path ~matrix path =
  let effect = F.Path_effect.of_2d_path (Matrix.to_native_ptr matrix) path in
  Gc.finalise F.Path_effect.unref effect;
  effect
