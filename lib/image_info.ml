module F = Oski_ffi.M
module T = Oski_types.M

type color_type = T.Color_type.t
type alpha_type = T.Alpha_type.t
type t = F.Image_info.t

let make
      ?(color_space = Color_space.of_srgb ())
      ~width
      ~height
      ~color_type
      ~alpha_type
      ()
  =
  F.Image_info.make
    ~width:(Int32.of_int width)
    ~height:(Int32.of_int height)
    ~color_type
    ~alpha_type
    ~colorspace:color_space

let make_n32_premul ?color_space ~width ~height () =
  make ?color_space ~width ~height ~color_type:`Rgb_8888 ~alpha_type:`Premul ()

let to_native t = t
let width t = Ctypes.(getf !@t T.Image_info.width) |> Int32.to_int
let height t = Ctypes.(getf !@t T.Image_info.height) |> Int32.to_int
let color_type t = Ctypes.(getf !@t T.Image_info.color_type)
let alpha_type t = Ctypes.(getf !@t T.Image_info.alpha_type)
