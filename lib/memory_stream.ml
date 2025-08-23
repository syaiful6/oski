module F = Oski_ffi.M

type t = F.Memory_stream.t

let of_string str len =
  match F.Memory_stream.of_string str (Unsigned.Size_t.of_int len) true with
  | Some stream ->
    Gc.finalise F.Memory_stream.delete stream;
    Some stream
  | None -> None

let of_data data =
  match F.Memory_stream.of_data data with
  | Some stream ->
    Gc.finalise F.Memory_stream.delete stream;
    Some stream
  | None -> None

let to_stream = F.Memory_stream.to_stream
