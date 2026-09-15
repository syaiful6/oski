module F = Oski_ffi.M

type t = F.Image.t

let of_data data =
  match F.Image.of_encoded (Data.to_native data) with
  | None -> None
  | Some image ->
    Gc.finalise F.Image.unref image;
    Some image

let of_file path =
  match Data.of_file path with None -> None | Some data -> of_data data

let width = F.Image.get_width
let height = F.Image.get_height
let alpha_type = F.Image.get_alpha_type
let color_type = F.Image.get_color_type
let is_alpha_only = F.Image.is_alpha_only
let to_native t = t
