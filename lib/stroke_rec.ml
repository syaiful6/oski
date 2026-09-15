module F = Oski_ffi.M

type t = F.Stroke_rec.t
type style = Paint.style

let make_fill () =
  let rec_ = F.Stroke_rec.make_fill_or_hairline false in
  Gc.finalise F.Stroke_rec.delete rec_;
  rec_

let make_hairline () =
  let rec_ = F.Stroke_rec.make_fill_or_hairline true in
  Gc.finalise F.Stroke_rec.delete rec_;
  rec_

let of_paint ?(res_scale = 1.0) paint style =
  let rec_ =
    F.Stroke_rec.make_from_paint (Paint.to_native paint) style res_scale
  in
  Gc.finalise F.Stroke_rec.delete rec_;
  rec_

let to_native t = t
