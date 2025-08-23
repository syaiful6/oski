module T = Oski_types.M
module F = Oski_ffi.M

type t = F.Data.t

let of_file path =
  match F.Data.of_file path with
  | Some data ->
    Gc.finalise F.Data.unref data;
    Some data
  | None -> None

let of_stream stream size =
  match F.Data.of_stream stream size with
  | Some data ->
    Gc.finalise F.Data.unref data;
    Some data
  | None -> None

let get_size = F.Data.get_size

let to_string data =
  let ptr = Ctypes.from_voidp Ctypes.char (F.Data.get_data data) in
  let size = Unsigned.Size_t.to_int (F.Data.get_size data) in
  Ctypes.string_from_ptr ptr ~length:size

let to_native data = data
