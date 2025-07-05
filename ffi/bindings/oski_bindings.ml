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

  type data = T.Data.t C.ptr

  let data = C.ptr T.Data.t

  module Stream = struct
    type t = T.Stream.t C.ptr

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
    type t = T.Stream.asset C.ptr

    let t = C.ptr T.Stream.asset
    let delete = foreign "sk_stream_asset_destroy" C.(t @-> returning void)
  end

  module FileStream = struct
    type t = T.Stream.file C.ptr

    let t = C.ptr T.Stream.file
    let t_opt = C.ptr_opt T.Stream.file
    let make = foreign "sk_filestream_new" C.(string @-> returning t_opt)
    let delete = foreign "sk_filestream_destroy" C.(t @-> returning void)
    let is_valid = foreign "sk_filestream_is_valid" C.(t @-> returning bool)
    let as_stream file = C.coerce t Stream.t file
  end

  module MemoryStream = struct
    type t = T.Stream.memory C.ptr

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
    type t = T.Stream.Writable.t C.ptr

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
    type t = T.Stream.Writable.file C.ptr

    let t = C.ptr T.Stream.Writable.file
    let t_opt = C.ptr_opt T.Stream.Writable.file
    let make = foreign "sk_filewstream_new" C.(string @-> returning t_opt)
    let delete = foreign "sk_filewstream_destroy" C.(t @-> returning void)
    let is_valid = foreign "sk_filewstream_is_valid" C.(t @-> returning bool)
    let as_wstream file = C.coerce t WStream.t file
    let as_stream file = C.coerce t Stream.t file
  end

  module DynamicMemoryWStream = struct
    type t = T.Stream.Writable.dynamic_memory C.ptr

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
    type t = T.String.t C.ptr

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
    type t = T.FontStyle.t C.ptr

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
    type t = T.Typeface.t C.ptr

    let t = C.ptr T.Typeface.t
    let t_opt = C.ptr_opt T.Typeface.t

    type id = T.Typeface.id

    let id = T.Typeface.id

    type font_table_tag = T.Typeface.font_table_tag

    let font_table_tag = T.Typeface.font_table_tag

    let get_unique_id =
      foreign "oski_typeface_get_unique_id" C.(t @-> returning T.Typeface.id)

    let equal = foreign "oski_typeface_equal" C.(t @-> t @-> returning bool)

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

    let unichars_to_glyphs =
      foreign
        "sk_typeface_unichars_to_glyphs"
        C.(t @-> ptr int32_t @-> int @-> ptr uint16_t @-> returning void)

    let unichar_to_glyph =
      foreign
        "sk_typeface_unichar_to_glyph"
        C.(t @-> int32_t @-> returning uint16_t)

    let count_glyphs =
      foreign "sk_typeface_count_glyphs" C.(t @-> returning int)

    let count_tables =
      foreign "sk_typeface_count_tables" C.(t @-> returning int)

    let get_table_tags =
      foreign
        "sk_typeface_get_table_tags"
        C.(t @-> ptr font_table_tag @-> returning int)

    let get_table_size =
      foreign
        "sk_typeface_get_table_size"
        C.(t @-> font_table_tag @-> returning size_t)

    let get_table_data =
      foreign
        "sk_typeface_get_table_data"
        C.(
          t
          @-> font_table_tag
          @-> size_t
          @-> size_t
          @-> ptr void
          @-> returning size_t)

    let copy_table_data =
      foreign
        "sk_typeface_copy_table_data"
        C.(t @-> font_table_tag @-> returning Data.t_opt)

    let get_font_style =
      foreign "sk_typeface_get_fontstyle" C.(t @-> returning FontStyle.t)

    let get_font_weight =
      foreign "sk_typeface_get_font_weight" C.(t @-> returning int)

    let get_font_width =
      foreign "sk_typeface_get_font_width" C.(t @-> returning int)

    let get_font_slant =
      foreign "sk_typeface_get_font_slant" C.(t @-> returning FontStyle.slant)

    let get_units_per_em =
      foreign "sk_typeface_get_units_per_em" C.(t @-> returning int)

    let get_kerning_pair_adjustments =
      foreign
        "sk_typeface_get_kerning_pair_adjustments"
        C.(
          t @-> const (ptr uint16_t) @-> int @-> ptr int32_t @-> returning bool)

    let open_stream =
      foreign
        "sk_typeface_open_stream"
        C.(t @-> ptr_opt int @-> returning (ptr_opt T.Stream.asset))
  end

  module FontStyleSet = struct
    type t = T.FontStyle.set C.ptr

    let t = C.ptr T.FontStyle.set
    let t_opt = C.ptr_opt T.FontStyle.set
    let unref = foreign "sk_fontstyleset_unref" C.(t @-> returning void)
    let get_count = foreign "sk_fontstyleset_get_count" C.(t @-> returning int)

    let get_style =
      foreign
        "sk_fontstyleset_get_style"
        C.(t @-> int @-> FontStyle.t @-> String.t @-> returning void)

    let make_typeface =
      foreign
        "sk_fontstyleset_create_typeface"
        C.(t @-> int @-> returning Typeface.t_opt)

    let match_style =
      foreign
        "sk_fontstyleset_match_style"
        C.(t @-> FontStyle.t @-> returning Typeface.t_opt)
  end

  module FontManager = struct
    type t = T.FontManager.t C.ptr

    let t = C.ptr T.FontManager.t

    let make_default =
      foreign "sk_fontmgr_create_default" C.(void @-> returning t)

    let ref_default = foreign "sk_fontmgr_ref_default" C.(void @-> returning t)

    let make_styleset =
      foreign
        "sk_fontmgr_create_styleset"
        C.(t @-> int @-> returning FontStyleSet.t_opt)

    let match_family =
      foreign
        "sk_fontmgr_match_family"
        C.(t @-> string @-> returning FontStyleSet.t_opt)

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

    let match_family_style_character =
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

    let of_data =
      foreign
        "sk_fontmgr_create_from_data"
        C.(t @-> Data.t @-> int @-> returning Typeface.t_opt)

    let of_stream =
      foreign
        "sk_fontmgr_create_from_stream"
        C.(t @-> StreamAsset.t @-> int @-> returning Typeface.t_opt)

    let of_file =
      foreign
        "sk_fontmgr_create_from_file"
        C.(t @-> string @-> int @-> returning Typeface.t_opt)

    let unref = foreign "sk_fontmgr_unref" C.(t @-> returning void)
  end

  module FontMetrics = struct
    type t = T.FontMetrics.t C.ptr

    let t = C.ptr T.FontMetrics.t
    let get_make () = C.allocate_n ~count:1 T.FontMetrics.t
    let get_ascent m = C.(getf !@m T.FontMetrics.ascent)
    let get_descent m = C.(getf !@m T.FontMetrics.descent)
    let get_bottom m = C.(getf !@m T.FontMetrics.bottom)
    let get_leading m = C.(getf !@m T.FontMetrics.leading)
    let get_avg_char_width m = C.(getf !@m T.FontMetrics.avg_char_width)
    let get_max_char_width m = C.(getf !@m T.FontMetrics.max_char_width)
    let get_xmin m = C.(getf !@m T.FontMetrics.xmin)
    let get_xmax m = C.(getf !@m T.FontMetrics.xmax)
    let get_xheight m = C.(getf !@m T.FontMetrics.xheight)
    let get_cap_height m = C.(getf !@m T.FontMetrics.cap_height)

    let get_underline_thickness m =
      C.(getf !@m T.FontMetrics.underline_thickness)

    let get_underline_position m = C.(getf !@m T.FontMetrics.underline_position)

    let get_strikeout_thickness m =
      C.(getf !@m T.FontMetrics.strikeout_thickness)

    let get_strikeout_position m = C.(getf !@m T.FontMetrics.strikeout_position)
  end

  module Blender = struct
    type t = T.Blender.t C.ptr

    let t = C.ptr T.Blender.t
    let t_opt = C.ptr_opt T.Blender.t

    let of_mode =
      foreign "sk_blender_new_mode" C.(T.Blendmode.t @-> returning t_opt)

    let of_arithmetic =
      foreign
        "sk_blender_new_arithmetic"
        C.(float @-> float @-> float @-> float @-> bool @-> returning t_opt)
  end

  module Point = struct
    type t = T.Point.t C.ptr

    let t = C.ptr T.Point.t

    let make x y =
      let point = C.allocate_n T.Point.t ~count:1 in
      C.(setf !@point T.Point.x x);
      C.(setf !@point T.Point.y y);
      point

    let get_x point = C.(getf !@point T.Point.x)
    let get_y point = C.(getf !@point T.Point.y)
  end

  module Vector = struct
    type t = T.Vector.t C.ptr

    let t = C.ptr T.Vector.t

    let make x y =
      let vector = C.allocate_n T.Vector.t ~count:1 in
      C.(setf !@vector T.Vector.x x);
      C.(setf !@vector T.Vector.y y);
      vector

    let get_x vector = C.(getf !@vector T.Vector.x)
    let get_y vector = C.(getf !@vector T.Vector.y)
  end

  module Shader = struct
    type t = T.Shader.t C.ptr

    let t = C.ptr T.Shader.t

    type tile_mode = T.Shader.tile_mode

    let tile_mode = T.Shader.tile_mode
    let ref = foreign "sk_shader_ref" C.(t @-> returning void)
    let unref = foreign "sk_shader_unref" C.(t @-> returning void)
    let of_empty = foreign "sk_shader_new_empty" C.(void @-> returning t)
    let of_color = foreign "sk_shader_new_color" C.(Color.t @-> returning t)

    let of_linear_gradient2 =
      foreign
        "oski_stub_linear_gradient2"
        C.(
          Point.t
          @-> Point.t
          @-> Color.t
          @-> Color.t
          @-> tile_mode
          @-> returning t)

    let of_linear_gradient =
      foreign
        "oski_stub_linear_gradient"
        C.(
          Point.t
          @-> Point.t
          @-> ptr Color.t
          @-> ptr float
          @-> int
          @-> tile_mode
          @-> returning t)
  end

  module ImageFilter = struct
    type t = T.ImageFilter.t C.ptr

    let t = C.ptr T.ImageFilter.t
    let unref = foreign "sk_imagefilter_unref" C.(t @-> returning void)
  end

  module Rect = struct
    type t = T.Rect.t C.ptr

    let t = C.ptr T.Rect.t

    let of_ltrb ?(left = 0.) ?(top = 0.) ?(right = 0.) ?(bottom = 0.) () =
      let rect = C.allocate_n T.Rect.t ~count:1 in
      C.(setf !@rect T.Rect.left left);
      C.(setf !@rect T.Rect.top top);
      C.(setf !@rect T.Rect.right bottom);
      C.(setf !@rect T.Rect.bottom right);
      rect

    let of_empty () = of_ltrb ()
    let get_left rect = C.(getf !@rect T.Rect.left)
    let get_top rect = C.(getf !@rect T.Rect.top)
    let get_right rect = C.(getf !@rect T.Rect.right)
    let get_bottom rect = C.(getf !@rect T.Rect.bottom)

    let set_ltrb =
      foreign
        "oski_stub_rect_set"
        C.(t @-> float @-> float @-> float @-> float @-> returning void)
  end

  module Matrix = struct
    type t = T.Matrix.t C.ptr

    let t = C.ptr T.Matrix.t
    let make () = C.allocate_n T.Matrix.t ~count:1

    let set_all
          matrix
          scaleX
          skewX
          transX
          skewY
          scaleY
          transY
          persp0
          persp1
          persp2
      =
      C.(
        setf !@matrix T.Matrix.scaleX scaleX;
        setf !@matrix T.Matrix.skewX skewX;
        setf !@matrix T.Matrix.transX transX;
        setf !@matrix T.Matrix.skewY skewY;
        setf !@matrix T.Matrix.scaleY scaleY;
        setf !@matrix T.Matrix.transY transY;
        setf !@matrix T.Matrix.persp0 persp0;
        setf !@matrix T.Matrix.persp1 persp1;
        setf !@matrix T.Matrix.persp2 persp2)

    let get_scaleX matrix = C.(getf !@matrix T.Matrix.scaleX)
    let get_skewX matrix = C.(getf !@matrix T.Matrix.skewX)
    let get_transx matrix = C.(getf !@matrix T.Matrix.transX)
    let get_skewY matrix = C.(getf !@matrix T.Matrix.skewY)
    let get_scaleY matrix = C.(getf !@matrix T.Matrix.scaleY)
    let get_transY matrix = C.(getf !@matrix T.Matrix.transY)
    let get_persp0 matrix = C.(getf !@matrix T.Matrix.persp0)
    let get_persp1 matrix = C.(getf !@matrix T.Matrix.persp1)
    let get_persp2 matrix = C.(getf !@matrix T.Matrix.persp2)

    let try_invert =
      foreign "sk_matrix_try_invert" C.(t @-> t @-> returning bool)

    let concat = foreign "sk_matrix_concat" C.(t @-> t @-> t @-> returning void)

    let pre_concat =
      foreign "sk_matrix_pre_concat" C.(t @-> t @-> returning void)

    let post_concat =
      foreign "sk_matrix_post_concat" C.(t @-> t @-> returning void)

    let map_rect =
      foreign
        "sk_matrix_map_rect"
        C.(t @-> Rect.t @-> Rect.t @-> returning void)

    let map_points =
      foreign
        "sk_matrix_map_points"
        C.(t @-> Point.t @-> Point.t @-> int @-> returning void)

    let map_vectors =
      foreign
        "sk_matrix_map_vectors"
        C.(t @-> Point.t @-> Point.t @-> int @-> returning void)

    let map_xy =
      foreign
        "sk_matrix_map_xy"
        C.(t @-> float @-> float @-> Point.t @-> returning void)

    let map_vector =
      foreign
        "sk_matrix_map_vector"
        C.(t @-> float @-> float @-> Point.t @-> returning void)

    let map_radius =
      foreign "sk_matrix_map_radius" C.(t @-> float @-> returning float)
  end

  module RRect = struct
    type t = T.RRect.t C.ptr

    let t = C.ptr T.RRect.t

    type type_ = T.RRect.type_

    let type_ = T.RRect.type_

    type corner = T.RRect.corner

    let corner = T.RRect.corner
    let make = foreign "sk_rrect_new" C.(void @-> returning t)
    let copy = foreign "sk_rrect_new_copy" C.(t @-> returning t)
    let delete = foreign "sk_rrect_delete" C.(t @-> returning void)
    let get_type = foreign "sk_rrect_get_type" C.(const t @-> returning type_)

    let get_rect =
      foreign "sk_rrect_get_rect" C.(const t @-> Rect.t @-> returning void)

    let get_radii =
      foreign
        "sk_rrect_get_radii"
        C.(const t @-> corner @-> Vector.t @-> returning void)

    let get_width = foreign "sk_rrect_get_width" C.(const t @-> returning float)

    let get_height =
      foreign "sk_rrect_get_height" C.(const t @-> returning float)

    let set_empty = foreign "sk_rrect_set_empty" C.(t @-> returning void)

    let set_rect =
      foreign "sk_rrect_set_rect" C.(t @-> const Rect.t @-> returning void)

    let set_oval =
      foreign "sk_rrect_set_oval" C.(t @-> const Rect.t @-> returning void)

    let set_rect_xy =
      foreign
        "sk_rrect_set_rect_xy"
        C.(t @-> const Rect.t @-> float @-> float @-> returning void)

    let set_nine_patch =
      foreign
        "sk_rrect_set_nine_patch"
        C.(
          t
          @-> const Rect.t
          @-> float
          @-> float
          @-> float
          @-> float
          @-> returning void)

    let set_rect_radii =
      foreign
        "sk_rrect_set_rect_radii"
        C.(t @-> const Rect.t @-> const Vector.t @-> returning void)

    let inset =
      foreign "sk_rrect_inset" C.(t @-> float @-> float @-> returning void)

    let outset =
      foreign "sk_rrect_outset" C.(t @-> float @-> float @-> returning void)

    let offset =
      foreign "sk_rrect_offset" C.(t @-> float @-> float @-> returning void)

    let contains =
      foreign
        "sk_rrect_contains"
        C.(const t @-> const Rect.t @-> returning bool)

    let is_valid = foreign "sk_rrect_is_valid" C.(const t @-> returning bool)

    let transform =
      foreign
        "sk_rrect_transform"
        C.(t @-> const Matrix.t @-> t @-> returning bool)
  end

  module Path = struct
    type t = T.Path.t C.ptr

    let t = C.ptr T.Path.t
    let make = foreign "sk_path_new" C.(void @-> returning t)
    let delete = foreign "sk_path_delete" C.(t @-> returning void)

    type direction = T.Path.direction

    let direction = T.Path.direction

    type arc_size = T.Path.arc_size

    let arc_size = T.Path.arc_size

    type fill_type = T.Path.fill_type

    let fill_type = T.Path.fill_type

    type add_mode = T.Path.add_mode

    let add_mode = T.Path.add_mode

    type verb = T.Path.verb

    let verb = T.Path.verb

    let move_to =
      foreign "sk_path_move_to" C.(t @-> float @-> float @-> returning void)

    let line_to =
      foreign "sk_path_line_to" C.(t @-> float @-> float @-> returning void)

    let quad_to =
      foreign
        "sk_path_quad_to"
        C.(t @-> float @-> float @-> float @-> float @-> returning void)

    let conic_to =
      foreign
        "sk_path_conic_to"
        C.(
          t @-> float @-> float @-> float @-> float @-> float @-> returning void)

    let cubic_to =
      foreign
        "sk_path_cubic_to"
        C.(
          t
          @-> float
          @-> float
          @-> float
          @-> float
          @-> float
          @-> float
          @-> returning void)

    let arc_to =
      foreign
        "sk_path_arc_to"
        C.(
          t
          @-> float
          @-> float
          @-> float
          @-> arc_size
          @-> direction
          @-> float
          @-> float
          @-> returning void)

    let rarc_to =
      foreign
        "sk_path_rarc_to"
        C.(
          t
          @-> float
          @-> float
          @-> float
          @-> arc_size
          @-> direction
          @-> float
          @-> float
          @-> returning void)

    let arc_to_with_oval =
      foreign
        "sk_path_arc_to_with_oval"
        C.(t @-> Rect.t @-> float @-> float @-> bool @-> returning void)

    let arc_to_with_points =
      foreign
        "sk_path_arc_to_with_points"
        C.(
          t @-> float @-> float @-> float @-> float @-> float @-> returning void)

    let close = foreign "sk_path_close" C.(t @-> returning void)

    let add_rect =
      foreign
        "sk_path_add_rect"
        C.(t @-> const Rect.t @-> direction @-> returning void)

    let add_rrect =
      foreign
        "sk_path_add_rrect"
        C.(t @-> const RRect.t @-> direction @-> returning void)

    let add_rrect_start =
      foreign
        "sk_path_add_rrect_start"
        C.(t @-> const RRect.t @-> direction @-> uint32_t @-> returning void)

    let add_rounded_rect =
      foreign
        "sk_path_add_rounded_rect"
        C.(
          t
          @-> const Rect.t
          @-> float
          @-> float
          @-> direction
          @-> returning void)

    let add_oval =
      foreign
        "sk_path_add_oval"
        C.(t @-> const Rect.t @-> direction @-> returning void)

    let add_circle =
      foreign
        "sk_path_add_circle"
        C.(t @-> float @-> float @-> float @-> direction @-> returning void)

    let get_bounds =
      foreign "sk_path_get_bounds" C.(const t @-> Rect.t @-> returning void)

    let compute_tight_bounds =
      foreign
        "sk_path_compute_tight_bounds"
        C.(const t @-> Rect.t @-> returning void)

    let rmove_to =
      foreign "sk_path_rmove_to" C.(t @-> float @-> float @-> returning void)

    let rline_to =
      foreign "sk_path_rline_to" C.(t @-> float @-> float @-> returning void)

    let rquad_to =
      foreign
        "sk_path_rquad_to"
        C.(t @-> float @-> float @-> float @-> float @-> returning void)

    let rconic_to =
      foreign
        "sk_path_rconic_to"
        C.(
          t @-> float @-> float @-> float @-> float @-> float @-> returning void)

    let rcubic_to =
      foreign
        "sk_path_rcubic_to"
        C.(
          t
          @-> float
          @-> float
          @-> float
          @-> float
          @-> float
          @-> float
          @-> returning void)

    let add_rect_start =
      foreign
        "sk_path_add_rect_start"
        C.(t @-> const Rect.t @-> direction @-> uint32_t @-> returning void)

    let add_arc =
      foreign
        "sk_path_add_arc"
        C.(t @-> const Rect.t @-> float @-> float @-> returning void)

    let get_fill_type =
      foreign "sk_path_get_filltype" C.(const t @-> returning fill_type)

    let set_fill_type =
      foreign "sk_path_set_filltype" C.(t @-> fill_type @-> returning void)

    let transform =
      foreign "sk_path_transform" C.(t @-> const Matrix.t @-> returning void)

    let transform_to =
      foreign
        "sk_path_transform_to_dest"
        C.(const t @-> const Matrix.t @-> t @-> returning void)

    let clone = foreign "sk_path_clone" C.(const t @-> returning t)

    let add_path_offset =
      foreign
        "sk_path_add_path_offset"
        C.(t @-> t @-> float @-> float @-> add_mode @-> returning void)

    let add_path_matrix =
      foreign
        "sk_path_add_path_matrix"
        C.(t @-> t @-> Matrix.t @-> add_mode @-> returning void)

    let add_path =
      foreign "sk_path_add_path" C.(t @-> t @-> add_mode @-> returning void)

    let add_path_reverse =
      foreign "sk_path_add_path_reverse" C.(t @-> t @-> returning void)

    let reset = foreign "sk_path_reset" C.(t @-> returning void)
    let rewind = foreign "sk_path_rewind" C.(t @-> returning void)
    let count_points = foreign "sk_path_count_points" C.(t @-> returning int)
    let count_verbs = foreign "sk_path_count_verbs" C.(t @-> returning int)

    let get_point =
      foreign
        "sk_path_get_point"
        C.(const t @-> int @-> Point.t @-> returning void)

    let get_points =
      foreign
        "sk_path_get_points"
        C.(const t @-> Point.t @-> int @-> returning int)

    let contains =
      foreign
        "sk_path_contains"
        C.(const t @-> float @-> float @-> returning bool)

    let parse_svg_string =
      foreign "sk_path_parse_svg_string" C.(t @-> string @-> returning bool)

    let to_svg_string =
      foreign
        "sk_path_to_svg_string"
        C.(const t @-> String.t @-> returning void)

    let get_last_point =
      foreign
        "sk_path_get_last_point"
        C.(const t @-> Point.t @-> returning bool)

    let convert_conic_to_quads =
      foreign
        "sk_path_convert_conic_to_quads"
        C.(
          const Point.t
          @-> const Point.t
          @-> const Point.t
          @-> float
          @-> Point.t
          @-> int
          @-> returning int)

    let add_poly =
      foreign
        "sk_path_add_poly"
        C.(t @-> const Point.t @-> int @-> bool @-> returning void)

    let get_segment_masks =
      foreign "sk_path_get_segment_masks" C.(t @-> returning uint32_t)

    let is_oval = foreign "sk_path_is_oval" C.(t @-> Rect.t @-> returning bool)

    let is_rrect =
      foreign "sk_path_is_rrect" C.(t @-> RRect.t @-> returning bool)

    let is_line = foreign "sk_path_is_line" C.(t @-> Point.t @-> returning bool)

    let is_rect =
      foreign
        "sk_path_is_rect"
        C.(t @-> Rect.t @-> ptr bool @-> ptr direction @-> returning bool)

    let is_convex = foreign "sk_path_is_convex" C.(t @-> returning bool)
  end

  module PathIterator = struct
    type t = T.Path.iterator C.ptr

    let t = C.ptr T.Path.iterator

    let make =
      foreign
        "sk_path_create_iter"
        C.(Path.t @-> int @-> returning (C.ptr_opt T.Path.iterator))

    let delete = foreign "sk_path_iter_destroy" C.(t @-> returning void)

    let next =
      foreign "sk_path_iter_next" C.(t @-> Point.t @-> returning Path.verb)

    let conic_weight =
      foreign "sk_path_iter_conic_weight" C.(t @-> returning float)

    let is_close_line =
      foreign "sk_path_iter_is_close_line" C.(t @-> returning bool)

    let is_closed_contour =
      foreign "sk_path_iter_is_closed_contour" C.(t @-> returning bool)
  end

  module PathOp = struct
    type t = T.Path.op

    let t = T.Path.op

    let op =
      foreign
        "sk_pathop_op"
        C.(const Path.t @-> const Path.t @-> t @-> Path.t @-> returning bool)

    let simplify =
      foreign
        "sk_pathop_simplify"
        C.(const Path.t @-> Path.t @-> returning bool)

    let tight_bounds =
      foreign
        "sk_pathop_tight_bounds"
        C.(const Path.t @-> Rect.t @-> returning bool)

    let as_winding =
      foreign
        "sk_pathop_as_winding"
        C.(const Path.t @-> Path.t @-> returning bool)

    module Builder = struct
      type t = T.Path.op_builder C.ptr

      let t = C.ptr T.Path.op_builder
      let make = foreign "sk_opbuilder_new" C.(void @-> returning t)
      let destroy = foreign "sk_opbuilder_destroy" C.(t @-> returning void)

      let add =
        foreign
          "sk_opbuilder_add"
          C.(t @-> const Path.t @-> T.Path.op @-> returning void)

      let resolve =
        foreign "sk_opbuilder_resolve" C.(t @-> Path.t @-> returning bool)
    end
  end

  module PathMeasure = struct
    type t = T.PathMeasure.t C.ptr

    let t = C.ptr T.PathMeasure.t
    let t_opt = C.ptr_opt T.PathMeasure.t

    type matrix_flags = T.PathMeasure.matrix_flags

    let matrix_flags = T.PathMeasure.matrix_flags
    let make = foreign "sk_pathmeasure_new" C.(void @-> returning t_opt)

    let of_path =
      foreign
        "sk_pathmeasure_new_with_path"
        C.(const Path.t @-> bool @-> float @-> returning t_opt)

    let delete = foreign "sk_pathmeasure_destroy" C.(t @-> returning void)

    let set_path =
      foreign
        "sk_pathmeasure_set_path"
        C.(t @-> const Path.t @-> bool @-> returning void)

    let get_length =
      foreign "sk_pathmeasure_get_length" C.(t @-> returning float)

    let get_pos_tan =
      foreign
        "sk_pathmeasure_get_pos_tan"
        C.(t @-> float @-> Point.t @-> Vector.t @-> returning bool)

    let get_matrix =
      foreign
        "sk_pathmeasure_get_matrix"
        C.(t @-> float @-> Matrix.t @-> matrix_flags @-> returning bool)

    let get_segment =
      foreign
        "sk_pathmeasure_get_segment"
        C.(t @-> float @-> float @-> Path.t @-> bool @-> returning bool)

    let is_closed = foreign "sk_pathmeasure_is_closed" C.(t @-> returning bool)

    let next_contour =
      foreign "sk_pathmeasure_next_contour" C.(t @-> returning bool)
  end
end
