open Oski_ffi.M
module T = Oski_types.M

type t = (Matrix44.t, [ `Struct ]) Ctypes_static.structured
(** 4x4 matrix. *)

let as_native a = a
let as_native_ptr a = Ctypes.addr a
let make = Matrix44.make

let pp ppf m =
  let get = Ctypes.getf m in
  let pp_row ppf r0 r1 r2 r3 =
    Format.fprintf
      ppf
      "%8.3f %8.3f %8.3f %8.3f"
      (get r0)
      (get r1)
      (get r2)
      (get r3)
  in
  Format.fprintf ppf "@[<v>";
  T.Matrix44.(pp_row ppf m00 m01 m02 m03);
  Format.fprintf ppf "@,";
  T.Matrix44.(pp_row ppf m10 m11 m12 m13);
  Format.fprintf ppf "@,";
  T.Matrix44.(pp_row ppf m20 m21 m22 m23);
  Format.fprintf ppf "@,";
  T.Matrix44.(pp_row ppf m30 m31 m32 m33);
  Format.fprintf ppf "@]"

let to_string = Format.asprintf "%a" pp

let identity () =
  make
    ~m00:1.
    ~m01:0.
    ~m02:0.
    ~m03:0.
    ~m10:0.
    ~m11:1.
    ~m12:0.
    ~m13:0.
    ~m20:0.
    ~m21:0.
    ~m22:1.
    ~m23:0.
    ~m30:0.
    ~m31:0.
    ~m32:0.
    ~m33:1.

let translate ~x ~y ~z =
  make
    ~m00:1.
    ~m01:0.
    ~m02:0.
    ~m03:x
    ~m10:0.
    ~m11:1.
    ~m12:0.
    ~m13:y
    ~m20:0.
    ~m21:0.
    ~m22:1.
    ~m23:z
    ~m30:0.
    ~m31:0.
    ~m32:0.
    ~m33:1.

let scale ~x ~y ~z =
  make
    ~m00:x
    ~m01:0.
    ~m02:0.
    ~m03:0.
    ~m10:0.
    ~m11:y
    ~m12:0.
    ~m13:0.
    ~m20:0.
    ~m21:0.
    ~m22:z
    ~m23:0.
    ~m30:0.
    ~m31:0.
    ~m32:0.
    ~m33:1.

let concat a b =
  let aptr = C.addr a in
  let bptr = C.addr b in
  let result = C.make Matrix44.t in
  Matrix44.concat aptr bptr (Ctypes.addr result);
  result

let invert m =
  let src_ptr = C.addr m in
  let dst = C.make Matrix44.t in
  if Matrix44.invert src_ptr (C.addr dst) then Some dst else None
