module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Pixmap.t

let make () =
  let pixmap = F.Pixmap.make () in
  Gc.finalise F.Pixmap.delete pixmap;
  pixmap

let get_info pixmap =
  let info = Ctypes.make T.Image_info.t in
  F.Pixmap.get_info pixmap (Ctypes.addr info);
  Ctypes.addr info

let width pixmap = Image_info.width (get_info pixmap)
let height pixmap = Image_info.height (get_info pixmap)
let row_bytes pixmap = F.Pixmap.get_row_bytes pixmap |> Unsigned.Size_t.to_int
let get_pixel_color pixmap ~x ~y = F.Pixmap.get_pixel_color pixmap x y

let to_bigarray pixmap =
  let len = row_bytes pixmap * height pixmap in
  let char_ptr =
    Ctypes.from_voidp Ctypes.char (F.Pixmap.get_writable_addr pixmap)
  in
  Ctypes.bigarray_of_ptr Ctypes.array1 len Bigarray.char char_ptr

let to_native pixmap = pixmap
