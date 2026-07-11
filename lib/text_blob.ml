type t = Oski_ffi.M.Text_blob.t

external to_native : t -> Oski_ffi.M.Text_blob.t = "%identity"
