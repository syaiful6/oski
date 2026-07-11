module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Paint.t
type style = T.Paint.style
type stroke_cap = T.Paint.stroke_cap
type stroke_join = T.Paint.stroke_join

let make () =
  let paint = F.Paint.make () in
  Gc.finalise F.Paint.delete paint;
  paint

let clone t =
  match F.Paint.clone t with
  | None -> invalid_arg "Paint.clone: failed to clone paint"
  | Some paint ->
    Gc.finalise F.Paint.delete paint;
    paint

let to_native t = t
let reset = F.Paint.reset
let is_antialias = F.Paint.is_antialias
let set_antialias = F.Paint.set_antialias
let is_dither = F.Paint.is_dither
let set_dither = F.Paint.set_dither
let get_color = F.Paint.get_color
let set_color = F.Paint.set_color

let get_color4f t =
  let color = Ctypes.make T.Color4f.t in
  F.Paint.get_color4f t (Ctypes.addr color);
  Color.Color4f.of_native color

let set_color4f ?(color_space = Color_space.of_srgb ()) t color4f =
  F.Paint.set_color4f t (Color.Color4f.to_native_ptr color4f) color_space

let get_style = F.Paint.get_style
let set_style = F.Paint.set_style
let get_stroke_width = F.Paint.get_stroke_width
let set_stroke_width = F.Paint.set_stroke_width
let get_stroke_miter = F.Paint.get_stroke_miter
let set_stroke_miter = F.Paint.set_stroke_miter
let get_stroke_cap = F.Paint.get_stroke_cap
let set_stroke_cap = F.Paint.set_stroke_cap
let get_stroke_join = F.Paint.get_stroke_join
let set_stroke_join = F.Paint.set_stroke_join
let set_path_effect = F.Paint.set_path_effect
let get_path_effect = F.Paint.get_path_effect
let set_shader = F.Paint.set_shader

let make_fill ?(antialias = true) color =
  let paint = make () in
  set_antialias paint antialias;
  set_style paint `Fill;
  set_color paint color;
  paint

let make_stroke ?(antialias = true) ?(width = 1.) color =
  let paint = make () in
  set_antialias paint antialias;
  set_style paint `Stroke;
  set_stroke_width paint width;
  set_color paint color;
  paint
