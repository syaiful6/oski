open Oski_ffi.M
module T = Oski_types.M

type t =
  { m00 : float
  ; m01 : float
  ; m02 : float
  ; m03 : float
  ; m10 : float
  ; m11 : float
  ; m12 : float
  ; m13 : float
  ; m20 : float
  ; m21 : float
  ; m22 : float
  ; m23 : float
  ; m30 : float
  ; m31 : float
  ; m32 : float
  ; m33 : float
  }
(** 4x4 matrix. *)

let make
      ~m00
      ~m01
      ~m02
      ~m03
      ~m10
      ~m11
      ~m12
      ~m13
      ~m20
      ~m21
      ~m22
      ~m23
      ~m30
      ~m31
      ~m32
      ~m33
  =
  { m00
  ; m01
  ; m02
  ; m03
  ; m10
  ; m11
  ; m12
  ; m13
  ; m20
  ; m21
  ; m22
  ; m23
  ; m30
  ; m31
  ; m32
  ; m33
  }

let to_native t =
  let matrix = Ctypes.make T.Matrix44.t in
  Ctypes.(
    setf matrix T.Matrix44.m00 t.m00;
    setf matrix T.Matrix44.m01 t.m01;
    setf matrix T.Matrix44.m02 t.m02;
    setf matrix T.Matrix44.m03 t.m03;
    setf matrix T.Matrix44.m10 t.m10;
    setf matrix T.Matrix44.m11 t.m11;
    setf matrix T.Matrix44.m12 t.m12;
    setf matrix T.Matrix44.m13 t.m13;
    setf matrix T.Matrix44.m20 t.m20;
    setf matrix T.Matrix44.m21 t.m21;
    setf matrix T.Matrix44.m22 t.m22;
    setf matrix T.Matrix44.m23 t.m23;
    setf matrix T.Matrix44.m30 t.m30;
    setf matrix T.Matrix44.m31 t.m31;
    setf matrix T.Matrix44.m32 t.m32;
    setf matrix T.Matrix44.m33 t.m33);
  matrix

let of_native matrix =
  make
    ~m00:(Ctypes.getf matrix T.Matrix44.m00)
    ~m01:(Ctypes.getf matrix T.Matrix44.m01)
    ~m02:(Ctypes.getf matrix T.Matrix44.m02)
    ~m03:(Ctypes.getf matrix T.Matrix44.m03)
    ~m10:(Ctypes.getf matrix T.Matrix44.m10)
    ~m11:(Ctypes.getf matrix T.Matrix44.m11)
    ~m12:(Ctypes.getf matrix T.Matrix44.m12)
    ~m13:(Ctypes.getf matrix T.Matrix44.m13)
    ~m20:(Ctypes.getf matrix T.Matrix44.m20)
    ~m21:(Ctypes.getf matrix T.Matrix44.m21)
    ~m22:(Ctypes.getf matrix T.Matrix44.m22)
    ~m23:(Ctypes.getf matrix T.Matrix44.m23)
    ~m30:(Ctypes.getf matrix T.Matrix44.m30)
    ~m31:(Ctypes.getf matrix T.Matrix44.m31)
    ~m32:(Ctypes.getf matrix T.Matrix44.m32)
    ~m33:(Ctypes.getf matrix T.Matrix44.m33)

let to_native_ptr t = to_native t |> Ctypes.addr

let pp ppf m =
  let pp_row ppf r0 r1 r2 r3 =
    Format.fprintf ppf "%8.3f %8.3f %8.3f %8.3f" r0 r1 r2 r3
  in
  Format.fprintf ppf "@[<v>";
  pp_row ppf m.m00 m.m01 m.m02 m.m03;
  Format.fprintf ppf "@,";
  pp_row ppf m.m10 m.m11 m.m12 m.m13;
  Format.fprintf ppf "@,";
  pp_row ppf m.m20 m.m21 m.m22 m.m23;
  Format.fprintf ppf "@,";
  pp_row ppf m.m30 m.m31 m.m32 m.m33;
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
  let a_native = to_native a in
  let b_native = to_native b in
  let result = Ctypes.make T.Matrix44.t in
  Matrix44.concat
    (Ctypes.addr a_native)
    (Ctypes.addr b_native)
    (Ctypes.addr result);
  of_native result

let invert m =
  let src_native = to_native m in
  let dst = Ctypes.make T.Matrix44.t in
  if Matrix44.invert (Ctypes.addr src_native) (Ctypes.addr dst)
  then Some (of_native dst)
  else None
