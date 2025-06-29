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
    let t_opt = C.ptr_opt T.Stream.t

    (* Management *)
    let delete = foreign "sk_stream_destroy" C.(t @-> returning void)
    let duplicate = foreign "sk_stream_duplicate" C.(t @-> returning t_opt)
    let fork = foreign "sk_stream_fork" C.(t @-> returning t_opt)

    (* Reading data*)
    let read =
      foreign
        "sk_stream_read"
        C.(t @-> ptr void @-> size_t @-> returning size_t)

    let peek =
      foreign
        "sk_stream_peek"
        C.(t @-> ptr void @-> size_t @-> returning size_t)

    let read_s8 =
      foreign "sk_stream_read_s8" C.(t @-> ptr int8_t @-> returning bool)

    let read_s16 =
      foreign "sk_stream_read_s16" C.(t @-> ptr int16_t @-> returning bool)

    let read_s32 =
      foreign "sk_stream_read_s32" C.(t @-> ptr int32_t @-> returning bool)

    let read_u8 =
      foreign "sk_stream_read_u8" C.(t @-> ptr uint8_t @-> returning bool)

    let read_u16 =
      foreign "sk_stream_read_u16" C.(t @-> ptr uint16_t @-> returning bool)

    let read_u32 =
      foreign "sk_stream_read_u32" C.(t @-> ptr uint32_t @-> returning bool)

    let read_bool =
      foreign "sk_stream_read_bool" C.(t @-> ptr bool @-> returning bool)

    (* Position and length *)
    let is_at_end = foreign "sk_stream_is_at_end" C.(t @-> returning bool)
    let has_position = foreign "sk_stream_has_position" C.(t @-> returning bool)

    let get_position =
      foreign "sk_stream_get_position" C.(t @-> returning size_t)

    let has_length = foreign "sk_stream_has_length" C.(t @-> returning bool)
    let get_length = foreign "sk_stream_get_length" C.(t @-> returning int)
  end

  module StreamAsset = struct
    type t = T.Stream.asset C.structure C.ptr

    let t = C.ptr T.Stream.asset
    let delete = foreign "sk_stream_asset_destroy" C.(t @-> returning void)
  end

  module FileStream = struct
    type t = T.Stream.file C.structure C.ptr

    let t = C.ptr T.Stream.file
    let t_opt = C.ptr_opt T.Stream.file
    let make = foreign "sk_filestream_new" C.(string @-> returning t_opt)
    let delete = foreign "sk_filestream_destroy" C.(t @-> returning void)
    let is_valid = foreign "sk_filestream_is_valid" C.(t @-> returning bool)
    let as_stream file = C.coerce t Stream.t file
  end

  module MemoryStream = struct
    type t = T.Stream.memory C.structure C.ptr

    let t = C.ptr T.Stream.memory
    let t_opt = C.ptr_opt T.Stream.memory

    let of_string =
      foreign
        "sk_memorystream_new_with_data"
        C.(string @-> size_t @-> bool @-> returning t_opt)

    let of_bytes =
      foreign
        "sk_memorystream_new_with_data"
        C.(ptr void @-> size_t @-> bool @-> returning t_opt)

    let of_data =
      foreign "sk_memorystream_new_with_skdata" C.(data @-> returning t_opt)

    let delete = foreign "sk_memorystream_destroy" C.(t @-> returning void)
    let as_stream memory = C.coerce t Stream.t memory
  end

  module WStream = struct
    type t = T.Stream.Writable.t C.structure C.ptr

    let t = C.ptr T.Stream.Writable.t

    let write =
      foreign
        "sk_wstream_write"
        C.(t @-> ptr void @-> size_t @-> returning bool)

    let write_string =
      foreign "sk_wstream_write_text" C.(t @-> string @-> returning bool)

    let write_dec_as_text =
      foreign
        "sk_wstream_write_dec_as_text"
        C.(t @-> int32_t @-> returning bool)

    let write_bigdec_as_text =
      foreign
        "sk_wstream_write_bigdec_as_text"
        C.(t @-> int64_t @-> int @-> returning bool)

    let write_hex_as_text =
      foreign
        "sk_wstream_write_hex_as_text"
        C.(t @-> uint32_t @-> int @-> returning bool)

    let write_scalar_as_text =
      foreign
        "sk_wstream_write_scalar_as_text"
        C.(t @-> float @-> returning bool)

    let write_8 =
      foreign "sk_wstream_write_8" C.(t @-> uint8_t @-> returning bool)

    let write_16 =
      foreign "sk_wstream_write_16" C.(t @-> uint16_t @-> returning bool)

    let write_32 =
      foreign "sk_wstream_write_32" C.(t @-> uint32_t @-> returning bool)

    let write_bool =
      foreign "sk_wstream_write_bool" C.(t @-> bool @-> returning bool)

    let write_scalar =
      foreign "sk_wstream_write_scalar" C.(t @-> float @-> returning bool)

    let write_packed_uint =
      foreign "sk_wstream_write_packed_uint" C.(t @-> size_t @-> returning bool)

    let write_stream =
      foreign
        "sk_wstream_write_stream"
        C.(t @-> Stream.t @-> size_t @-> returning bool)

    let newline = foreign "sk_wstream_newline" C.(t @-> returning bool)
    let flush = foreign "sk_wstream_flush" C.(t @-> returning void)

    let bytes_written =
      foreign "sk_wstream_bytes_written" C.(t @-> returning size_t)

    let get_size_of_packed_uint =
      foreign "sk_wstream_get_size_of_packed_uint" C.(size_t @-> returning int)
  end

  module FileWStream = struct
    type t = T.Stream.Writable.file C.structure C.ptr

    let t = C.ptr T.Stream.Writable.file
    let t_opt = C.ptr_opt T.Stream.Writable.file
    let make = foreign "sk_filewstream_new" C.(string @-> returning t_opt)
    let delete = foreign "sk_filewstream_destroy" C.(t @-> returning void)
    let is_valid = foreign "sk_filewstream_is_valid" C.(t @-> returning bool)
    let as_wstream file = C.coerce t WStream.t file
    let as_stream file = C.coerce t Stream.t file
  end

  module DynamicMemoryWStream = struct
    type t = T.Stream.Writable.dynamic_memory C.structure C.ptr

    let t = C.ptr T.Stream.Writable.dynamic_memory
    let t_opt = C.ptr_opt T.Stream.Writable.dynamic_memory

    let make =
      foreign "sk_dynamicmemorywstream_new" C.(void @-> returning t_opt)

    let detach_as_stream =
      foreign
        "sk_dynamicmemorywstream_detach_as_stream"
        C.(t @-> returning StreamAsset.t)

    let detach_as_data =
      foreign "sk_dynamicmemorywstream_detach_as_data" C.(t @-> returning data)

    let copy_to =
      foreign
        "sk_dynamicmemorywstream_copy_to"
        C.(t @-> ptr void @-> returning void)

    let write_to_stream =
      foreign
        "sk_dynamicmemorywstream_write_to_stream"
        C.(t @-> WStream.t @-> returning bool)

    let delete =
      foreign "sk_dynamicmemorywstream_destroy" C.(t @-> returning void)

    let as_wstream memory = C.coerce t WStream.t memory
    let as_stream memory = C.coerce t Stream.t memory
  end

  module Data = struct
    type t = data

    let t = data
    let t_opt = C.ptr_opt T.Data.t
    let of_file = foreign "sk_data_new_from_file" C.(string @-> returning t_opt)

    let of_stream =
      foreign "sk_data_new_from_stream" C.(Stream.t @-> int @-> returning t_opt)

    let new_with_copy =
      foreign "sk_data_new_with_copy" C.(string @-> size_t @-> returning t_opt)

    let new_subset =
      foreign
        "sk_data_new_subset"
        C.(t @-> size_t @-> size_t @-> returning t_opt)

    let ref = foreign "sk_data_ref" C.(t @-> returning void)
    let unref = foreign "sk_data_unref" C.(t @-> returning void)
    let get_size = foreign "sk_data_get_size" C.(t @-> returning size_t)

    let get_data =
      foreign "sk_data_get_data" C.(t @-> returning (ptr (const void)))

    let get_bytes =
      foreign "sk_data_get_bytes" C.(t @-> returning (ptr (const uint8_t)))
  end

  module String = struct
    type t = T.String.t C.structure C.ptr

    let t = C.ptr T.String.t
    let t_opt = C.ptr_opt T.String.t
    let empty = foreign "sk_string_new_empty" C.(void @-> returning t)

    let with_copy =
      foreign
        "sk_string_new_with_copy"
        C.(string @-> size_t @-> returning t_opt)

    let get_size = foreign "sk_string_get_size" C.(t @-> returning size_t)
    let to_string = foreign "sk_string_get_c_str" C.(t @-> returning string)
    let delete = foreign "sk_string_destructor" C.(t @-> returning void)
  end

  module FontStyle = struct
    type t = T.FontStyle.t C.structure C.ptr

    let t = C.ptr T.FontStyle.t

    type slant = T.FontStyle.slant

    let slant = T.FontStyle.slant

    let make =
      foreign "sk_fontstyle_new" C.(int @-> int @-> slant @-> returning t)

    let delete = foreign "sk_fontstyle_delete" C.(t @-> returning void)
    let get_slant = foreign "sk_fontstyle_get_slant" C.(t @-> returning slant)
    let get_weight = foreign "sk_fontstyle_get_width" C.(t @-> returning int)
    let get_height = foreign "sk_fontstyle_get_weight" C.(t @-> returning int)
  end

  module TextEncoding = struct
    type t = T.TextEncoding.t

    let t = T.TextEncoding.t
  end

  module Typeface = struct
    type t = T.Typeface.t C.structure C.ptr

    let t = C.ptr T.Typeface.t
    let t_opt = C.ptr_opt T.Typeface.t

    let get_family_name =
      foreign "sk_typeface_get_family_name" C.(t @-> returning String.t)

    let of_name =
      foreign
        "sk_typeface_create_from_name"
        C.(string @-> FontStyle.t @-> returning t_opt)

    let of_file =
      foreign
        "sk_typeface_create_from_file"
        C.(string @-> int @-> returning t_opt)

    let of_asset =
      foreign
        "sk_typeface_create_from_stream"
        C.(StreamAsset.t @-> int @-> returning t_opt)

    let of_data =
      foreign
        "sk_typeface_create_from_data"
        C.(data @-> int @-> returning t_opt)

    let count_glyphs =
      foreign "sk_typeface_count_glyphs" C.(t @-> returning int)

    let count_tables =
      foreign "sk_typeface_count_tables" C.(t @-> returning int)

    let get_font_style =
      foreign "sk_typeface_get_fontstyle" C.(t @-> returning FontStyle.t)

    let get_font_weight =
      foreign "sk_typeface_get_font_weight" C.(t @-> returning int)

    let get_font_width =
      foreign "sk_typeface_get_font_width" C.(t @-> returning int)

    let get_font_slant =
      foreign "sk_typeface_get_font_slant" C.(t @-> returning FontStyle.slant)
  end

  module FontManager = struct
    type t = T.FontManager.t C.structure C.ptr

    let t = C.ptr T.FontManager.t

    let make_default =
      foreign "sk_fontmgr_create_default" C.(void @-> returning t)

    let match_family_style =
      foreign
        "sk_fontmgr_match_family_style"
        C.(t @-> string @-> FontStyle.t @-> returning Typeface.t_opt)

    let count_families =
      foreign "sk_fontmgr_count_families" C.(t @-> returning int)

    let get_family_name =
      foreign
        "sk_fontmgr_get_family_name"
        C.(t @-> int @-> String.t @-> returning void)

    let match_familt_style_character =
      foreign
        "sk_fontmgr_match_family_style_character"
        C.(
          t
          @-> string
          @-> FontStyle.t
          @-> ptr string
          @-> int
          @-> int32_t
          @-> returning Typeface.t_opt)

    let unref = foreign "sk_fontmgr_unref" C.(t @-> returning void)
  end
end
