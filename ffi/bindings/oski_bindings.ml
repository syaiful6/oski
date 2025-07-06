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
        C.(uint8_t @-> uint8_t @-> uint8_t @-> uint8_t @-> returning t)

    let get_alpha = foreign "sk_color_get_a" C.(t @-> returning uint8_t)
    let get_red = foreign "sk_color_get_r" C.(t @-> returning uint8_t)
    let get_green = foreign "sk_color_get_g" C.(t @-> returning uint8_t)
    let get_blue = foreign "sk_color_get_b" C.(t @-> returning uint8_t)

    let hsv_to_color =
      foreign "oski_color_hsv_to_color" C.(uint @-> ptr float @-> returning t)

    let rgb_to_hsv =
      foreign
        "oski_color_rgb_to_hsv"
        C.(uint @-> uint @-> uint @-> ptr float @-> returning void)
  end

  module Color4f = struct
    type t = T.Color4f.t C.ptr

    let t = C.ptr T.Color4f.t
    let to_color = foreign "sk_color4f_to_color" C.(t @-> returning Color.t)

    let of_color =
      foreign "sk_color4f_from_color" C.(Color.t @-> t @-> returning void)
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

  module Stream_asset = struct
    type t = T.Stream.asset C.ptr

    let t = C.ptr T.Stream.asset
    let delete = foreign "sk_stream_asset_destroy" C.(t @-> returning void)
  end

  module File_stream = struct
    type t = T.Stream.file C.ptr

    let t = C.ptr T.Stream.file
    let t_opt = C.ptr_opt T.Stream.file
    let make = foreign "sk_filestream_new" C.(string @-> returning t_opt)
    let delete = foreign "sk_filestream_destroy" C.(t @-> returning void)
    let is_valid = foreign "sk_filestream_is_valid" C.(t @-> returning bool)
    let as_stream file = C.coerce t Stream.t file
  end

  module Memory_stream = struct
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

  module File_wstream = struct
    type t = T.Stream.Writable.file C.ptr

    let t = C.ptr T.Stream.Writable.file
    let t_opt = C.ptr_opt T.Stream.Writable.file
    let make = foreign "sk_filewstream_new" C.(string @-> returning t_opt)
    let delete = foreign "sk_filewstream_destroy" C.(t @-> returning void)
    let is_valid = foreign "sk_filewstream_is_valid" C.(t @-> returning bool)
    let as_wstream file = C.coerce t WStream.t file
    let as_stream file = C.coerce t Stream.t file
  end

  module Dynamic_memory_wstream = struct
    type t = T.Stream.Writable.dynamic_memory C.ptr

    let t = C.ptr T.Stream.Writable.dynamic_memory
    let t_opt = C.ptr_opt T.Stream.Writable.dynamic_memory

    let make =
      foreign "sk_dynamicmemorywstream_new" C.(void @-> returning t_opt)

    let detach_as_stream =
      foreign
        "sk_dynamicmemorywstream_detach_as_stream"
        C.(t @-> returning Stream_asset.t)

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

  module Font_style = struct
    type t = T.Font_style.t C.ptr

    let t = C.ptr T.Font_style.t

    type slant = T.Font_style.slant

    let slant = T.Font_style.slant

    let make =
      foreign "sk_fontstyle_new" C.(int @-> int @-> slant @-> returning t)

    let delete = foreign "sk_fontstyle_delete" C.(t @-> returning void)
    let get_slant = foreign "sk_fontstyle_get_slant" C.(t @-> returning slant)
    let get_weight = foreign "sk_fontstyle_get_width" C.(t @-> returning int)
    let get_height = foreign "sk_fontstyle_get_weight" C.(t @-> returning int)
  end

  module Text_encoding = struct
    type t = T.Text_encoding.t

    let t = T.Text_encoding.t
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
        C.(string @-> Font_style.t @-> returning t_opt)

    let of_file =
      foreign
        "sk_typeface_create_from_file"
        C.(string @-> int @-> returning t_opt)

    let of_asset =
      foreign
        "sk_typeface_create_from_stream"
        C.(Stream_asset.t @-> int @-> returning t_opt)

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
      foreign "sk_typeface_get_fontstyle" C.(t @-> returning Font_style.t)

    let get_font_weight =
      foreign "sk_typeface_get_font_weight" C.(t @-> returning int)

    let get_font_width =
      foreign "sk_typeface_get_font_width" C.(t @-> returning int)

    let get_font_slant =
      foreign "sk_typeface_get_font_slant" C.(t @-> returning Font_style.slant)

    let get_units_per_em =
      foreign "sk_typeface_get_units_per_em" C.(t @-> returning int)

    let get_kerning_pair_adjustments =
      foreign
        "sk_typeface_get_kerning_pair_adjustments"
        C.(t @-> ptr uint16_t @-> int @-> ptr int32_t @-> returning bool)

    let open_stream =
      foreign
        "sk_typeface_open_stream"
        C.(t @-> ptr_opt int @-> returning (ptr_opt T.Stream.asset))
  end

  module Font_style_set = struct
    type t = T.Font_style.set C.ptr

    let t = C.ptr T.Font_style.set
    let t_opt = C.ptr_opt T.Font_style.set
    let unref = foreign "sk_fontstyleset_unref" C.(t @-> returning void)
    let get_count = foreign "sk_fontstyleset_get_count" C.(t @-> returning int)

    let get_style =
      foreign
        "sk_fontstyleset_get_style"
        C.(t @-> int @-> Font_style.t @-> String.t @-> returning void)

    let make_typeface =
      foreign
        "sk_fontstyleset_create_typeface"
        C.(t @-> int @-> returning Typeface.t_opt)

    let match_style =
      foreign
        "sk_fontstyleset_match_style"
        C.(t @-> Font_style.t @-> returning Typeface.t_opt)
  end

  module Font_manager = struct
    type t = T.Font_manager.t C.ptr

    let t = C.ptr T.Font_manager.t

    let make_default =
      foreign "sk_fontmgr_create_default" C.(void @-> returning t)

    let ref_default = foreign "sk_fontmgr_ref_default" C.(void @-> returning t)

    let make_styleset =
      foreign
        "sk_fontmgr_create_styleset"
        C.(t @-> int @-> returning Font_style_set.t_opt)

    let match_family =
      foreign
        "sk_fontmgr_match_family"
        C.(t @-> string @-> returning Font_style_set.t_opt)

    let match_family_style =
      foreign
        "sk_fontmgr_match_family_style"
        C.(t @-> string @-> Font_style.t @-> returning Typeface.t_opt)

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
          @-> Font_style.t
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
        C.(t @-> Stream_asset.t @-> int @-> returning Typeface.t_opt)

    let of_file =
      foreign
        "sk_fontmgr_create_from_file"
        C.(t @-> string @-> int @-> returning Typeface.t_opt)

    let unref = foreign "sk_fontmgr_unref" C.(t @-> returning void)
  end

  module Font_metrics = struct
    type t = T.Font_metrics.t C.ptr

    let t = C.ptr T.Font_metrics.t
    let get_make () = C.allocate_n ~count:1 T.Font_metrics.t
    let get_ascent m = C.(getf !@m T.Font_metrics.ascent)
    let get_descent m = C.(getf !@m T.Font_metrics.descent)
    let get_bottom m = C.(getf !@m T.Font_metrics.bottom)
    let get_leading m = C.(getf !@m T.Font_metrics.leading)
    let get_avg_char_width m = C.(getf !@m T.Font_metrics.avg_char_width)
    let get_max_char_width m = C.(getf !@m T.Font_metrics.max_char_width)
    let get_xmin m = C.(getf !@m T.Font_metrics.xmin)
    let get_xmax m = C.(getf !@m T.Font_metrics.xmax)
    let get_xheight m = C.(getf !@m T.Font_metrics.xheight)
    let get_cap_height m = C.(getf !@m T.Font_metrics.cap_height)

    let get_underline_thickness m =
      C.(getf !@m T.Font_metrics.underline_thickness)

    let get_underline_position m =
      C.(getf !@m T.Font_metrics.underline_position)

    let get_strikeout_thickness m =
      C.(getf !@m T.Font_metrics.strikeout_thickness)

    let get_strikeout_position m =
      C.(getf !@m T.Font_metrics.strikeout_position)
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

  module Image_filter = struct
    type t = T.Image_filter.t C.ptr

    let t = C.ptr T.Image_filter.t
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

    let of_xywh ~left ~top ~width ~height () =
      of_ltrb ~left ~top ~right:(left +. width) ~bottom:(top +. height) ()

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

  module Matrix44 = struct
    type t = T.Matrix44.t

    let t = T.Matrix44.t
    let t_ptr = C.ptr t

    let make
          ~m00
          ~m01
          ~m02
          ~m03
          ~m10
          ~m11
          ~m12
          ~m13
          ~m20
          ~m21
          ~m22
          ~m23
          ~m30
          ~m31
          ~m32
          ~m33
      =
      let m44 = C.make t in
      C.(
        setf m44 T.Matrix44.m00 m00;
        setf m44 T.Matrix44.m01 m01;
        setf m44 T.Matrix44.m02 m02;
        setf m44 T.Matrix44.m03 m03;

        setf m44 T.Matrix44.m10 m10;
        setf m44 T.Matrix44.m11 m11;
        setf m44 T.Matrix44.m12 m12;
        setf m44 T.Matrix44.m13 m13;

        setf m44 T.Matrix44.m20 m20;
        setf m44 T.Matrix44.m21 m21;
        setf m44 T.Matrix44.m22 m22;
        setf m44 T.Matrix44.m23 m23;

        setf m44 T.Matrix44.m30 m30;
        setf m44 T.Matrix44.m31 m31;
        setf m44 T.Matrix44.m32 m32;
        setf m44 T.Matrix44.m33 m33);
      m44

    let invert =
      foreign "oski_m44_invert" C.(ptr t @-> ptr t @-> returning bool)

    let concat =
      foreign "oski_m44_concat" C.(ptr t @-> ptr t @-> ptr t @-> returning void)
  end

  module IRect = struct
    type t = T.IRect.t C.ptr

    let t = C.ptr T.IRect.t

    let of_ltrb ~left ~top ~right ~bottom =
      let irect = C.allocate_n T.IRect.t ~count:1 in
      C.(
        setf !@irect T.IRect.left left;
        setf !@irect T.IRect.top top;
        setf !@irect T.IRect.right right;
        setf !@irect T.IRect.bottom bottom);
      irect

    let of_empty () =
      let zero = Int32.of_int 0 in
      of_ltrb ~left:zero ~top:zero ~right:zero ~bottom:zero
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
    let get_type = foreign "sk_rrect_get_type" C.(t @-> returning type_)

    let get_rect =
      foreign "sk_rrect_get_rect" C.(t @-> Rect.t @-> returning void)

    let get_radii =
      foreign
        "sk_rrect_get_radii"
        C.(t @-> corner @-> Vector.t @-> returning void)

    let get_width = foreign "sk_rrect_get_width" C.(t @-> returning float)
    let get_height = foreign "sk_rrect_get_height" C.(t @-> returning float)
    let set_empty = foreign "sk_rrect_set_empty" C.(t @-> returning void)

    let set_rect =
      foreign "sk_rrect_set_rect" C.(t @-> Rect.t @-> returning void)

    let set_oval =
      foreign "sk_rrect_set_oval" C.(t @-> Rect.t @-> returning void)

    let set_rect_xy =
      foreign
        "sk_rrect_set_rect_xy"
        C.(t @-> Rect.t @-> float @-> float @-> returning void)

    let set_nine_patch =
      foreign
        "sk_rrect_set_nine_patch"
        C.(
          t
          @-> Rect.t
          @-> float
          @-> float
          @-> float
          @-> float
          @-> returning void)

    let set_rect_radii =
      foreign
        "sk_rrect_set_rect_radii"
        C.(t @-> Rect.t @-> Vector.t @-> returning void)

    let inset =
      foreign "sk_rrect_inset" C.(t @-> float @-> float @-> returning void)

    let outset =
      foreign "sk_rrect_outset" C.(t @-> float @-> float @-> returning void)

    let offset =
      foreign "sk_rrect_offset" C.(t @-> float @-> float @-> returning void)

    let contains =
      foreign "sk_rrect_contains" C.(t @-> Rect.t @-> returning bool)

    let is_valid = foreign "sk_rrect_is_valid" C.(t @-> returning bool)

    let transform =
      foreign "sk_rrect_transform" C.(t @-> Matrix.t @-> t @-> returning bool)
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
        C.(t @-> Rect.t @-> direction @-> returning void)

    let add_rrect =
      foreign
        "sk_path_add_rrect"
        C.(t @-> RRect.t @-> direction @-> returning void)

    let add_rrect_start =
      foreign
        "sk_path_add_rrect_start"
        C.(t @-> RRect.t @-> direction @-> uint32_t @-> returning void)

    let add_rounded_rect =
      foreign
        "sk_path_add_rounded_rect"
        C.(t @-> Rect.t @-> float @-> float @-> direction @-> returning void)

    let add_oval =
      foreign
        "sk_path_add_oval"
        C.(t @-> Rect.t @-> direction @-> returning void)

    let add_circle =
      foreign
        "sk_path_add_circle"
        C.(t @-> float @-> float @-> float @-> direction @-> returning void)

    let get_bounds =
      foreign "sk_path_get_bounds" C.(t @-> Rect.t @-> returning void)

    let compute_tight_bounds =
      foreign "sk_path_compute_tight_bounds" C.(t @-> Rect.t @-> returning void)

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
        C.(t @-> Rect.t @-> direction @-> uint32_t @-> returning void)

    let add_arc =
      foreign
        "sk_path_add_arc"
        C.(t @-> Rect.t @-> float @-> float @-> returning void)

    let get_fill_type =
      foreign "sk_path_get_filltype" C.(t @-> returning fill_type)

    let set_fill_type =
      foreign "sk_path_set_filltype" C.(t @-> fill_type @-> returning void)

    let transform =
      foreign "sk_path_transform" C.(t @-> Matrix.t @-> returning void)

    let transform_to =
      foreign
        "sk_path_transform_to_dest"
        C.(t @-> Matrix.t @-> t @-> returning void)

    let clone = foreign "sk_path_clone" C.(t @-> returning t)

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
      foreign "sk_path_get_point" C.(t @-> int @-> Point.t @-> returning void)

    let get_points =
      foreign "sk_path_get_points" C.(t @-> Point.t @-> int @-> returning int)

    let contains =
      foreign "sk_path_contains" C.(t @-> float @-> float @-> returning bool)

    let parse_svg_string =
      foreign "sk_path_parse_svg_string" C.(t @-> string @-> returning bool)

    let to_svg_string =
      foreign "sk_path_to_svg_string" C.(t @-> String.t @-> returning void)

    let get_last_point =
      foreign "sk_path_get_last_point" C.(t @-> Point.t @-> returning bool)

    let convert_conic_to_quads =
      foreign
        "sk_path_convert_conic_to_quads"
        C.(
          Point.t
          @-> Point.t
          @-> Point.t
          @-> float
          @-> Point.t
          @-> int
          @-> returning int)

    let add_poly =
      foreign
        "sk_path_add_poly"
        C.(t @-> Point.t @-> int @-> bool @-> returning void)

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

  module Path_iterator = struct
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

  module Path_op = struct
    type t = T.Path.op

    let t = T.Path.op

    let op =
      foreign
        "sk_pathop_op"
        C.(Path.t @-> Path.t @-> t @-> Path.t @-> returning bool)

    let simplify =
      foreign "sk_pathop_simplify" C.(Path.t @-> Path.t @-> returning bool)

    let tight_bounds =
      foreign "sk_pathop_tight_bounds" C.(Path.t @-> Rect.t @-> returning bool)

    let as_winding =
      foreign "sk_pathop_as_winding" C.(Path.t @-> Path.t @-> returning bool)

    module Builder = struct
      type t = T.Path.op_builder C.ptr

      let t = C.ptr T.Path.op_builder
      let make = foreign "sk_opbuilder_new" C.(void @-> returning t)
      let destroy = foreign "sk_opbuilder_destroy" C.(t @-> returning void)

      let add =
        foreign
          "sk_opbuilder_add"
          C.(t @-> Path.t @-> T.Path.op @-> returning void)

      let resolve =
        foreign "sk_opbuilder_resolve" C.(t @-> Path.t @-> returning bool)
    end
  end

  module Path_measure = struct
    type t = T.Path_measure.t C.ptr

    let t = C.ptr T.Path_measure.t
    let t_opt = C.ptr_opt T.Path_measure.t

    type matrix_flags = T.Path_measure.matrix_flags

    let matrix_flags = T.Path_measure.matrix_flags
    let make = foreign "sk_pathmeasure_new" C.(void @-> returning t_opt)

    let of_path =
      foreign
        "sk_pathmeasure_new_with_path"
        C.(Path.t @-> bool @-> float @-> returning t_opt)

    let delete = foreign "sk_pathmeasure_destroy" C.(t @-> returning void)

    let set_path =
      foreign
        "sk_pathmeasure_set_path"
        C.(t @-> Path.t @-> bool @-> returning void)

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

  module Path_effect = struct
    type t = T.Path_effect.t C.ptr

    let t = C.ptr T.Path_effect.t

    type style = T.Path_effect.style

    let style = T.Path_effect.style

    type trim_mode = T.Path_effect.trim_mode

    let trim_mode = T.Path_effect.trim_mode
    let unref = foreign "sk_path_effect_unref" C.(t @-> returning void)

    let of_compose =
      foreign "sk_path_effect_create_compose" C.(t @-> t @-> returning t)

    let of_sum = foreign "sk_path_effect_create_sum" C.(t @-> t @-> returning t)

    let of_discrete =
      foreign
        "sk_path_effect_create_discrete"
        C.(float @-> float @-> uint32_t @-> returning t)

    let of_corner =
      foreign "sk_path_effect_create_corner" C.(float @-> returning t)

    let of_1d_path =
      foreign
        "sk_path_effect_create_1d_path"
        C.(Path.t @-> float @-> float @-> style @-> returning t)

    let of_2d_line =
      foreign
        "sk_path_effect_create_2d_line"
        C.(float @-> Matrix.t @-> returning t)

    let of_2d_path =
      foreign
        "sk_path_effect_create_2d_path"
        C.(Matrix.t @-> Path.t @-> returning t)

    let of_dash =
      foreign
        "sk_path_effect_create_dash"
        C.(ptr float @-> int @-> float @-> returning t)

    let of_trim =
      foreign
        "sk_path_effect_create_trim"
        C.(float @-> float @-> trim_mode @-> returning t)
  end

  module Paint = struct
    type t = T.Paint.t C.ptr

    let t = C.ptr T.Paint.t
  end

  module Blurstyle = struct
    type t = T.Blurstyle.t

    let t = T.Blurstyle.t
  end

  module Mask_filter = struct
    type t = T.Mask_filter.t C.ptr

    let t = C.ptr T.Mask_filter.t
    let ref = foreign "sk_maskfilter_ref" C.(t @-> returning void)
    let unref = foreign "sk_maskfilter_unref" C.(t @-> returning void)

    let of_blur =
      foreign
        "sk_maskfilter_new_blur_with_flags"
        C.(Blurstyle.t @-> float @-> bool @-> returning t)

    let of_gamma = foreign "sk_maskfilter_new_gamma" C.(float @-> returning t)

    let of_clip =
      foreign "sk_maskfilter_new_clip" C.(uint8_t @-> uint8_t @-> returning t)

    let of_shader =
      foreign "sk_maskfilter_new_shader" C.(Shader.t @-> returning t)
  end

  module Color_space = struct
    type t = T.Color_space.t C.ptr

    let t = C.ptr T.Color_space.t
    let ref = foreign "sk_colorspace_ref" C.(t @-> returning void)
    let unref = foreign "sk_colorspace_unref" C.(t @-> returning void)
    let of_srgb = foreign "sk_colorspace_new_srgb" C.(void @-> returning t)

    let of_srgb_linear =
      foreign "sk_colorspace_new_srgb_linear" C.(void @-> returning t)
  end

  module Image_info = struct
    type t = T.Image_info.t C.ptr

    let t = C.ptr T.Image_info.t

    let make ~width ~height ~color_type ~alpha_type ~colorspace =
      let info = C.allocate_n T.Image_info.t ~count:1 in
      C.(
        setf !@info T.Image_info.width width;
        setf !@info T.Image_info.height height;
        setf !@info T.Image_info.color_type color_type;
        setf !@info T.Image_info.alpha_type alpha_type;
        setf !@info T.Image_info.colorspace colorspace);
      info
  end

  module Filter_mode = struct
    type t = T.Filter_mode.t

    let t = T.Filter_mode.t
  end

  module Mipmap_mode = struct
    type t = T.Mipmap_mode.t

    let t = T.Mipmap_mode.t
  end

  module Cubic_resampler = struct
    type t = T.Cubic_resampler.t

    let t = T.Cubic_resampler.t

    let make ~b ~c =
      let cubic = C.make t in
      C.(
        setf cubic T.Cubic_resampler.b b;
        setf cubic T.Cubic_resampler.c c);
      cubic

    let mitchell () = make ~b:(1. /. 3.) ~c:(1. /. 3.)
    let catmull_rom () = make ~b:0. ~c:(1. /. 2.)
    let empty () = make ~b:0. ~c:0.
  end

  module Sampling_options = struct
    type t = T.Sampling_options.t

    let t = T.Sampling_options.t

    let make ?(max_aniso = 0) ?(use_cubic = false) ~cubic ~filter ~mimmap () =
      let sampler = C.make t in
      C.(
        setf sampler T.Sampling_options.max_aniso max_aniso;
        setf sampler T.Sampling_options.use_cubic use_cubic;
        setf sampler T.Sampling_options.cubic cubic;
        setf sampler T.Sampling_options.filter filter;
        setf sampler T.Sampling_options.mipmap mimmap);
      sampler
  end

  module Pixmap = struct
    type t = T.Pixmap.t C.ptr

    let t = C.ptr T.Pixmap.t
    let t_opt = C.ptr_opt T.Pixmap.t
    let delete = foreign "sk_pixmap_destructor" C.(t @-> returning void)
    let make = foreign "sk_pixmap_new" C.(void @-> returning t)

    let make_with_params =
      foreign
        "sk_pixmap_new_with_params"
        C.(Image_info.t @-> ptr void @-> size_t @-> returning t_opt)

    let reset = foreign "sk_pixmap_reset" C.(t @-> returning void)

    let reset_with_params =
      foreign
        "sk_pixmap_reset_with_params"
        C.(t @-> Image_info.t @-> ptr void @-> size_t @-> returning void)

    let set_colorspace =
      foreign
        "sk_pixmap_set_colorspace"
        C.(t @-> Color_space.t @-> returning void)

    let get_colorspace =
      foreign
        "sk_pixmap_get_colorspace"
        C.(t @-> returning (ptr_opt T.Color_space.t))

    let extract_subset =
      foreign
        "sk_pixmap_extract_subset"
        C.(t @-> t @-> IRect.t @-> returning bool)

    let get_info =
      foreign "sk_pixmap_get_info" C.(t @-> Image_info.t @-> returning void)

    let get_row_bytes =
      foreign "sk_pixmap_get_row_bytes" C.(t @-> returning size_t)

    let compute_is_opaque =
      foreign "sk_pixmap_compute_is_opaque" C.(t @-> returning bool)

    let get_pixel_color =
      foreign
        "sk_pixmap_get_pixel_color"
        C.(t @-> int @-> int @-> returning Color.t)

    let get_pixel_color4f =
      foreign
        "sk_pixmap_get_pixel_color4f"
        C.(t @-> int @-> int @-> Color4f.t @-> returning void)

    let get_pixel_alphaf =
      foreign
        "sk_pixmap_get_pixel_alphaf"
        C.(t @-> int @-> int @-> returning float)

    let get_writable_addr =
      foreign "sk_pixmap_get_writable_addr" C.(t @-> returning (ptr void))

    let get_writable_addr_at =
      foreign
        "sk_pixmap_get_writeable_addr_with_xy"
        C.(t @-> int @-> int @-> returning (ptr void))

    let read_pixels =
      foreign
        "sk_pixmap_read_pixels"
        C.(
          t
          @-> Image_info.t
          @-> ptr void
          @-> size_t
          @-> int
          @-> int
          @-> returning bool)

    let scale_pixels =
      foreign
        "sk_pixmap_scale_pixels"
        C.(t @-> t @-> ptr Sampling_options.t @-> returning bool)

    let erase =
      foreign
        "sk_pixmap_erase_color"
        C.(t @-> Color.t @-> IRect.t @-> returning bool)

    let erase_4f =
      foreign
        "sk_pixmap_erase_color4f"
        C.(t @-> Color4f.t @-> IRect.t @-> returning bool)
  end

  module Bitmap = struct
    type t = T.Bitmap.t C.ptr

    let t = C.ptr T.Bitmap.t
    let release_proc = C.static_funptr T.Bitmap.release_proc
    let delete = foreign "sk_bitmap_destructor" C.(t @-> returning void)
    let make = foreign "sk_bitmap_new" C.(void @-> returning t)

    let get_info =
      foreign "sk_bitmap_get_info" C.(t @-> Image_info.t @-> returning void)

    let get_pixels =
      foreign
        "sk_bitmap_get_pixels"
        C.(t @-> ptr size_t @-> returning (ptr void))

    let get_row_bytes =
      foreign "sk_bitmap_get_row_bytes" C.(t @-> returning size_t)

    let get_row_byte_count =
      foreign "sk_bitmap_get_byte_count" C.(t @-> returning size_t)

    let reset = foreign "sk_bitmap_reset" C.(t @-> returning void)
    let is_null = foreign "sk_bitmap_is_null" C.(t @-> returning bool)
    let is_immutable = foreign "sk_bitmap_is_immutable" C.(t @-> returning bool)

    let set_immutable =
      foreign "sk_bitmap_set_immutable" C.(t @-> returning void)

    let erase = foreign "sk_bitmap_erase" C.(t @-> Color.t @-> returning void)

    let erase_rect =
      foreign
        "sk_bitmap_erase_rect"
        C.(t @-> Color.t @-> IRect.t @-> returning void)

    let get_addr_8 =
      foreign
        "sk_bitmap_get_addr_8"
        C.(t @-> int @-> int @-> returning (ptr uint8_t))

    let get_addr_16 =
      foreign
        "sk_bitmap_get_addr_16"
        C.(t @-> int @-> int @-> returning (ptr uint16_t))

    let get_addr_32 =
      foreign
        "sk_bitmap_get_addr_32"
        C.(t @-> int @-> int @-> returning (ptr uint32_t))

    let get_addr =
      foreign
        "sk_bitmap_get_addr"
        C.(t @-> int @-> int @-> returning (ptr void))

    let get_pixel_color =
      foreign
        "sk_bitmap_get_pixel_color"
        C.(t @-> int @-> int @-> returning Color.t)

    let ready_to_draw =
      foreign "sk_bitmap_ready_to_draw" C.(t @-> returning bool)

    let install_pixels =
      foreign
        "sk_bitmap_install_pixels"
        C.(
          t
          @-> Image_info.t
          @-> ptr void
          @-> size_t
          @-> release_proc
          @-> ptr void
          @-> returning bool)

    let install_pixels_with_pixmap =
      foreign
        "sk_bitmap_install_pixels_with_pixmap"
        C.(t @-> Pixmap.t @-> returning bool)

    let try_alloc_pixels =
      foreign
        "sk_bitmap_try_alloc_pixels"
        C.(t @-> Image_info.t @-> size_t @-> returning bool)

    let try_alloc_pixels_with_flags =
      foreign
        "sk_bitmap_try_alloc_pixels_with_flags"
        C.(t @-> Image_info.t @-> uint32_t @-> returning bool)

    let set_pixels =
      foreign "sk_bitmap_set_pixels" C.(t @-> ptr void @-> returning void)

    let peek_pixels =
      foreign "sk_bitmap_peek_pixels" C.(t @-> Pixmap.t @-> returning bool)

    let extract_subset =
      foreign
        "sk_bitmap_extract_subset"
        C.(t @-> t @-> IRect.t @-> returning bool)
  end

  module Image = struct
    type t = T.Image.t C.ptr

    let t = C.ptr T.Image.t
    let t_opt = C.ptr_opt T.Image.t
    let ref = foreign "sk_image_ref" C.(t @-> returning void)
    let unref = foreign "sk_image_unref" C.(t @-> returning void)

    let of_raster_copy =
      foreign
        "sk_image_new_raster_copy"
        C.(Image_info.t @-> ptr void @-> size_t @-> returning t_opt)

    let of_encoded =
      foreign "sk_image_new_from_encoded" C.(Data.t @-> returning t_opt)
  end
end
