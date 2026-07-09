module T = Oski_types.M
module F = Oski_ffi.M

type t = F.Stream.t

type bigstring =
  (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

external to_native : t -> F.Stream.t = "%identity"

let duplicate stream =
  match F.Stream.duplicate stream with
  | Some duplicated ->
    F.Stream.delete duplicated;
    Some duplicated
  | None -> None

let fork stream =
  match F.Stream.fork stream with
  | Some forked ->
    F.Stream.delete forked;
    Some forked
  | None -> None

let has_position = F.Stream.has_position
let is_at_end = F.Stream.is_at_end
let get_position = F.Stream.get_position
let has_length = F.Stream.has_length
let get_length = F.Stream.get_length

let read stream buffer ~pos ~len =
  if pos < 0 || len < 0 || pos + len > Bigarray.Array1.dim buffer
  then invalid_arg "Stream.read: invalid position or length";
  let ptr = Ctypes.bigarray_start Ctypes.array1 buffer in
  let void_ptr = Ctypes.to_voidp ptr in
  let char_ptr = Ctypes.from_voidp Ctypes.char void_ptr in
  let ptr_offset = Ctypes.(char_ptr +@ pos) in
  let void_ptr_offset = Ctypes.to_voidp ptr_offset in
  let bytes_read =
    F.Stream.read stream void_ptr_offset (Unsigned.Size_t.of_int len)
  in
  Unsigned.Size_t.to_int bytes_read

let peek stream buffer ~pos ~len =
  if pos < 0 || len < 0 || pos + len > Bigarray.Array1.dim buffer
  then invalid_arg "Stream.peek: invalid position or length";
  let ptr = Ctypes.bigarray_start Ctypes.array1 buffer in
  let void_ptr = Ctypes.to_voidp ptr in
  let char_ptr = Ctypes.from_voidp Ctypes.char void_ptr in
  let ptr_offset = Ctypes.(char_ptr +@ pos) in
  let void_ptr_offset = Ctypes.to_voidp ptr_offset in
  let bytes_peeked =
    F.Stream.peek stream void_ptr_offset (Unsigned.Size_t.of_int len)
  in
  Unsigned.Size_t.to_int bytes_peeked

let read_bigstring stream len =
  let buffer = Bigarray.Array1.create Bigarray.char Bigarray.c_layout len in
  let bytes_read = read stream buffer ~pos:0 ~len in
  if bytes_read = len then buffer else Bigarray.Array1.sub buffer 0 bytes_read

let peek_bigstring stream len =
  let buffer = Bigarray.Array1.create Bigarray.char Bigarray.c_layout len in
  let bytes_peeked = peek stream buffer ~pos:0 ~len in
  if bytes_peeked = len
  then buffer
  else Bigarray.Array1.sub buffer 0 bytes_peeked

let read_bytes stream len =
  let bigstr = Bigarray.Array1.create Bigarray.char Bigarray.c_layout len in
  let bytes_read = read stream bigstr ~pos:0 ~len in
  let buffer = Bytes.create bytes_read in
  for i = 0 to bytes_read - 1 do
    Bytes.set_uint8 buffer i (Char.code (Bigarray.Array1.get bigstr i))
  done;
  buffer

let read_string stream len =
  let bytes = read_bytes stream len in
  Bytes.to_string bytes

let really_read stream buffer ~pos ~len =
  let rec loop offset remaining =
    if remaining = 0
    then true
    else
      let bytes_read = read stream buffer ~pos:(pos + offset) ~len:remaining in
      if bytes_read = 0
      then false
      else loop (offset + bytes_read) (remaining - bytes_read)
  in
  loop 0 len

let really_read_bigstring stream len =
  let buffer = Bigarray.Array1.create Bigarray.char Bigarray.c_layout len in
  if really_read stream buffer ~pos:0 ~len then Some buffer else None

let really_read_string stream len =
  match really_read_bigstring stream len with
  | Some buffer ->
    let bytes = Bytes.create len in
    for i = 0 to len - 1 do
      Bytes.set_uint8 bytes i (Char.code (Bigarray.Array1.get buffer i))
    done;
    Some (Bytes.to_string bytes)
  | None -> None

let get_memory_base = F.Stream.get_memory_base
