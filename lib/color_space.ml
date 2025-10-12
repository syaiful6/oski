module F = Oski_ffi.M

type t = F.Color_space.t

let of_srgb () =
  let cs = F.Color_space.of_srgb () in
  Gc.finalise F.Color_space.unref cs;
  cs

let of_srgb_linear () =
  let cs = F.Color_space.of_srgb_linear () in
  Gc.finalise F.Color_space.unref cs;
  cs

external to_native : t -> F.Color_space.t = "%identity"
