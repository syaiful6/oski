module T = Oski_types.M

type t =
  { scale_x : float
  ; skew_x : float
  ; trans_x : float
  ; skew_y : float
  ; scale_y : float
  ; trans_y : float
  ; persp0 : float
  ; persp1 : float
  ; persp2 : float
  }

let make
      ~scale_x
      ~skew_x
      ~trans_x
      ~skew_y
      ~scale_y
      ~trans_y
      ~persp0
      ~persp1
      ~persp2
  =
  { scale_x; skew_x; trans_x; skew_y; scale_y; trans_y; persp0; persp1; persp2 }

let to_native t =
  let matrix = Ctypes.make T.Matrix.t in
  Ctypes.(
    setf matrix T.Matrix.scaleX t.scale_x;
    setf matrix T.Matrix.skewX t.skew_x;
    setf matrix T.Matrix.transX t.trans_x;
    setf matrix T.Matrix.skewY t.skew_y;
    setf matrix T.Matrix.scaleY t.scale_y;
    setf matrix T.Matrix.transY t.trans_y;
    setf matrix T.Matrix.persp0 t.persp0;
    setf matrix T.Matrix.persp1 t.persp1;
    setf matrix T.Matrix.persp2 t.persp2);
  matrix

let of_native matrix =
  make
    ~scale_x:(Ctypes.getf matrix T.Matrix.scaleX)
    ~skew_x:(Ctypes.getf matrix T.Matrix.skewX)
    ~trans_x:(Ctypes.getf matrix T.Matrix.transX)
    ~skew_y:(Ctypes.getf matrix T.Matrix.skewY)
    ~scale_y:(Ctypes.getf matrix T.Matrix.scaleY)
    ~trans_y:(Ctypes.getf matrix T.Matrix.transY)
    ~persp0:(Ctypes.getf matrix T.Matrix.persp0)
    ~persp1:(Ctypes.getf matrix T.Matrix.persp1)
    ~persp2:(Ctypes.getf matrix T.Matrix.persp2)

let to_native_ptr t = to_native t |> Ctypes.addr

let identity () =
  make
    ~scale_x:1.
    ~skew_x:0.
    ~trans_x:0.
    ~skew_y:0.
    ~scale_y:1.
    ~trans_y:0.
    ~persp0:0.
    ~persp1:0.
    ~persp2:1.

let translate ~x ~y =
  make
    ~scale_x:1.
    ~skew_x:0.
    ~trans_x:x
    ~skew_y:0.
    ~scale_y:1.
    ~trans_y:y
    ~persp0:0.
    ~persp1:0.
    ~persp2:1.

let scale ~x ~y =
  make
    ~scale_x:x
    ~skew_x:0.
    ~trans_x:0.
    ~skew_y:0.
    ~scale_y:y
    ~trans_y:0.
    ~persp0:0.
    ~persp1:0.
    ~persp2:1.

let rotate angle =
  let cos_a = Float.cos angle in
  let sin_a = Float.sin angle in
  make
    ~scale_x:cos_a
    ~skew_x:(-.sin_a)
    ~trans_x:0.
    ~skew_y:sin_a
    ~scale_y:cos_a
    ~trans_y:0.
    ~persp0:0.
    ~persp1:0.
    ~persp2:1.
