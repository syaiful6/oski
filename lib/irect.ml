module T = Oski_types.M

type t =
  { left : int
  ; top : int
  ; right : int
  ; bottom : int
  }

let make ~left ~top ~right ~bottom = { left; top; right; bottom }

let as_native t =
  let irect = Ctypes.make T.IRect.t in
  Ctypes.(
    setf irect T.IRect.left (Int32.of_int t.left);
    setf irect T.IRect.top (Int32.of_int t.top);
    setf irect T.IRect.right (Int32.of_int t.right);
    setf irect T.IRect.bottom (Int32.of_int t.bottom));
  irect

let of_native irect =
  make
    ~left:(Ctypes.getf irect T.IRect.left |> Int32.to_int)
    ~top:(Ctypes.getf irect T.IRect.top |> Int32.to_int)
    ~right:(Ctypes.getf irect T.IRect.right |> Int32.to_int)
    ~bottom:(Ctypes.getf irect T.IRect.bottom |> Int32.to_int)

let as_native_ptr t = as_native t |> Ctypes.addr
let width t = t.right - t.left
let height t = t.bottom - t.top
let area t = width t * height t
let is_empty t = t.left >= t.right || t.top >= t.bottom
let center_x t = (t.left + t.right) / 2
let center_y t = (t.top + t.bottom) / 2

let center t =
  let open Point in
  IPoint.make (center_x t) (center_y t)

let contains_point t pt =
  let open Point in
  pt.IPoint.x >= t.left
  && pt.IPoint.x <= t.right
  && pt.IPoint.y >= t.top
  && pt.IPoint.y <= t.bottom

let intersects a b =
  not
    (a.right <= b.left
    || b.right <= a.left
    || a.bottom <= b.top
    || b.bottom <= a.top)

let intersection a b =
  if intersects a b
  then
    Some
      (make
         ~left:(Int.max a.left b.left)
         ~top:(Int.max a.top b.top)
         ~right:(Int.min a.right b.right)
         ~bottom:(Int.min a.bottom b.bottom))
  else None

let union a b =
  make
    ~left:(Int.min a.left b.left)
    ~top:(Int.min a.top b.top)
    ~right:(Int.max a.right b.right)
    ~bottom:(Int.max a.bottom b.bottom)

let empty = make ~left:0 ~top:0 ~right:0 ~bottom:0
let of_xywh ~x ~y ~w ~h = make ~left:x ~top:y ~right:(x + w) ~bottom:(y + h)

let to_rect t =
  Rect.make
    ~left:(Float.of_int t.left)
    ~top:(Float.of_int t.top)
    ~right:(Float.of_int t.right)
    ~bottom:(Float.of_int t.bottom)

let of_rect t =
  make
    ~left:(Float.to_int t.Rect.left)
    ~top:(Float.to_int t.Rect.top)
    ~right:(Float.to_int t.Rect.right)
    ~bottom:(Float.to_int t.Rect.bottom)
