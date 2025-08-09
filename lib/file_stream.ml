module F = Oski_ffi.M

type t = F.File_stream.t

let make = F.File_stream.make
let delete = F.File_stream.delete
let is_valid = F.File_stream.is_valid
let to_stream = F.File_stream.to_stream
let to_native file = file
