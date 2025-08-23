module F = Oski_ffi.M

type t = F.Stream_asset.t

let delete = F.Stream_asset.delete
let to_stream asset = Ctypes.coerce F.Stream_asset.t F.Stream.t asset
let to_native asset = asset
