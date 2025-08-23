module T = Oski_types.M

type t =
  { scos : float
  ; ssin : float
  ; tx : float
  ; ty : float
  }

let make ~scos ~ssin ~tx ~ty = { scos; ssin; tx; ty }

let to_native t =
  let rsxform = Ctypes.make T.RSXform.t in
  Ctypes.(
    setf rsxform T.RSXform.scos t.scos;
    setf rsxform T.RSXform.ssin t.ssin;
    setf rsxform T.RSXform.tx t.tx;
    setf rsxform T.RSXform.ty t.ty);
  rsxform

let of_native rsxform =
  make
    ~scos:(Ctypes.getf rsxform T.RSXform.scos)
    ~ssin:(Ctypes.getf rsxform T.RSXform.ssin)
    ~tx:(Ctypes.getf rsxform T.RSXform.tx)
    ~ty:(Ctypes.getf rsxform T.RSXform.ty)

let to_native_ptr t = to_native t |> Ctypes.addr
let identity () = make ~scos:1. ~ssin:0. ~tx:0. ~ty:0.

let from_rotation_translation ~angle ~tx ~ty =
  make ~scos:(Float.cos angle) ~ssin:(Float.sin angle) ~tx ~ty

let from_scale_rotation_translation ~scale ~angle ~tx ~ty =
  make ~scos:(scale *. Float.cos angle) ~ssin:(scale *. Float.sin angle) ~tx ~ty

let translate ~tx ~ty = make ~scos:1. ~ssin:0. ~tx ~ty
let scale ~scale = make ~scos:scale ~ssin:0. ~tx:0. ~ty:0.

let rotate ~angle =
  make ~scos:(Float.cos angle) ~ssin:(Float.sin angle) ~tx:0. ~ty:0.
