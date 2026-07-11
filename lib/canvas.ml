module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Canvas.t
type clip_op = T.Clip_op.t

let to_native t = t
let clear t color = F.Canvas.clear t color

let clear_color4f t color =
  F.Canvas.clear_color4f t (Color.Color4f.to_native color)

let discard = F.Canvas.discard
let get_save_count = F.Canvas.get_save_count
let restore_to_count = F.Canvas.restore_to_count
let save = F.Canvas.save
let restore = F.Canvas.restore

let save_layer t rect paint =
  F.Canvas.save_layer t (Rect.to_native_ptr rect) paint

let draw_color t color mode = F.Canvas.draw_color t color mode

let draw_color4f t color mode =
  F.Canvas.draw_color4f t (Color.Color4f.to_native color) mode

let draw_paint t paint = F.Canvas.draw_paint t paint
let draw_point t pt paint = F.Canvas.draw_point t pt.Point.x pt.Point.y paint

let draw_line t p1 p2 paint =
  F.Canvas.draw_line t p1.Point.x p1.Point.y p2.Point.x p2.Point.y paint

let draw_rect t rect paint =
  F.Canvas.draw_rect t (Rect.to_native_ptr rect) paint

let draw_round_rect t rect ~rx ~ry paint =
  F.Canvas.draw_round_rect t (Rect.to_native_ptr rect) rx ry paint

let draw_rrect t rrect paint = F.Canvas.draw_rrect t rrect paint

let draw_circle t center radius paint =
  F.Canvas.draw_circle t center.Point.x center.Point.y radius paint

let draw_oval t rect paint =
  F.Canvas.draw_oval t (Rect.to_native_ptr rect) paint

let draw_path t path paint = F.Canvas.draw_path t path paint

let clip_rect ?(op = `Intersect) ?(antialias = false) t rect =
  F.Canvas.clip_rect_with_operation t (Rect.to_native_ptr rect) op antialias

let clip_path ?(op = `Intersect) ?(antialias = false) t path =
  F.Canvas.clip_path_with_operation t path op antialias

let clip_rrect ?(op = `Intersect) ?(antialias = false) t rrect =
  F.Canvas.clip_rrect_with_operation t rrect op antialias

let draw_simple_text ?(encoding = `GlyphId) canvas text x y font paint () =
  F.Canvas.draw_simple_text
    canvas
    text
    (Unsigned.Size_t.of_int (String.length text))
    encoding
    x
    y
    (Font.to_native font)
    (Paint.to_native paint)

let draw_text canvas text x y font paint =
  draw_simple_text canvas text x y font paint ()

let quick_reject t rect = F.Canvas.quick_reject t (Rect.to_native_ptr rect)
let translate = F.Canvas.translate
let scale = F.Canvas.scale
let rotate_degrees = F.Canvas.rotate_degrees
let rotate_radians = F.Canvas.rotate_radians
let skew = F.Canvas.skew
let reset_matrix = F.Canvas.reset_matrix
