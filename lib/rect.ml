module T = Oski_types.M

type t =
  { left : float
  ; top : float
  ; right : float
  ; bottom : float
  }

let make ~left ~top ~right ~bottom = { left; top; right; bottom }

let as_native t =
  let rect = Ctypes.make T.Rect.t in
  Ctypes.(
    setf rect T.Rect.left t.left;
    setf rect T.Rect.top t.top;
    setf rect T.Rect.right t.right;
    setf rect T.Rect.bottom t.bottom);
  rect

let of_native rect =
  make
    ~left:(Ctypes.getf rect T.Rect.left)
    ~top:(Ctypes.getf rect T.Rect.top)
    ~right:(Ctypes.getf rect T.Rect.right)
    ~bottom:(Ctypes.getf rect T.Rect.bottom)

let as_native_ptr t = as_native t |> Ctypes.addr
let width t = t.right -. t.left
let height t = t.bottom -. t.top
let area t = width t *. height t
let is_empty t = t.left >= t.right || t.top >= t.bottom
let center_x t = (t.left +. t.right) /. 2.
let center_y t = (t.top +. t.bottom) /. 2.
let center t = Vec2.make (center_x t) (center_y t)

let contains_point t pt =
  pt.Vec2.x >= t.left
  && pt.Vec2.x <= t.right
  && pt.Vec2.y >= t.top
  && pt.Vec2.y <= t.bottom

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
         ~left:(Float.max a.left b.left)
         ~top:(Float.max a.top b.top)
         ~right:(Float.min a.right b.right)
         ~bottom:(Float.min a.bottom b.bottom))
  else None

let union a b =
  make
    ~left:(Float.min a.left b.left)
    ~top:(Float.min a.top b.top)
    ~right:(Float.max a.right b.right)
    ~bottom:(Float.max a.bottom b.bottom)

let empty = make ~left:0. ~top:0. ~right:0. ~bottom:0.
let of_xywh ~x ~y ~w ~h = make ~left:x ~top:y ~right:(x +. w) ~bottom:(y +. h)

let of_center_size center size =
  let half_w = size.Vec2.x /. 2. in
  let half_h = size.Vec2.y /. 2. in
  make
    ~left:(center.Vec2.x -. half_w)
    ~top:(center.Vec2.y -. half_h)
    ~right:(center.Vec2.x +. half_w)
    ~bottom:(center.Vec2.y +. half_h)
