module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Font_style.t
type slant = T.Font_style.slant

let get_slant = F.Font_style.get_slant
let get_width = F.Font_style.get_width
let get_weight = F.Font_style.get_weight

let make weight width slant =
  let style = F.Font_style.make weight width slant in
  Gc.finalise F.Font_style.delete style;
  style
