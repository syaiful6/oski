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

  module Color_space = struct
    type t = T.Color_space.t C.ptr

    let t = C.ptr T.Color_space.t
    let ref = foreign "sk_colorspace_ref" C.(t @-> returning void)
    let unref = foreign "sk_colorspace_unref" C.(t @-> returning void)
    let of_srgb = foreign "sk_colorspace_new_srgb" C.(void @-> returning t)

    let of_srgb_linear =
      foreign "sk_colorspace_new_srgb_linear" C.(void @-> returning t)
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

  module Vector = Point

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

  module Point3 = struct
    type t = T.Point3.t C.ptr

    let t = C.ptr T.Point3.t

    let make x y z =
      let point3 = C.allocate_n T.Point3.t ~count:1 in
      C.(setf !@point3 T.Point3.x x);
      C.(setf !@point3 T.Point3.y y);
      C.(setf !@point3 T.Point3.z z);
      point3

    let get_x point3 = C.(getf !@point3 T.Point3.x)
    let get_y point3 = C.(getf !@point3 T.Point3.y)
    let get_z point3 = C.(getf !@point3 T.Point3.z)
  end

  module ISize = struct
    type t = T.ISize.t C.ptr

    let t = C.ptr T.ISize.t

    let make w h =
      let isize = C.allocate_n T.ISize.t ~count:1 in
      C.(setf !@isize T.ISize.w w);
      C.(setf !@isize T.ISize.h h);
      isize

    let get_w isize = C.(getf !@isize T.ISize.w)
    let get_h isize = C.(getf !@isize T.ISize.h)
  end

  module IPoint = struct
    type t = T.IPoint.t C.ptr

    let t = C.ptr T.IPoint.t

    let make x y =
      let ipoint = C.allocate_n T.IPoint.t ~count:1 in
      C.(setf !@ipoint T.IPoint.x x);
      C.(setf !@ipoint T.IPoint.y y);
      ipoint

    let get_x ipoint = C.(getf !@ipoint T.IPoint.x)
    let get_y ipoint = C.(getf !@ipoint T.IPoint.y)
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

    let set_translate =
      foreign
        "oski_stub_matrix_set_translate"
        C.(t @-> float @-> float @-> returning void)

    let set_scale =
      foreign
        "oski_stub_matrix_set_scale"
        C.(t @-> float @-> float @-> float @-> float @-> returning void)

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
    let unref = foreign "sk_typeface_unref" C.(t @-> returning void)

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

  module Region = struct
    type t = T.Region.t C.ptr

    let t = C.ptr T.Region.t
    let t_opt = C.ptr_opt T.Region.t
    let make = foreign "sk_region_new" C.(void @-> returning t)
    let delete = foreign "sk_region_delete" C.(t @-> returning void)

    let contains_point =
      foreign "sk_region_contains" C.(t @-> t @-> returning bool)

    let contains_rect =
      foreign "sk_region_contains_rect" C.(t @-> IRect.t @-> returning bool)

    let contains_region =
      foreign
        "sk_region_contains_point"
        C.(t @-> int @-> int @-> returning bool)

    let intersects_rect =
      foreign "sk_region_intersects_rect" C.(t @-> IRect.t @-> returning bool)

    let intersects_region =
      foreign "sk_region_intersects" C.(t @-> t @-> returning bool)

    let set_empty = foreign "sk_region_set_empty" C.(t @-> returning bool)

    let set_rect =
      foreign "sk_region_set_rect" C.(t @-> IRect.t @-> returning bool)

    let set_rects =
      foreign "sk_region_set_rects" C.(t @-> IRect.t @-> int @-> returning bool)

    let set_region =
      foreign "sk_region_set_region" C.(t @-> t @-> returning bool)

    let set_path =
      foreign "sk_region_set_path" C.(t @-> Path.t @-> t @-> returning bool)

    let get_bounds =
      foreign "sk_region_get_bounds" C.(t @-> IRect.t @-> returning void)

    let get_boundary_path =
      foreign "sk_region_get_boundary_path" C.(t @-> Path.t @-> returning bool)

    let op_rect =
      foreign
        "sk_region_op_rect"
        C.(t @-> IRect.t @-> T.Region.op @-> returning bool)

    let op_region =
      foreign "sk_region_op" C.(t @-> t @-> T.Region.op @-> returning bool)

    let quick_contains =
      foreign "sk_region_quick_contains" C.(t @-> IRect.t @-> returning bool)

    let quick_reject_rect =
      foreign "sk_region_quick_reject_rect" C.(t @-> IRect.t @-> returning bool)

    let quick_reject_region =
      foreign "sk_region_quick_reject" C.(t @-> t @-> returning bool)

    let translate =
      foreign "sk_region_translate" C.(t @-> int @-> int @-> returning void)

    let is_empty = foreign "sk_region_is_empty" C.(t @-> returning bool)
    let is_rect = foreign "sk_region_is_rect" C.(t @-> returning bool)
    let is_complex = foreign "sk_region_is_complex" C.(t @-> returning bool)

    module Iterator = struct
      type t = T.Region.region C.ptr

      let t = C.ptr T.Region.region

      let make =
        foreign "sk_region_iterator_new" C.(ptr T.Region.t @-> returning t)

      let delete = foreign "sk_region_iterator_delete" C.(t @-> returning void)
      let rewind = foreign "sk_region_iterator_rewind" C.(t @-> returning void)
      let done_ = foreign "sk_region_iterator_done" C.(t @-> returning bool)
      let next = foreign "sk_region_iterator_next" C.(t @-> returning void)

      let rect =
        foreign "sk_region_iterator_rect" C.(t @-> IRect.t @-> returning void)
    end

    module Cliperator = struct
      type t = T.Region.cliperator C.ptr

      let t = C.ptr T.Region.cliperator

      let make =
        foreign
          "sk_region_cliperator_new"
          C.(ptr T.Region.t @-> IRect.t @-> returning t)

      let delete =
        foreign "sk_region_cliperator_delete" C.(t @-> returning void)

      let done_ = foreign "sk_region_cliperator_done" C.(t @-> returning bool)
      let next = foreign "sk_region_cliperator_next" C.(t @-> returning void)

      let rect =
        foreign "sk_region_cliperator_rect" C.(t @-> IRect.t @-> returning void)
    end

    module Spanerator = struct
      type t = T.Region.spanerator C.ptr

      let t = C.ptr T.Region.spanerator

      let make =
        foreign
          "sk_region_spanerator_new"
          C.(ptr T.Region.t @-> int @-> int @-> int @-> returning t)

      let delete =
        foreign "sk_region_spanerator_delete" C.(t @-> returning void)

      let next =
        foreign
          "sk_region_spanerator_next"
          C.(t @-> ptr int @-> ptr int @-> returning bool)
    end
  end

  module Color_filter = struct
    type t = T.Color_filter.t C.ptr

    let t = C.ptr T.Color_filter.t
    let t_opt = C.ptr_opt T.Color_filter.t
    let unref = foreign "sk_colorfilter_unref" C.(t @-> returning void)

    let of_mode =
      foreign
        "sk_colorfilter_new_mode"
        C.(Color.t @-> T.Blendmode.t @-> returning t_opt)

    let of_lighting =
      foreign
        "sk_colorfilter_new_lighting"
        C.(Color.t @-> Color.t @-> returning t_opt)

    let of_compose =
      foreign "sk_colorfilter_new_compose" C.(t @-> t @-> returning t_opt)

    let of_color_matrix =
      foreign
        "sk_colorfilter_new_color_matrix"
        C.(ptr float @-> returning t_opt)

    let of_hsla_matrix =
      foreign "sk_colorfilter_new_hsla_matrix" C.(ptr float @-> returning t_opt)

    let of_linear_to_srgb_gamma =
      foreign
        "sk_colorfilter_new_linear_to_srgb_gamma"
        C.(void @-> returning t_opt)

    let of_srgb_to_linear_gamma =
      foreign
        "sk_colorfilter_new_srgb_to_linear_gamma"
        C.(void @-> returning t_opt)

    let of_luma_color =
      foreign "sk_colorfilter_new_luma_color" C.(void @-> returning t_opt)

    let of_high_contrast =
      foreign
        "sk_colorfilter_new_high_contrast"
        C.(ptr T.Highcontrastconfig.t @-> returning t_opt)

    let of_table =
      foreign "sk_colorfilter_new_table" C.(ptr uint8_t @-> returning t_opt)

    let of_table_argb =
      foreign
        "sk_colorfilter_new_table_argb"
        C.(
          ptr uint8_t
          @-> ptr uint8_t
          @-> ptr uint8_t
          @-> ptr uint8_t
          @-> returning t_opt)
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

    let of_radial_gradient =
      foreign
        "sk_shader_new_radial_gradient"
        C.(
          Point.t
          @-> float
          @-> ptr Color.t
          @-> ptr float
          @-> int
          @-> tile_mode
          @-> Matrix.t
          @-> returning t)

    let of_sweep_gradient =
      foreign
        "sk_shader_new_sweep_gradient"
        C.(
          Point.t
          @-> ptr Color.t
          @-> ptr float
          @-> int
          @-> tile_mode
          @-> float
          @-> float
          @-> Matrix.t
          @-> returning t)

    let of_two_point_conical_gradient =
      foreign
        "sk_shader_new_two_point_conical_gradient"
        C.(
          Point.t
          @-> float
          @-> Point.t
          @-> float
          @-> ptr Color.t
          @-> ptr float
          @-> int
          @-> tile_mode
          @-> Matrix.t
          @-> returning t)

    let of_perlin_noise_fractal_noise =
      foreign
        "sk_shader_new_perlin_noise_fractal_noise"
        C.(float @-> float @-> int @-> float @-> ptr T.ISize.t @-> returning t)

    let of_perlin_noise_turbulence =
      foreign
        "sk_shader_new_perlin_noise_turbulence"
        C.(float @-> float @-> int @-> float @-> ptr T.ISize.t @-> returning t)

    let of_color4f =
      foreign
        "sk_shader_new_color4f"
        C.(Color4f.t @-> Color_space.t @-> returning t)

    let with_local_matrix =
      foreign "sk_shader_with_local_matrix" C.(t @-> Matrix.t @-> returning t)

    let with_color_filter =
      foreign
        "sk_shader_with_color_filter"
        C.(t @-> Color_filter.t @-> returning t)
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

    (* let release_proc = C.static_funptr (ptr void @-> ptr void @-> returning
       void) *)
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

    (* let install_pixels = foreign "sk_bitmap_install_pixels" C.( t @->
       Image_info.t @-> ptr void @-> size_t @-> release_proc @-> ptr void @->
       returning bool) *)

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

  module Paint = struct
    type t = T.Paint.t C.ptr

    let t = C.ptr T.Paint.t
    let t_opt = C.ptr_opt T.Paint.t
    let make = foreign "sk_paint_new" C.(void @-> returning t)
    let clone = foreign "sk_paint_clone" C.(t @-> returning t_opt)
    let delete = foreign "sk_paint_delete" C.(t @-> returning void)
    let reset = foreign "sk_paint_reset" C.(t @-> returning void)
    let is_antialias = foreign "sk_paint_is_antialias" C.(t @-> returning bool)

    let set_antialias =
      foreign "sk_paint_set_antialias" C.(t @-> bool @-> returning void)

    let get_color = foreign "sk_paint_get_color" C.(t @-> returning Color.t)

    let get_color4f =
      foreign "sk_paint_get_color4f" C.(t @-> Color4f.t @-> returning void)

    let set_color =
      foreign "sk_paint_set_color" C.(t @-> Color.t @-> returning void)

    let set_color4f =
      foreign
        "sk_paint_set_color4f"
        C.(t @-> Color4f.t @-> Color_space.t @-> returning void)

    let get_style =
      foreign "sk_paint_get_style" C.(t @-> returning T.Paint.style)

    let set_style =
      foreign "sk_paint_set_style" C.(t @-> T.Paint.style @-> returning void)

    let get_stroke_width =
      foreign "sk_paint_get_stroke_width" C.(t @-> returning float)

    let set_stroke_width =
      foreign "sk_paint_set_stroke_width" C.(t @-> float @-> returning void)

    let get_stroke_miter =
      foreign "sk_paint_get_stroke_miter" C.(t @-> returning float)

    let set_stroke_miter =
      foreign "sk_paint_set_stroke_miter" C.(t @-> float @-> returning void)

    let get_stroke_cap =
      foreign "sk_paint_get_stroke_cap" C.(t @-> returning T.Paint.stroke_cap)

    let set_stroke_cap =
      foreign
        "sk_paint_set_stroke_cap"
        C.(t @-> T.Paint.stroke_cap @-> returning void)

    let get_stroke_join =
      foreign "sk_paint_get_stroke_join" C.(t @-> returning T.Paint.stroke_join)

    let set_stroke_join =
      foreign
        "sk_paint_set_stroke_join"
        C.(t @-> T.Paint.stroke_join @-> returning void)

    let set_shader =
      foreign "sk_paint_set_shader" C.(t @-> Shader.t @-> returning void)

    let get_shader = foreign "sk_paint_get_shader" C.(t @-> returning Shader.t)

    let set_maskfilter =
      foreign
        "sk_paint_set_maskfilter"
        C.(t @-> Mask_filter.t @-> returning void)

    let get_maskfilter =
      foreign "sk_paint_get_maskfilter" C.(t @-> returning Mask_filter.t)

    let set_colorfilter =
      foreign
        "sk_paint_set_colorfilter"
        C.(t @-> Color_filter.t @-> returning void)

    let get_colorfilter =
      foreign "sk_paint_get_colorfilter" C.(t @-> returning Color_filter.t)

    let set_imagefilter =
      foreign
        "sk_paint_set_imagefilter"
        C.(t @-> ptr T.Image_filter.t @-> returning void)

    let get_imagefilter =
      foreign
        "sk_paint_get_imagefilter"
        C.(t @-> returning (ptr T.Image_filter.t))

    let set_blendmode =
      foreign
        "sk_paint_set_blendmode"
        C.(t @-> T.Blendmode.t @-> returning void)

    let get_blendmode =
      foreign "sk_paint_get_blendmode" C.(t @-> returning T.Blendmode.t)

    let set_blender =
      foreign "sk_paint_set_blender" C.(t @-> Blender.t @-> returning void)

    let get_blender =
      foreign "sk_paint_get_blender" C.(t @-> returning Blender.t)

    let set_path_effect =
      foreign
        "sk_paint_set_path_effect"
        C.(t @-> Path_effect.t @-> returning void)

    let get_path_effect =
      foreign "sk_paint_get_path_effect" C.(t @-> returning Path_effect.t)

    let is_dither = foreign "sk_paint_is_dither" C.(t @-> returning bool)

    let set_dither =
      foreign "sk_paint_set_dither" C.(t @-> bool @-> returning void)

    let get_fill_path =
      foreign
        "sk_paint_get_fill_path"
        C.(t @-> Path.t @-> Path.t @-> Rect.t @-> Matrix.t @-> returning bool)
  end

  module Font = struct
    type t = T.Font.t C.ptr

    let t = C.ptr T.Font.t
    let t_opt = C.ptr_opt T.Font.t
    let make = foreign "sk_font_new" C.(void @-> returning t)

    let make_with_values =
      foreign
        "sk_font_new_with_values"
        C.(Typeface.t @-> float @-> float @-> float @-> returning t)

    let delete = foreign "sk_font_delete" C.(t @-> returning void)

    let is_force_auto_hinting =
      foreign "sk_font_is_force_auto_hinting" C.(t @-> returning bool)

    let set_force_auto_hinting =
      foreign "sk_font_set_force_auto_hinting" C.(t @-> bool @-> returning void)

    let is_embedded_bitmaps =
      foreign "sk_font_is_embedded_bitmaps" C.(t @-> returning bool)

    let set_embedded_bitmaps =
      foreign "sk_font_set_embedded_bitmaps" C.(t @-> bool @-> returning void)

    let is_subpixel = foreign "sk_font_is_subpixel" C.(t @-> returning bool)

    let set_subpixel =
      foreign "sk_font_set_subpixel" C.(t @-> bool @-> returning void)

    let is_linear_metrics =
      foreign "sk_font_is_linear_metrics" C.(t @-> returning bool)

    let set_linear_metrics =
      foreign "sk_font_set_linear_metrics" C.(t @-> bool @-> returning void)

    let is_embolden = foreign "sk_font_is_embolden" C.(t @-> returning bool)

    let set_embolden =
      foreign "sk_font_set_embolden" C.(t @-> bool @-> returning void)

    let is_baseline_snap =
      foreign "sk_font_is_baseline_snap" C.(t @-> returning bool)

    let set_baseline_snap =
      foreign "sk_font_set_baseline_snap" C.(t @-> bool @-> returning void)

    let get_edging =
      foreign "sk_font_get_edging" C.(t @-> returning T.Font.edging)

    let set_edging =
      foreign "sk_font_set_edging" C.(t @-> T.Font.edging @-> returning void)

    let get_hinting =
      foreign "sk_font_get_hinting" C.(t @-> returning T.Font.hinting)

    let set_hinting =
      foreign "sk_font_set_hinting" C.(t @-> T.Font.hinting @-> returning void)

    let get_typeface =
      foreign "sk_font_get_typeface" C.(t @-> returning Typeface.t)

    let set_typeface =
      foreign "sk_font_set_typeface" C.(t @-> Typeface.t @-> returning void)

    let get_size = foreign "sk_font_get_size" C.(t @-> returning float)
    let set_size = foreign "sk_font_set_size" C.(t @-> float @-> returning void)
    let get_scale_x = foreign "sk_font_get_scale_x" C.(t @-> returning float)

    let set_scale_x =
      foreign "sk_font_set_scale_x" C.(t @-> float @-> returning void)

    let get_skew_x = foreign "sk_font_get_skew_x" C.(t @-> returning float)

    let set_skew_x =
      foreign "sk_font_set_skew_x" C.(t @-> float @-> returning void)

    let text_to_glyphs =
      foreign
        "sk_font_text_to_glyphs"
        C.(
          t
          @-> ptr void
          @-> size_t
          @-> Text_encoding.t
          @-> ptr uint16_t
          @-> int
          @-> returning int)

    let unichar_to_glyph =
      foreign
        "sk_font_unichar_to_glyph"
        C.(t @-> int32_t @-> returning uint16_t)

    let unichars_to_glyphs =
      foreign
        "sk_font_unichars_to_glyphs"
        C.(t @-> ptr int32_t @-> int @-> ptr uint16_t @-> returning void)

    let measure_text =
      foreign
        "sk_font_measure_text"
        C.(
          t
          @-> ptr void
          @-> size_t
          @-> Text_encoding.t
          @-> Rect.t
          @-> Paint.t
          @-> returning float)

    let measure_text_no_return =
      foreign
        "sk_font_measure_text_no_return"
        C.(
          t
          @-> ptr void
          @-> size_t
          @-> Text_encoding.t
          @-> Rect.t
          @-> Paint.t
          @-> ptr float
          @-> returning void)

    let break_text =
      foreign
        "sk_font_break_text"
        C.(
          t
          @-> ptr void
          @-> size_t
          @-> Text_encoding.t
          @-> float
          @-> ptr float
          @-> Paint.t
          @-> returning size_t)

    let get_widths_bounds =
      foreign
        "sk_font_get_widths_bounds"
        C.(
          t
          @-> ptr uint16_t
          @-> int
          @-> ptr float
          @-> Rect.t
          @-> Paint.t
          @-> returning void)

    let get_pos =
      foreign
        "sk_font_get_pos"
        C.(
          t @-> ptr uint16_t @-> int @-> Point.t @-> Point.t @-> returning void)

    let get_xpos =
      foreign
        "sk_font_get_xpos"
        C.(
          t @-> ptr uint16_t @-> int @-> ptr float @-> float @-> returning void)

    let get_path =
      foreign
        "sk_font_get_path"
        C.(t @-> uint16_t @-> Path.t @-> returning bool)

    (* let get_paths = foreign "sk_font_get_paths" C.( t @-> ptr uint16_t @->
       int @-> static_funptr (ptr void @-> ptr void @-> ptr void @-> returning
       void) @-> ptr void @-> returning void) *)

    let get_metrics =
      foreign "sk_font_get_metrics" C.(t @-> Font_metrics.t @-> returning float)
  end

  module Drawable = struct
    type t = T.Drawable.t C.ptr

    let t = C.ptr T.Drawable.t
  end

  module Canvas = struct
    type t = T.Canvas.t C.ptr

    let t = C.ptr T.Canvas.t
    let destroy = foreign "sk_canvas_destroy" C.(t @-> returning void)
    let clear = foreign "sk_canvas_clear" C.(t @-> Color.t @-> returning void)

    let clear_color4f =
      foreign "sk_canvas_clear_color4f" C.(t @-> T.Color4f.t @-> returning void)

    let discard = foreign "sk_canvas_discard" C.(t @-> returning void)

    let get_save_count =
      foreign "sk_canvas_get_save_count" C.(t @-> returning int)

    let restore_to_count =
      foreign "sk_canvas_restore_to_count" C.(t @-> int @-> returning void)

    let draw_color =
      foreign
        "sk_canvas_draw_color"
        C.(t @-> Color.t @-> T.Blendmode.t @-> returning void)

    let draw_color4f =
      foreign
        "sk_canvas_draw_color4f"
        C.(t @-> T.Color4f.t @-> T.Blendmode.t @-> returning void)

    let draw_points =
      foreign
        "sk_canvas_draw_points"
        C.(
          t
          @-> T.Point_mode.t
          @-> size_t
          @-> Point.t
          @-> Paint.t
          @-> returning void)

    let draw_point =
      foreign
        "sk_canvas_draw_point"
        C.(t @-> float @-> float @-> Paint.t @-> returning void)

    let draw_line =
      foreign
        "sk_canvas_draw_line"
        C.(
          t
          @-> float
          @-> float
          @-> float
          @-> float
          @-> Paint.t
          @-> returning void)

    let draw_simple_text =
      foreign
        "sk_canvas_draw_simple_text"
        C.(
          t
          @-> ptr void
          @-> size_t
          @-> Text_encoding.t
          @-> float
          @-> float
          @-> Font.t
          @-> Paint.t
          @-> returning void)

    let draw_text_blob =
      foreign
        "sk_canvas_draw_text_blob"
        C.(
          t
          @-> ptr T.Text_blob.t
          @-> float
          @-> float
          @-> Paint.t
          @-> returning void)

    let reset_matrix = foreign "sk_canvas_reset_matrix" C.(t @-> returning void)

    let set_matrix =
      foreign "sk_canvas_set_matrix" C.(t @-> Matrix44.t_ptr @-> returning void)

    let get_matrix =
      foreign "sk_canvas_get_matrix" C.(t @-> Matrix44.t_ptr @-> returning void)

    let draw_round_rect =
      foreign
        "sk_canvas_draw_round_rect"
        C.(t @-> Rect.t @-> float @-> float @-> Paint.t @-> returning void)

    let clip_rect_with_operation =
      foreign
        "sk_canvas_clip_rect_with_operation"
        C.(t @-> Rect.t @-> T.Clip_op.t @-> bool @-> returning void)

    let clip_path_with_operation =
      foreign
        "sk_canvas_clip_path_with_operation"
        C.(t @-> Path.t @-> T.Clip_op.t @-> bool @-> returning void)

    let clip_rrect_with_operation =
      foreign
        "sk_canvas_clip_rrect_with_operation"
        C.(t @-> RRect.t @-> T.Clip_op.t @-> bool @-> returning void)

    let get_local_clip_bounds =
      foreign
        "sk_canvas_get_local_clip_bounds"
        C.(t @-> Rect.t @-> returning bool)

    let get_device_clip_bounds =
      foreign
        "sk_canvas_get_device_clip_bounds"
        C.(t @-> IRect.t @-> returning bool)

    let save = foreign "sk_canvas_save" C.(t @-> returning int)

    let save_layer =
      foreign
        "sk_canvas_save_layer"
        C.(t @-> Rect.t @-> Paint.t @-> returning int)

    let save_layer_rec =
      foreign
        "sk_canvas_save_layer_rec"
        C.(t @-> ptr T.Canvas.save_layer_rec @-> returning int)

    let restore = foreign "sk_canvas_restore" C.(t @-> returning void)

    let translate =
      foreign "sk_canvas_translate" C.(t @-> float @-> float @-> returning void)

    let scale =
      foreign "sk_canvas_scale" C.(t @-> float @-> float @-> returning void)

    let rotate_degrees =
      foreign "sk_canvas_rotate_degrees" C.(t @-> float @-> returning void)

    let rotate_radians =
      foreign "sk_canvas_rotate_radians" C.(t @-> float @-> returning void)

    let skew =
      foreign "sk_canvas_skew" C.(t @-> float @-> float @-> returning void)

    let concat =
      foreign "sk_canvas_concat" C.(t @-> Matrix44.t_ptr @-> returning void)

    let quick_reject =
      foreign "sk_canvas_quick_reject" C.(t @-> Rect.t @-> returning bool)

    let clip_region =
      foreign
        "sk_canvas_clip_region"
        C.(t @-> Region.t @-> T.Clip_op.t @-> returning void)

    let draw_paint =
      foreign "sk_canvas_draw_paint" C.(t @-> Paint.t @-> returning void)

    let draw_region =
      foreign
        "sk_canvas_draw_region"
        C.(t @-> Region.t @-> Paint.t @-> returning void)

    let draw_rect =
      foreign
        "sk_canvas_draw_rect"
        C.(t @-> Rect.t @-> Paint.t @-> returning void)

    let draw_rrect =
      foreign
        "sk_canvas_draw_rrect"
        C.(t @-> RRect.t @-> Paint.t @-> returning void)

    let draw_circle =
      foreign
        "sk_canvas_draw_circle"
        C.(t @-> float @-> float @-> float @-> Paint.t @-> returning void)

    let draw_oval =
      foreign
        "sk_canvas_draw_oval"
        C.(t @-> Rect.t @-> Paint.t @-> returning void)

    let draw_path =
      foreign
        "sk_canvas_draw_path"
        C.(t @-> Path.t @-> Paint.t @-> returning void)

    let draw_image =
      foreign
        "sk_canvas_draw_image"
        C.(
          t
          @-> Image.t
          @-> float
          @-> float
          @-> ptr Sampling_options.t
          @-> Paint.t
          @-> returning void)

    let draw_image_rect =
      foreign
        "sk_canvas_draw_image_rect"
        C.(
          t
          @-> Image.t
          @-> Rect.t
          @-> Rect.t
          @-> ptr Sampling_options.t
          @-> Paint.t
          @-> returning void)

    let draw_picture =
      foreign
        "sk_canvas_draw_picture"
        C.(t @-> ptr T.Picture.t @-> Matrix.t @-> Paint.t @-> returning void)

    let draw_drawable =
      foreign
        "sk_canvas_draw_drawable"
        C.(t @-> Drawable.t @-> Matrix.t @-> returning void)

    let new_from_bitmap =
      foreign "sk_canvas_new_from_bitmap" C.(Bitmap.t @-> returning t)

    let new_from_raster =
      foreign
        "sk_canvas_new_from_raster"
        C.(
          Image_info.t
          @-> ptr void
          @-> size_t
          @-> ptr T.Surface_props.t
          @-> returning t)

    let draw_annotation =
      foreign
        "sk_canvas_draw_annotation"
        C.(t @-> Rect.t @-> string @-> Data.t @-> returning void)

    let draw_url_annotation =
      foreign
        "sk_canvas_draw_url_annotation"
        C.(t @-> Rect.t @-> Data.t @-> returning void)

    let draw_named_destination_annotation =
      foreign
        "sk_canvas_draw_named_destination_annotation"
        C.(t @-> Point.t @-> Data.t @-> returning void)

    let draw_link_destination_annotation =
      foreign
        "sk_canvas_draw_link_destination_annotation"
        C.(t @-> Rect.t @-> Data.t @-> returning void)

    let draw_image_lattice =
      foreign
        "sk_canvas_draw_image_lattice"
        C.(
          t
          @-> Image.t
          @-> ptr T.Lattice.t
          @-> Rect.t
          @-> Filter_mode.t
          @-> Paint.t
          @-> returning void)

    let draw_image_nine =
      foreign
        "sk_canvas_draw_image_nine"
        C.(
          t
          @-> Image.t
          @-> IRect.t
          @-> Rect.t
          @-> Filter_mode.t
          @-> Paint.t
          @-> returning void)

    let draw_vertices =
      foreign
        "sk_canvas_draw_vertices"
        C.(
          t
          @-> ptr T.Vertices.t
          @-> T.Blendmode.t
          @-> Paint.t
          @-> returning void)

    let draw_arc =
      foreign
        "sk_canvas_draw_arc"
        C.(
          t
          @-> Rect.t
          @-> float
          @-> float
          @-> bool
          @-> Paint.t
          @-> returning void)

    let draw_drrect =
      foreign
        "sk_canvas_draw_drrect"
        C.(t @-> RRect.t @-> RRect.t @-> Paint.t @-> returning void)

    let draw_atlas =
      foreign
        "sk_canvas_draw_atlas"
        C.(
          t
          @-> Image.t
          @-> ptr T.RSXform.t
          @-> Rect.t
          @-> ptr Color.t
          @-> int
          @-> T.Blendmode.t
          @-> ptr Sampling_options.t
          @-> Rect.t
          @-> Paint.t
          @-> returning void)

    let draw_patch =
      foreign
        "sk_canvas_draw_patch"
        C.(
          t
          @-> Point.t
          @-> ptr Color.t
          @-> Point.t
          @-> T.Blendmode.t
          @-> Paint.t
          @-> returning void)

    let is_clip_empty =
      foreign "sk_canvas_is_clip_empty" C.(t @-> returning bool)

    let is_clip_rect = foreign "sk_canvas_is_clip_rect" C.(t @-> returning bool)
  end

  module Picture = struct
    type t = T.Picture.t C.ptr

    let t = C.ptr T.Picture.t
    let t_opt = C.ptr_opt T.Picture.t
    let unref = foreign "sk_picture_unref" C.(t @-> returning void)
    let ref = foreign "sk_picture_ref" C.(t @-> returning void)

    let get_cull_rect =
      foreign "sk_picture_get_cull_rect" C.(t @-> Rect.t @-> returning void)

    let get_unique_id =
      foreign "sk_picture_get_unique_id" C.(t @-> returning uint32_t)

    let serialize =
      foreign "sk_picture_serialize_to_data" C.(t @-> returning Data.t)

    let deserialize =
      foreign "sk_picture_deserialize_from_data" C.(Data.t @-> returning t_opt)

    let make_shader =
      foreign
        "sk_picture_make_shader"
        C.(
          t
          @-> Shader.tile_mode
          @-> Shader.tile_mode
          @-> Filter_mode.t
          @-> Matrix.t
          @-> Rect.t
          @-> returning Shader.t)

    module Recorder = struct
      type t = T.Picture.recorder C.ptr

      let t = C.ptr T.Picture.recorder
      let t_opt = C.ptr_opt T.Picture.recorder
      let make = foreign "sk_picture_recorder_new" C.(void @-> returning t)
      let delete = foreign "sk_picture_recorder_delete" C.(t @-> returning void)

      let begin_recording =
        foreign
          "sk_picture_recorder_begin_recording"
          C.(t @-> Rect.t @-> returning Canvas.t)

      let begin_recording_with_bbh_factory =
        foreign
          "sk_picture_recorder_begin_recording_with_bbh_factory"
          C.(t @-> Rect.t @-> ptr T.Bbh_factory.t @-> returning Canvas.t)

      let end_recording =
        foreign
          "sk_picture_recorder_end_recording"
          C.(t @-> returning (ptr T.Picture.t))

      let end_recording_as_drawable =
        foreign
          "sk_picture_recorder_end_recording_as_drawable"
          C.(t @-> returning Drawable.t)
    end
  end

  module Image_filter = struct
    type t = T.Image_filter.t C.ptr

    let t = C.ptr T.Image_filter.t
    let t_opt = C.ptr_opt T.Image_filter.t
    let unref = foreign "sk_imagefilter_unref" C.(t @-> returning void)

    let of_arithmetic =
      foreign
        "sk_imagefilter_new_arithmetic"
        C.(
          float
          @-> float
          @-> float
          @-> float
          @-> bool
          @-> t_opt
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_blend =
      foreign
        "sk_imagefilter_new_blend"
        C.(T.Blendmode.t @-> t_opt @-> t_opt @-> Rect.t @-> returning t_opt)

    let of_blender =
      foreign
        "sk_imagefilter_new_blender"
        C.(Blender.t @-> t_opt @-> t_opt @-> Rect.t @-> returning t_opt)

    let of_blur =
      foreign
        "sk_imagefilter_new_blur"
        C.(
          float
          @-> float
          @-> Shader.tile_mode
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_color_filter =
      foreign
        "sk_imagefilter_new_color_filter"
        C.(Color_filter.t @-> t_opt @-> Rect.t @-> returning t_opt)

    let of_compose =
      foreign "sk_imagefilter_new_compose" C.(t @-> t @-> returning t_opt)

    let of_displacement_map_effect =
      foreign
        "sk_imagefilter_new_displacement_map_effect"
        C.(
          T.Color_channel.t
          @-> T.Color_channel.t
          @-> float
          @-> t
          @-> t
          @-> Rect.t
          @-> returning t_opt)

    let of_drop_shadow =
      foreign
        "sk_imagefilter_new_drop_shadow"
        C.(
          float
          @-> float
          @-> float
          @-> float
          @-> Color.t
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_drop_shadow_only =
      foreign
        "sk_imagefilter_new_drop_shadow_only"
        C.(
          float
          @-> float
          @-> float
          @-> float
          @-> Color.t
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_image =
      foreign
        "sk_imagefilter_new_image"
        C.(
          Image.t
          @-> Rect.t
          @-> Rect.t
          @-> C.ptr Sampling_options.t
          @-> returning t_opt)

    let of_image_simple =
      foreign
        "sk_imagefilter_new_image_simple"
        C.(Image.t @-> ptr Sampling_options.t @-> returning t_opt)

    let of_magnifier =
      foreign
        "sk_imagefilter_new_magnifier"
        C.(
          Rect.t
          @-> float
          @-> float
          @-> C.ptr Sampling_options.t
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_matrix_transform =
      foreign
        "sk_imagefilter_new_matrix_transform"
        C.(Matrix.t @-> ptr Sampling_options.t @-> t_opt @-> returning t_opt)

    let of_merge =
      foreign
        "sk_imagefilter_new_merge"
        C.(ptr t @-> int @-> Rect.t @-> returning t_opt)

    let of_merge_simple =
      foreign
        "sk_imagefilter_new_merge_simple"
        C.(t @-> t @-> Rect.t @-> returning t_opt)

    let of_offset =
      foreign
        "sk_imagefilter_new_offset"
        C.(float @-> float @-> t_opt @-> Rect.t @-> returning t_opt)

    let of_picture =
      foreign "sk_imagefilter_new_picture" C.(Picture.t @-> returning t_opt)

    let of_picture_with_rect =
      foreign
        "sk_imagefilter_new_picture_with_rect"
        C.(Picture.t @-> Rect.t @-> returning t_opt)

    let of_shader =
      foreign
        "sk_imagefilter_new_shader"
        C.(Shader.t @-> bool @-> Rect.t @-> returning t_opt)

    let of_tile =
      foreign
        "sk_imagefilter_new_tile"
        C.(Rect.t @-> Rect.t @-> t @-> returning t_opt)

    let of_dilate =
      foreign
        "sk_imagefilter_new_dilate"
        C.(float @-> float @-> t_opt @-> Rect.t @-> returning t_opt)

    let of_erode =
      foreign
        "sk_imagefilter_new_erode"
        C.(float @-> float @-> t_opt @-> Rect.t @-> returning t_opt)

    (* Lighting filters *)
    let of_distant_lit_diffuse =
      foreign
        "sk_imagefilter_new_distant_lit_diffuse"
        C.(
          Point3.t
          @-> Color.t
          @-> float
          @-> float
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_point_lit_diffuse =
      foreign
        "sk_imagefilter_new_point_lit_diffuse"
        C.(
          Point3.t
          @-> Color.t
          @-> float
          @-> float
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_spot_lit_diffuse =
      foreign
        "sk_imagefilter_new_spot_lit_diffuse"
        C.(
          Point3.t
          @-> Point3.t
          @-> float
          @-> float
          @-> Color.t
          @-> float
          @-> float
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_distant_lit_specular =
      foreign
        "sk_imagefilter_new_distant_lit_specular"
        C.(
          Point3.t
          @-> Color.t
          @-> float
          @-> float
          @-> float
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_point_lit_specular =
      foreign
        "sk_imagefilter_new_point_lit_specular"
        C.(
          Point3.t
          @-> Color.t
          @-> float
          @-> float
          @-> float
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)

    let of_spot_lit_specular =
      foreign
        "sk_imagefilter_new_spot_lit_specular"
        C.(
          Point3.t
          @-> Point3.t
          @-> float
          @-> float
          @-> Color.t
          @-> float
          @-> float
          @-> float
          @-> t_opt
          @-> Rect.t
          @-> returning t_opt)
  end

  module Surface = struct
    type t = T.Surface.t C.ptr

    let t = C.ptr T.Surface.t
    let t_opt = C.ptr_opt T.Surface.t

    let make_null =
      foreign "sk_surface_new_null" C.(int @-> int @-> returning t_opt)

    let make_raster =
      foreign
        "sk_surface_new_raster"
        C.(
          Image_info.t @-> size_t @-> ptr T.Surface_props.t @-> returning t_opt)

    (* let make_raster_direct = foreign "sk_surface_new_raster_direct" C.(
       Image_info.t @-> ptr void @-> size_t @-> C.static_funptr
       T.Surface.raster_release_proc @-> ptr void @-> T.Surface_props.t @->
       returning t_opt) *)

    let unref = foreign "sk_surface_unref" C.(t @-> returning void)

    let get_canvas =
      foreign "sk_surface_get_canvas" C.(t @-> returning (ptr T.Canvas.t))

    let new_image_snapshot =
      foreign "sk_surface_new_image_snapshot" C.(t @-> returning Image.t)

    let new_image_snapshot_with_crop =
      foreign
        "sk_surface_new_image_snapshot_with_crop"
        C.(t @-> IRect.t @-> returning Image.t)

    let draw =
      foreign
        "sk_surface_draw"
        C.(
          t
          @-> ptr T.Canvas.t
          @-> float
          @-> float
          @-> Paint.t
          @-> returning void)

    let peek_pixels =
      foreign "sk_surface_peek_pixels" C.(t @-> Pixmap.t @-> returning bool)

    let read_pixels =
      foreign
        "sk_surface_read_pixels"
        C.(
          t
          @-> Image_info.t
          @-> ptr void
          @-> size_t
          @-> int
          @-> int
          @-> returning bool)

    let get_props =
      foreign
        "sk_surface_get_props"
        C.(t @-> returning (ptr (const T.Surface_props.t)))
  end

  module Document = struct
    type t = T.Document.t C.ptr

    let t = C.ptr T.Document.t
    let t_opt = C.ptr_opt T.Document.t
    let unref = foreign "sk_document_unref" C.(t @-> returning void)
    let abort = foreign "sk_document_abort" C.(t @-> returning void)

    let begin_page =
      foreign
        "sk_document_begin_page"
        C.(t @-> float @-> float @-> Rect.t @-> returning Canvas.t)

    let end_page = foreign "sk_document_end_page" C.(t @-> returning void)
    let close = foreign "sk_document_close" C.(t @-> returning void)

    let make_pdf =
      foreign
        "sk_document_create_pdf_from_stream"
        C.(WStream.t @-> returning t_opt)

    let make_pdf_with_metadata =
      foreign
        "sk_document_create_pdf_from_stream_with_metadata"
        C.(WStream.t @-> ptr T.Document.pdf_metadata @-> returning t_opt)

    let make_xps =
      foreign
        "sk_document_create_xps_from_stream"
        C.(WStream.t @-> float @-> returning t_opt)
  end
end
