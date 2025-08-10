type t = Oski_ffi.M.Blender.t

let of_mode mode =
  let blender = Oski_ffi.M.Blender.of_mode mode in
  Gc.finalise Oski_ffi.M.Blender.unref blender;
  blender

let of_arithmetic ~k1 ~k2 ~k3 ~k4 ~enforce_premul =
  match Oski_ffi.M.Blender.of_arithmetic k1 k2 k3 k4 enforce_premul with
  | Some blender ->
    Gc.finalise Oski_ffi.M.Blender.unref blender;
    Some blender
  | None -> None
