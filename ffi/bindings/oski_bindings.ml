module T = Oski_types.M

module M (F : Ctypes.FOREIGN) = struct
  let foreign = F.foreign

  module C = struct
    include Ctypes

    let ( @-> ) = F.( @-> )
    let returning = F.returning
  end

  module Color = struct
    type t = Unsigned.uint32

    let t = C.uint32_t

    let set_argb =
      foreign
        "sk_color_set_argb"
        C.(uint32_t @-> uint32_t @-> uint32_t @-> uint32_t @-> returning t)
  end

  type data = T.Data.t C.structure C.ptr

  let data = C.ptr T.Data.t

  module Stream = struct
    type t = T.Stream.t C.structure C.ptr

    let t = C.ptr T.Stream.t
    let has_length = foreign "sk_stream_has_length" C.(t @-> returning bool)
    let get_length = foreign "sk_stream_get_length" C.(t @-> returning int)
    let delete = foreign "sk_stream_destroy" C.(t @-> returning void)

    module File = struct
      type t = T.Stream.file C.structure C.ptr

      let t = C.ptr T.Stream.file
      let t_opt = C.ptr_opt T.Stream.file

      let make_file_stream =
        foreign "sk_filestream_new" C.(string @-> returning t_opt)

      let delete_file_stream =
        foreign "sk_filestream_destroy" C.(t @-> returning void)

      let is_valid = foreign "sk_filestream_is_valid" C.(t @-> returning bool)
    end
  end
end
