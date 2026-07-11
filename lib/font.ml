module F = Oski_ffi.M

type t = F.Font.t
type hinting = Oski_types.M.Font.hinting

let make () =
  let font = F.Font.make () in
  Gc.finalise F.Font.delete font;
  font

let make_with_values face size scalex skewx =
  let font =
    F.Font.make_with_values (Typeface.to_native face) size scalex skewx
  in
  Gc.finalise F.Font.delete font;
  font

let get_typeface font =
  let face = F.Font.get_typeface font in
  Gc.finalise F.Typeface.unref face;
  face

let set_typeface font face = F.Font.set_typeface font (Typeface.to_native face)
let get_size font = F.Font.get_size font
let set_size = F.Font.set_size
let is_subpixel = F.Font.is_subpixel
let set_subpixel = F.Font.set_subpixel

let get_metrics font =
  let metrics = Ctypes.make Oski_types.M.Font_metrics.t in
  let _ = F.Font.get_metrics font (Ctypes.addr metrics) in
  Font_metrics.of_native metrics

let measure_text ?bounds ~paint ?(encoding = `Utf8) font text () =
  F.Font.measure_text
    font
    text
    (Unsigned.Size_t.of_int (String.length text))
    encoding
    (Option.map Rect.to_native_ptr bounds)
    (Paint.to_native paint)

external to_native : t -> F.Font.t = "%identity"
