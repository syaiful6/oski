open Ctypes

module M (F : Ctypes.TYPE) = struct
  open F

  let skia_c_enum label typedef mapping =
    enum
      typedef
      ~typedef:true
      ~unexpected:(fun i ->
        invalid_arg (Printf.sprintf "Unsupported %s enum: %Ld" typedef i))
      (mapping
      |> List.map (fun (constructor, constant_name) ->
        constructor, constant (constant_name ^ "_SK_" ^ label) int64_t))

  let skia_c_enum_no_prefix label typedef mapping =
    enum
      typedef
      ~typedef:true
      ~unexpected:(fun i ->
        invalid_arg (Printf.sprintf "Unsupported %s enum: %Ld" typedef i))
      (mapping
      |> List.map (fun (constructor, constant_name) ->
        constructor, constant (constant_name ^ "_" ^ label) int64_t))

  module Color = struct
    let t = uint32_t
  end

  module PM_color = struct
    let t = uint32_t
  end

  module Color4f = struct
    type t
    (** color with 4 float *)

    let t : t structure typ = structure "sk_color4f_t"
    let red = field t "fR" float
    let green = field t "fG" float
    let blue = field t "fB" float
    let alpha = field t "fA" float
    let () = seal t
  end

  module Color_type = struct
    type t =
      [ `Unknown
      | `Alpha8
      | `Rgb_565
      | `Argb_4444
      | `Rgb_8888
      | `Rgb_888x
      | `Bgra_8888
      | `Rgba_1010102
      | `Bgra_1010102
      | `Rgb_101010x
      | `Bgr_101010x
      | `Bgr_101010x_xr
      | `Rgba_10x6
      | `Gray_8
      | `Rgba_f16_norm
      | `Rgba_f16
      | `Rgba_f32
      | `R8gb_unorm
      | `A16_float
      | `R16g16_float
      | `A16_unorm
      | `R16g16_unorm
      | `R16g16b16a16_unorm
      | `Srgba_8888
      | `R8_unorm
      ]

    let t : t typ =
      skia_c_enum
        "COLORTYPE"
        "sk_colortype_t"
        [ `Unknown, "UNKNOWN"
        ; `Alpha8, "ALPHA_8"
        ; `Rgb_565, "RGB_565"
        ; `Argb_4444, "ARGB_4444"
        ; `Rgb_8888, "RGBA_8888"
        ; `Rgb_888x, "RGB_888X"
        ; `Bgra_8888, "BGRA_8888"
        ; `Rgba_1010102, "RGBA_1010102"
        ; `Bgra_1010102, "BGRA_1010102"
        ; `Rgb_101010x, "RGB_101010X"
        ; `Bgr_101010x, "BGR_101010X"
        ; `Bgr_101010x_xr, "BGR_101010X_XR"
        ; `Rgba_10x6, "RGBA_10X6"
        ; `Gray_8, "GRAY_8"
        ; `Rgba_f16_norm, "RGBA_F16_NORM"
        ; `Rgba_f16, "RGBA_F16"
        ; `Rgba_f32, "RGBA_F32"
        ; `R8gb_unorm, "R8G8_UNORM"
        ; `A16_float, "A16_FLOAT"
        ; `R16g16_unorm, "R16G16_FLOAT"
        ; `A16_unorm, "A16_UNORM"
        ; `R16g16_unorm, "R16G16_UNORM"
        ; `R16g16b16a16_unorm, "R16G16B16A16_UNORM"
        ; `Srgba_8888, "SRGBA_8888"
        ; `R8_unorm, "R8_UNORM"
        ]
  end

  module Alpha_type = struct
    type t =
      [ `Unknown
      | `Opaque
      | `Premul
      | `Unpremul
      ]

    let t : t typ =
      skia_c_enum
        "ALPHATYPE"
        "sk_alphatype_t"
        [ `Unknown, "UNKNOWN"
        ; `Opaque, "OPAQUE"
        ; `Premul, "PREMUL"
        ; `Unpremul, "UNPREMUL"
        ]
  end

  module Pixel_geometry = struct
    type t =
      [ `Unknown
      | `Rgb_h
      | `Bgr_h
      | `Rgb_v
      | `Bgr_v
      ]

    let t : t typ =
      skia_c_enum
        "PIXELGEOMETRY"
        "sk_pixelgeometry_t"
        [ `Unknown, "UNKNOWN"
        ; `Rgb_h, "RGB_H"
        ; `Bgr_h, "BGR_H"
        ; `Rgb_v, "RGB_V"
        ; `Bgr_v, "BGR_V"
        ]
  end

  module Surface_props = struct
    type flag = Unsigned.uint32

    let flag = Ctypes.uint32_t

    type t

    let t : t structure typ = structure "sk_surfaceprops_t"
  end

  module Highcontrastconfig = struct
    type invert_style =
      [ `No_invert
      | `Invert_brightness
      | `Invert_lightness
      ]

    let invert_style : invert_style typ =
      skia_c_enum
        "HIGH_CONTRAST_CONFIG_INVERT_STYLE"
        "sk_highcontrastconfig_invertstyle_t"
        [ `No_invert, "NO_INVERT"
        ; `Invert_brightness, "INVERT_BRIGHTNESS"
        ; `Invert_lightness, "INVERT_LIGHTNESS"
        ]

    type t

    let t : t structure typ = structure "sk_highcontrastconfig_t"
    let t = typedef t "sk_highcontrastconfig_t"
    let grayscale = field t "fGrayscale" bool
    let invert_style_field = field t "fInvertStyle" invert_style
    let contrast = field t "fContrast" float
    let () = seal t
  end

  module Point = struct
    type t

    let t : t structure typ = structure "sk_point_t"
    let t = typedef t "sk_point_t"
    let x = field t "x" float
    let y = field t "y" float
    let () = seal t
  end

  module Vector = Point

  module Point3 = struct
    type t

    let t : t structure typ = structure "sk_point3_t"
    let t = typedef t "sk_point3_t"
    let x = field t "x" float
    let y = field t "y" float
    let z = field t "z" float
    let () = seal t
  end

  module Vector3 = Point3

  module Vector4 = struct
    type t

    let t : t structure typ = structure "oski_v4_t"
    let t = typedef t "oski_v4_t"
    let x = field t "x" float
    let y = field t "y" float
    let z = field t "z" float
    let w = field t "w" float
    let () = seal t
  end

  module Matrix = struct
    type t

    let t : t structure typ = structure "sk_matrix_t"
    let t = typedef t "sk_matrix_t"
    let scaleX = field t "scaleX" float
    let skewX = field t "skewX" float
    let transX = field t "transX" float
    let skewY = field t "skewY" float
    let scaleY = field t "scaleY" float
    let transY = field t "transY" float
    let persp0 = field t "persp0" float
    let persp1 = field t "persp1" float
    let persp2 = field t "persp2" float
    let () = seal t
  end

  module Matrix44 = struct
    type t

    let t : t structure typ = structure "sk_matrix44_t"
    let t = typedef t "sk_matrix44_t"
    let m00 = field t "m00" float
    let m01 = field t "m01" float
    let m02 = field t "m02" float
    let m03 = field t "m03" float

    (* row 1 *)
    let m10 = field t "m10" float
    let m11 = field t "m11" float
    let m12 = field t "m12" float
    let m13 = field t "m13" float

    (* row 2 *)
    let m20 = field t "m20" float
    let m21 = field t "m21" float
    let m22 = field t "m22" float
    let m23 = field t "m23" float

    (* row 3 *)
    let m30 = field t "m30" float
    let m31 = field t "m31" float
    let m32 = field t "m32" float
    let m33 = field t "m33" float
    let () = seal t
  end

  module IRect = struct
    type t

    let t : t structure typ = structure "sk_irect_t"
    let t = typedef t "sk_irect_t"
    let left = field t "left" int32_t
    let top = field t "top" int32_t
    let right = field t "right" int32_t
    let bottom = field t "bottom" int32_t
    let () = seal t
  end

  module Rect = struct
    type t

    let t : t structure typ = structure "sk_rect_t"
    let t = typedef t "sk_rect_t"
    let left = field t "left" float
    let top = field t "top" float
    let right = field t "right" float
    let bottom = field t "bottom" float
    let () = seal t
  end

  module RRect = struct
    type t

    let t : t structure typ = structure "sk_rrect_t"

    type type_ =
      [ `Empty
      | `Rect
      | `Oval
      | `Simple
      | `Nine_patch
      | `Complex
      ]

    let type_ : type_ typ =
      skia_c_enum
        "RRECT_TYPE"
        "sk_rrect_type_t"
        [ `Empty, "EMPTY"
        ; `Rect, "RECT"
        ; `Oval, "OVAL"
        ; `Simple, "SIMPLE"
        ; `Nine_patch, "NINE_PATCH"
        ; `Complex, "COMPLEX"
        ]

    type corner =
      [ `Upper_left
      | `Upper_right
      | `Lower_right
      | `Lower_left
      ]

    let corner : corner typ =
      skia_c_enum
        "RRECT_CORNER"
        "sk_rrect_corner_t"
        [ `Upper_right, "UPPER_RIGHT"
        ; `Upper_left, "UPPER_LEFT"
        ; `Lower_right, "LOWER_RIGHT"
        ; `Lower_left, "LOWER_LEFT"
        ]
  end

  module Blurstyle = struct
    type t =
      [ `Normal
      | `Solid
      | `Outer
      | `Inner
      ]

    let t : t typ =
      skia_c_enum
        "BLUR_STYLE"
        "sk_blurstyle_t"
        [ `Normal, "NORMAL"; `Solid, "SOLID"; `Outer, "OUTER"; `Inner, "INNER" ]
  end

  module Drawable = struct
    type t

    let t : t structure typ = structure "sk_drawable_t"
  end

  module Image = struct
    type t

    let t : t structure typ = structure "sk_image_t"
  end

  module Mask_filter = struct
    type t

    let t : t structure typ = structure "sk_maskfilter_t"
  end

  module Paint = struct
    type t

    let t : t structure typ = structure "sk_paint_t"

    type style =
      [ `Fill
      | `Stroke
      | `Stroke_and_fill
      ]

    let style : style typ =
      skia_c_enum
        "PAINT_STYLE"
        "sk_paint_style_t"
        [ `Fill, "FILL"
        ; `Stroke, "STROKE"
        ; `Stroke_and_fill, "STROKE_AND_FILL"
        ]

    type stroke_cap =
      [ `Butt
      | `Round
      | `Square
      ]

    let stroke_cap : stroke_cap typ =
      skia_c_enum
        "STROKE_CAP"
        "sk_stroke_cap_t"
        [ `Butt, "BUTT"; `Round, "ROUND"; `Square, "SQUARE" ]

    type stroke_join =
      [ `Miter
      | `Round
      | `Bevel
      ]

    let stroke_join : stroke_join typ =
      skia_c_enum
        "STROKE_JOIN"
        "sk_stroke_join_t"
        [ `Miter, "MITER"; `Round, "ROUND"; `Bevel, "BEVEL" ]
  end

  module Path = struct
    type t

    let t : t structure typ = structure "sk_path_t"

    type direction =
      [ `CW
      | `CCW
      ]

    let direction : direction typ =
      skia_c_enum
        "PATH_DIRECTION"
        "sk_path_direction_t"
        [ `CW, "CW"; `CCW, "CCW" ]

    type arc_size =
      [ `Small
      | `Large
      ]

    let arc_size : arc_size typ =
      skia_c_enum
        "PATH_ARC_SIZE"
        "sk_path_arc_size_t"
        [ `Small, "SMALL"; `Large, "LARGE" ]

    type fill_type =
      [ `Winding
      | `Even_odd
      | `Inverse_winding
      | `Inverse_even_odd
      ]

    let fill_type : fill_type typ =
      skia_c_enum
        "PATH_FILLTYPE"
        "sk_path_filltype_t"
        [ `Winding, "WINDING"
        ; `Even_odd, "EVENODD"
        ; `Inverse_winding, "INVERSE_WINDING"
        ; `Inverse_even_odd, "INVERSE_EVENODD"
        ]

    type add_mode =
      [ `Append
      | `Extend
      ]

    let add_mode : add_mode typ =
      skia_c_enum
        "PATH_ADD_MODE"
        "sk_path_add_mode_t"
        [ `Append, "APPEND"; `Extend, "EXTEND" ]

    type verb =
      [ `Move
      | `Line
      | `Quad
      | `Conic
      | `Cubic
      | `Close
      | `Done
      ]

    let verb : verb typ =
      skia_c_enum
        "PATH_VERB"
        "sk_path_verb_t"
        [ `Move, "MOVE"
        ; `Line, "LINE"
        ; `Quad, "QUAD"
        ; `Conic, "CONIC"
        ; `Cubic, "CUBIC"
        ; `Close, "CLOSE"
        ; `Done, "DONE"
        ]

    type iterator

    let iterator : iterator structure typ = structure "sk_path_iterator_t"

    type op =
      [ `Difference
      | `Intersect
      | `Union
      | `Xor
      | `Reverse_difference
      ]

    let op : op typ =
      skia_c_enum
        "PATHOP"
        "sk_pathop_t"
        [ `Difference, "DIFFERENCE"
        ; `Intersect, "INTERSECT"
        ; `Union, "UNION"
        ; `Xor, "XOR"
        ; `Reverse_difference, "REVERSE_DIFFERENCE"
        ]

    type op_builder

    let op_builder : op_builder structure typ = structure "sk_opbuilder_t"
  end

  module Path_measure = struct
    type t

    let t : t structure typ = structure "sk_pathmeasure_t"

    type matrix_flags =
      [ `Get_position
      | `Get_tangent
      | `Get_pos_and_tan
      ]

    let matrix_flags : matrix_flags typ =
      skia_c_enum
        "PATHMEASURE_MATRIXFLAGS"
        "sk_pathmeasure_matrixflags_t"
        [ `Get_position, "GET_POSITION"
        ; `Get_tangent, "GET_TANGENT"
        ; `Get_pos_and_tan, "GET_POS_AND_TAN"
        ]
  end

  module Path_effect = struct
    type t

    let t : t structure typ = structure "sk_path_effect_t"

    type style =
      [ `Translate
      | `Rotate
      | `Morph
      ]

    let style : style typ =
      skia_c_enum
        "PATH_EFFECT_1D_STYLE"
        "sk_path_effect_1d_style_t"
        [ `Translate, "TRANSLATE"; `Rotate, "ROTATE"; `Morph, "MORPH" ]

    type trim_mode =
      [ `Normal
      | `Inverted
      ]

    let trim_mode : trim_mode typ =
      skia_c_enum
        "PATH_EFFECT_TRIM_MODE"
        "sk_path_effect_trim_mode_t"
        [ `Normal, "NORMAL"; `Inverted, "INVERTED" ]
  end

  module Picture = struct
    type t

    let t : t structure typ = structure "sk_picture_t"

    type recorder

    let recorder : recorder structure typ = structure "sk_picture_recorder_t"
  end

  module Bbh_factory = struct
    type t

    let t : t structure typ = structure "sk_bbh_factory_t"
  end

  module Rtree_factory = struct
    type t

    let t : t structure typ = structure "sk_rtree_factory_t"
  end

  module Shader = struct
    type t

    let t : t structure typ = structure "sk_shader_t"

    type tile_mode =
      [ `clamp
      | `repeat
      | `mirror
      ]

    let tile_mode : tile_mode typ =
      skia_c_enum
        "SHADER_TILEMODE"
        "sk_shader_tilemode_t"
        [ `clamp, "CLAMP"; `repeat, "REPEAT"; `mirror, "MIRROR" ]
  end

  module Surface = struct
    type t

    let t : t structure typ = structure "sk_surface_t"
  end

  module Region = struct
    type t

    let t : t structure typ = structure "sk_region_t"

    type region

    let region : region structure typ = structure "sk_region_iterator_t"

    type cliperator

    let cliperator : cliperator structure typ =
      structure "sk_region_cliperator_t"

    type spanerator

    let spanerator : spanerator structure typ =
      structure "sk_region_spanerator_t"

    type op =
      [ `Difference
      | `Intersect
      | `Union
      | `Xor
      | `Reverse_difference
      | `Replace
      ]

    let op : op typ =
      skia_c_enum
        "REGION_OP"
        "sk_region_op_t"
        [ `Difference, "DIFFERENCE"
        ; `Intersect, "INTERSECT"
        ; `Union, "UNION"
        ; `Xor, "XOR"
        ; `Reverse_difference, "REVERSE_DIFFERENCE"
        ; `Replace, "REPLACE"
        ]
  end

  module Font_style = struct
    type t

    let t : t structure typ = structure "sk_fontstyle_t"

    type slant =
      [ `Upright
      | `Italic
      | `Oblique
      ]

    let slant : slant typ =
      skia_c_enum
        "FONT_STYLE_SLANT"
        "sk_font_style_slant_t"
        [ `Upright, "UPRIGHT"; `Italic, "ITALIC"; `Oblique, "OBLIQUE" ]

    type set

    let set : set structure typ = structure "sk_fontstyleset_t"
    let set = typedef set "sk_fontstyleset_t"
  end

  module Codec = struct
    type t

    let t : t structure typ = structure "sk_codec_t"
  end

  module Color_space = struct
    type t

    let t : t structure typ = structure "sk_colorspace_t"

    type transfer_fn

    let transfer_fn : transfer_fn structure typ =
      structure "sk_colorspace_transfer_fn_t"

    let transfer_fn = typedef transfer_fn "sk_colorspace_transfer_fn_t"
    let fG = field transfer_fn "fG" float
    let fA = field transfer_fn "fA" float
    let fB = field transfer_fn "fB" float
    let fC = field transfer_fn "fC" float
    let fD = field transfer_fn "fD" float
    let fE = field transfer_fn "fE" float
    let fF = field transfer_fn "fF" float
    let () = seal transfer_fn

    type xyz

    let xyz : xyz structure typ = structure "sk_colorspace_xyz_t"
    let xyz = typedef xyz "sk_colorspace_xyz_t"
    let fM00 = field xyz "fM00" float
    let fM01 = field xyz "fM01" float
    let fM02 = field xyz "fM02" float
    let fM10 = field xyz "fM10" float
    let fM11 = field xyz "fM11" float
    let fM12 = field xyz "fM12" float
    let fM20 = field xyz "fM20" float
    let fM21 = field xyz "fM21" float
    let fM22 = field xyz "fM22" float
    let () = seal xyz
  end

  module Image_info = struct
    type t

    let t : t structure typ = structure "sk_imageinfo_t"
    let t = typedef t "sk_imageinfo_t"
    let colorspace = field t "colorspace" (ptr Color_space.t)
    let width = field t "width" int32_t
    let height = field t "height" int32_t
    let color_type = field t "colorType" Color_type.t
    let alpha_type = field t "alphaType" Alpha_type.t
    let () = seal t
  end

  module Blend_mode = struct
    type t =
      [ `Clear
      | `Src
      | `Dst
      | `Src_over
      | `Dst_over
      | `Src_in
      | `Dst_in
      | `Src_out
      | `Dst_out
      | `Src_atop
      | `Dst_atop
      | `Xor
      | `Plus
      | `Modulate
      | `Screen
      | `Overlay
      | `Darken
      | `Lighten
      | `Color_dodge
      | `Color_burn
      | `Hard_light
      | `Soft_light
      | `Difference
      | `Exclusion
      | `Multiply
      | `Hue
      | `Saturation
      | `Color
      | `Luminosity
      ]

    let t : t typ =
      skia_c_enum
        "BLENDMODE"
        "sk_blendmode_t"
        [ `Clear, "CLEAR"
        ; `Src, "SRC"
        ; `Dst, "DST"
        ; `Src_over, "SRCOVER"
        ; `Dst_over, "DSTOVER"
        ; `Src_in, "SRCIN"
        ; `Dst_in, "DSTIN"
        ; `Src_out, "SRCOUT"
        ; `Dst_out, "DSTOUT"
        ; `Src_atop, "SRCATOP"
        ; `Dst_atop, "DSTATOP"
        ; `Xor, "XOR"
        ; `Plus, "PLUS"
        ; `Modulate, "MODULATE"
        ; `Screen, "SCREEN"
        ; `Overlay, "OVERLAY"
        ; `Darken, "DARKEN"
        ; `Lighten, "LIGHTEN"
        ; `Color_dodge, "COLORDODGE"
        ; `Color_burn, "COLORBURN"
        ; `Hard_light, "HARDLIGHT"
        ; `Soft_light, "SOFTLIGHT"
        ; `Difference, "DIFFERENCE"
        ; `Exclusion, "EXCLUSION"
        ; `Multiply, "MULTIPLY"
        ; `Hue, "HUE"
        ; `Saturation, "SATURATION"
        ; `Color, "COLOR"
        ; `Luminosity, "LUMINOSITY"
        ]
  end

  module Text_encoding = struct
    type t =
      [ `Utf8
      | `Utf16
      | `Utf32
      | `GlyphId
      ]

    let t : t typ =
      skia_c_enum
        "TEXT_ENCODING"
        "sk_text_encoding_t"
        [ `Utf8, "UTF8"
        ; `Utf16, "UTF16"
        ; `Utf32, "UTF32"
        ; `GlyphId, "GLYPH_ID"
        ]
  end

  module Text_align = struct
    type t =
      [ `Left
      | `Center
      | `Right
      ]

    let t : t typ =
      skia_c_enum
        "TEXT_ALIGN"
        "sk_text_align_t"
        [ `Left, "LEFT"; `Center, "CENTER"; `Right, "RIGHT" ]
  end

  module Color_channel = struct
    type t =
      [ `R
      | `G
      | `B
      | `A
      ]

    let t : t typ =
      skia_c_enum
        "COLOR_CHANNEL"
        "sk_color_channel_t"
        [ `R, "R"; `G, "G"; `B, "B"; `A, "A" ]
  end

  module Data = struct
    type t

    let t : t structure typ = structure "sk_data_t"
  end

  module String = struct
    type t

    let t : t structure typ = structure "sk_string_t"
  end

  module Stream = struct
    type t

    let t : t structure typ = structure "sk_stream_t"

    type file

    let file : file structure typ = structure "sk_stream_filestream_t"

    type asset

    let asset : asset structure typ = structure "sk_stream_asset_t"

    type memory

    let memory : memory structure typ = structure "sk_stream_memorystream_t"

    type rewindable

    let rewindable : rewindable structure typ =
      structure "sk_stream_streamrewindable_t"

    module Writable = struct
      type t

      let t : t structure typ = structure "sk_wstream_t"

      type file

      let file : file structure typ = structure "sk_wstream_filestream_t"

      type dynamic_memory

      let dynamic_memory : dynamic_memory structure typ =
        structure "sk_wstream_dynamicmemorystream_t"
    end
  end

  module Png_encoder_filter_flags = struct
    type t =
      [ `Zero
      | `None
      | `Sub
      | `Up
      | `Avg
      | `Paeth
      | `All
      ]

    let t : t typ =
      skia_c_enum
        "PNGENCODER_FILTER_FLAGS"
        "sk_pngencoder_filterflags_t"
        [ `Zero, "ZERO"
        ; `None, "NONE"
        ; `Sub, "SUB"
        ; `Up, "UP"
        ; `Avg, "AVG"
        ; `Paeth, "PAETH"
        ; `All, "ALL"
        ]
  end

  module Png_encoder_options = struct
    type t

    let t : t structure typ = structure "sk_pngencoder_options_t"
    let t = typedef t "sk_pngencoder_options_t"
    let filter_flags = field t "fFilterFlags" Png_encoder_filter_flags.t
    let zlib_level = field t "fZLibLevel" int
    let comments = field t "fComments" (ptr void)
    let icc_profile = field t "fICCProfile" (ptr void)
    let icc_profile_description = field t "fICCProfileDescription" (ptr void)
    let () = seal t
  end

  module Document = struct
    type t

    let t : t structure typ = structure "sk_document_t"

    type pdf_datetime

    let pdf_datetime : pdf_datetime structure typ =
      structure "sk_document_pdf_datetime_t"

    let pdf_datetime = typedef pdf_datetime "sk_document_pdf_datetime_t"
    let time_zone_minutes = field pdf_datetime "fTimeZoneMinutes" int16_t
    let year = field pdf_datetime "fYear" uint16_t
    let month = field pdf_datetime "fMonth" uint8_t
    let day_of_week = field pdf_datetime "fDayOfWeek" uint8_t
    let day = field pdf_datetime "fDay" uint8_t
    let hour = field pdf_datetime "fHour" uint8_t
    let minute = field pdf_datetime "fMinute" uint8_t
    let second = field pdf_datetime "fSecond" uint8_t
    let () = seal pdf_datetime

    type pdf_metadata

    let pdf_metadata : pdf_metadata structure typ =
      structure "sk_document_pdf_metadata_t"

    let pdf_metadata = typedef pdf_metadata "sk_document_pdf_metadata_t"
    let title = field pdf_metadata "fTitle" (ptr String.t)
    let author = field pdf_metadata "fAuthor" (ptr String.t)
    let subject = field pdf_metadata "fSubject" (ptr String.t)
    let keywords = field pdf_metadata "fKeywords" (ptr String.t)
    let creator = field pdf_metadata "fCreator" (ptr String.t)
    let producer = field pdf_metadata "fProducer" (ptr String.t)
    let creation = field pdf_metadata "fCreation" (ptr pdf_datetime)
    let modified = field pdf_metadata "fModified" (ptr pdf_datetime)
    let raster_dpi = field pdf_metadata "fRasterDPI" float
    let pdfa = field pdf_metadata "fPDFA" bool
    let encoding_quality = field pdf_metadata "fEncodingQuality" int
    let () = seal pdf_metadata
  end

  module Point_mode = struct
    type t =
      [ `Points
      | `Lines
      | `Polygon
      ]

    let t : t typ =
      skia_c_enum
        "POINT_MODE"
        "sk_point_mode_t"
        [ `Points, "POINTS"; `Lines, "LINES"; `Polygon, "POLYGON" ]
  end

  module Font = struct
    type t

    let t : t structure typ = structure "sk_font_t"

    type hinting =
      [ `nohint
      | `slight
      | `normal
      | `full
      ]

    let hinting : hinting typ =
      skia_c_enum
        "FONT_HINTING"
        "sk_font_hinting_t"
        [ `nohint, "NONE"; `slight, "SLIGHT"; `normal, "NORMAL"; `full, "FULL" ]

    type edging =
      [ `Alias
      | `Antialias
      | `Subpixel_antialias
      ]

    let edging : edging typ =
      skia_c_enum
        "FONT_EDGING"
        "sk_font_edging_t"
        [ `Alias, "ALIAS"
        ; `Antialias, "ANTIALIAS"
        ; `Subpixel_antialias, "SUBPIXEL_ANTIALIAS"
        ]
  end

  module Typeface = struct
    type t

    let t : t structure typ = structure "sk_typeface_t"

    type id = Unsigned.uint32

    let id = uint32_t

    type font_table_tag = Unsigned.uint32

    let font_table_tag = uint32_t
  end

  module Font_manager = struct
    type t

    let t : t structure typ = structure "sk_fontmgr_t"
  end

  module Font_metrics = struct
    type t

    let t : t structure typ = structure "sk_fontmetrics_t"
    let t = typedef t "sk_fontmetrics_t"
    let flags = field t "fFlags" uint32_t
    let top = field t "fTop" float
    let ascent = field t "fAscent" float
    let descent = field t "fDescent" float
    let bottom = field t "fBottom" float
    let leading = field t "fLeading" float
    let avg_char_width = field t "fAvgCharWidth" float
    let max_char_width = field t "fMaxCharWidth" float
    let xmin = field t "fXMin" float
    let xmax = field t "fXMax" float
    let xheight = field t "fXHeight" float
    let cap_height = field t "fCapHeight" float
    let underline_thickness = field t "fUnderlineThickness" float
    let underline_position = field t "fUnderlinePosition" float
    let strikeout_thickness = field t "fStrikeoutThickness" float
    let strikeout_position = field t "fStrikeoutPosition" float
    let () = seal t
  end

  module Filter_mode = struct
    type t =
      [ `Nearest
      | `Linear
      ]

    let t : t typ =
      skia_c_enum
        "FILTER_MODE"
        "sk_filter_mode_t"
        [ `Nearest, "NEAREST"; `Linear, "LINEAR" ]
  end

  module Mipmap_mode = struct
    type t =
      [ `None
      | `Nearest
      | `Linear
      ]

    let t : t typ =
      skia_c_enum
        "MIPMAP_MODE"
        "sk_mipmap_mode_t"
        [ `None, "NONE"; `Nearest, "NEAREST"; `Linear, "LINEAR" ]
  end

  module Cubic_resampler = struct
    type t

    let t : t structure typ = structure "sk_cubic_resampler_t"
    let t = typedef t "sk_cubic_resampler_t"
    let b = field t "fB" float
    let c = field t "fC" float
    let () = seal t
  end

  module Sampling_options = struct
    type t

    let t : t structure typ = structure "sk_sampling_options_t"
    let t = typedef t "sk_sampling_options_t"
    let max_aniso = field t "fMaxAniso" int
    let use_cubic = field t "fUseCubic" bool
    let cubic = field t "fCubic" Cubic_resampler.t
    let filter = field t "fFilter" Filter_mode.t
    let mipmap = field t "fMipmap" Mipmap_mode.t
    let () = seal t
  end

  module Bitmap = struct
    type t

    let t : t structure typ = structure "sk_bitmap_t"
  end

  module Pixmap = struct
    type t

    let t : t structure typ = structure "sk_pixmap_t"
  end

  module Color_filter = struct
    type t

    let t : t structure typ = structure "sk_colorfilter_t"
  end

  module Image_filter = struct
    type t

    let t : t structure typ = structure "sk_imagefilter_t"
  end

  module Blender = struct
    type t

    let t : t structure typ = structure "sk_blender_t"
  end

  module SVGDOM = struct
    type t

    let t : t structure typ = structure "oski_svgdom_t"
  end

  module Text_blob = struct
    type t

    let t : t structure typ = structure "sk_textblob_t"
  end

  module Text_blob_builder = struct
    module Run_buffer = struct
      type t

      let t : t structure typ = structure "sk_textblob_builder_runbuffer_t"
      let t = typedef t "sk_textblob_builder_runbuffer_t"
      let glyphs = field t "glyphs" (ptr void)
      let pos = field t "pos" (ptr void)
      let utf8text = field t "utf8text" (ptr void)
      let clusters = field t "clusters" (ptr void)
      let () = seal t
    end

    type t

    let t : t structure typ = structure "sk_textblob_builder_t"
  end

  module Shaper = struct
    type t

    let t : t structure typ = structure "sk_shaper_t"
  end

  module Size = struct
    type t

    let t : t structure typ = structure "sk_size_t"
    let t = typedef t "sk_size_t"
    let w = field t "w" float
    let h = field t "h" float
    let () = seal t
  end

  module ISize = struct
    type t

    let t : t structure typ = structure "sk_isize_t"
    let t = typedef t "sk_isize_t"
    let w = field t "w" int32_t
    let h = field t "h" int32_t
    let () = seal t
  end

  module IPoint = struct
    type t

    let t : t structure typ = structure "sk_ipoint_t"
    let t = typedef t "sk_ipoint_t"
    let x = field t "x" int32_t
    let y = field t "y" int32_t
    let () = seal t
  end

  module Vertices = struct
    type t

    let t : t structure typ = structure "sk_vertices_t"

    type vertex_mode =
      [ `Triangles
      | `Triangle_strip
      | `Triangle_fan
      ]

    let vertex_mode : vertex_mode typ =
      skia_c_enum
        "VERTICES_VERTEX_MODE"
        "sk_vertices_vertex_mode_t"
        [ `Triangles, "TRIANGLES"
        ; `Triangle_strip, "TRIANGLE_STRIP"
        ; `Triangle_fan, "TRIANGLE_FAN"
        ]
  end

  module RSXform = struct
    type t

    let t : t structure typ = structure "sk_rsxform_t"
    let t = typedef t "sk_rsxform_t"
    let scos = field t "fSCos" float
    let ssin = field t "fSSin" float
    let tx = field t "fTX" float
    let ty = field t "fTY" float
    let () = seal t
  end

  module Lattice = struct
    type rect_type =
      [ `Default
      | `Transparent
      | `Fixed_color
      ]

    let rect_type : rect_type typ =
      skia_c_enum
        "LATTICE_RECT_TYPE"
        "sk_lattice_recttype_t"
        [ `Default, "DEFAULT"
        ; `Transparent, "TRANSPARENT"
        ; `Fixed_color, "FIXED_COLOR"
        ]

    type t

    let t : t structure typ = structure "sk_lattice_t"
    let t = typedef t "sk_lattice_t"
    let x_divs = field t "fXDivs" (ptr int)
    let y_divs = field t "fYDivs" (ptr int)
    let rect_types = field t "fRectTypes" (ptr rect_type)
    let x_count = field t "fXCount" int
    let y_count = field t "fYCount" int
    let bounds = field t "fBounds" (ptr IRect.t)
    let colors = field t "fColors" (ptr Color.t)
    let () = seal t
  end

  module Clip_op = struct
    type t =
      [ `Difference
      | `Intersect
      ]

    let t : t typ =
      skia_c_enum
        "CLIPOP"
        "sk_clipop_t"
        [ `Difference, "DIFFERENCE"; `Intersect, "INTERSECT" ]
  end

  module Encoded_image_format = struct
    type t =
      [ `Bmp
      | `Gif
      | `Ico
      | `Jpeg
      | `Png
      | `Wbmp
      | `Webp
      | `Pkm
      | `Ktx
      | `Astc
      | `Dng
      | `Heif
      | `Avif
      | `Jpegxl
      ]

    let t : t typ =
      skia_c_enum
        "ENCODED_FORMAT"
        "sk_encoded_image_format_t"
        [ `Bmp, "BMP"
        ; `Gif, "GIF"
        ; `Ico, "ICO"
        ; `Jpeg, "JPEG"
        ; `Png, "PNG"
        ; `Wbmp, "WBMP"
        ; `Webp, "WEBP"
        ; `Pkm, "PKM"
        ; `Ktx, "KTX"
        ; `Astc, "ASTC"
        ; `Dng, "DNG"
        ; `Heif, "HEIF"
        ; `Avif, "AVIF"
        ; `Jpegxl, "JPEGXL"
        ]
  end

  module Image_caching_hint = struct
    type t =
      [ `Allow
      | `Disallow
      ]

    let t : t typ =
      skia_c_enum
        "IMAGE_CACHING_HINT"
        "sk_image_caching_hint_t"
        [ `Allow, "ALLOW"; `Disallow, "DISALLOW" ]
  end

  module Runtime_effect = struct
    type t

    let t : t structure typ = structure "sk_runtimeeffect_t"

    type uniform_type =
      [ `Float
      | `Float2
      | `Float3
      | `Float4
      | `Float2x2
      | `Float3x3
      | `Float4x4
      | `Int
      | `Int2
      | `Int3
      | `Int4
      ]

    let uniform_type : uniform_type typ =
      skia_c_enum
        "RUNTIMEEFFECT_UNIFORM_TYPE"
        "sk_runtimeeffect_uniform_type_t"
        [ `Float, "FLOAT"
        ; `Float2, "FLOAT2"
        ; `Float3, "FLOAT3"
        ; `Float4, "FLOAT4"
        ; `Float2x2, "FLOAT2X2"
        ; `Float3x3, "FLOAT3X3"
        ; `Float4x4, "FLOAT4X4"
        ; `Int, "INT"
        ; `Int2, "INT2"
        ; `Int3, "INT3"
        ; `Int4, "INT4"
        ]

    type child_type =
      [ `Shader
      | `Color_filter
      | `Blender
      ]

    let child_type : child_type typ =
      skia_c_enum
        "RUNTIMEEFFECT_CHILD_TYPE"
        "sk_runtimeeffect_child_type_t"
        [ `Shader, "SHADER"
        ; `Color_filter, "COLOR_FILTER"
        ; `Blender, "BLENDER"
        ]

    type uniform_flags = Unsigned.uint32

    let uniform_flags = uint32_t

    type uniform

    let uniform : uniform structure typ = structure "sk_runtimeeffect_uniform_t"
    let uniform = typedef uniform "sk_runtimeeffect_uniform_t"
    let name = field uniform "fName" string
    let name_length = field uniform "fNameLength" size_t
    let offset = field uniform "fOffset" size_t
    let uniform_type_field = field uniform "fType" uniform_type
    let count = field uniform "fCount" int
    let flags = field uniform "fFlags" uniform_flags
    let () = seal uniform

    type child

    let child : child structure typ = structure "sk_runtimeeffect_child_t"
    let child = typedef child "sk_runtimeeffect_child_t"
    let child_name = field child "fName" string
    let child_name_length = field child "fNameLength" size_t
    let child_type_field = field child "fType" child_type
    let index = field child "fIndex" int
    let () = seal child
  end

  module Canvas = struct
    type t

    let t : t structure typ = structure "sk_canvas_t"

    type save_layer_rec_flags = Unsigned.uint32

    let save_layer_rec_flags = uint32_t

    type save_layer_rec

    let save_layer_rec : save_layer_rec structure typ =
      structure "sk_canvas_savelayerrec_t"

    let save_layer_rec = typedef save_layer_rec "sk_canvas_savelayerrec_t"
    let bounds = field save_layer_rec "fBounds" (ptr Rect.t)
    let paint = field save_layer_rec "fPaint" (ptr Paint.t)
    let backdrop = field save_layer_rec "fBackdrop" (ptr Image_filter.t)
    let flags = field save_layer_rec "fFlags" save_layer_rec_flags
    let () = seal save_layer_rec
  end

  module Gr = struct
    type surface_origin =
      [ `Top_left
      | `Bottom_left
      ]

    let surface_origin : surface_origin typ =
      skia_c_enum_no_prefix
        "GR_SURFACE_ORIGIN"
        "gr_surfaceorigin_t"
        [ `Top_left, "TOP_LEFT"; `Bottom_left, "BOTTOM_LEFT" ]

    module Context = struct
      type t

      let t : t structure typ = structure "gr_direct_context_t"

      module Options = struct
        type t

        let t : t structure typ = structure "gr_context_options_t"
        let t = typedef t "gr_context_options_t"
        let avoid_stencil_buffers = field t "fAvoidStencilBuffers" bool
        let runtime_program_cache_size = field t "fRuntimeProgramCacheSize" int

        let glyph_cache_texture_maximum_bytes =
          field t "fGlyphCacheTextureMaximumBytes" size_t

        let allow_path_mask_caching = field t "fAllowPathMaskCaching" bool
        let do_manual_mipmapping = field t "fDoManualMipmapping" bool
        let buffer_map_threshold = field t "fBufferMapThreshold" int
        let () = seal t
      end
    end

    module Recording_context = struct
      type t

      let t : t structure typ = structure "gr_recording_context_t"
    end

    module Backend = struct
      type t

      let t : t structure typ = structure "gr_backend_t"

      type backend_type =
        [ `OpenGL
        | `Vulkan
        | `Metal
        | `Direct3D
        | `Unsupported
        ]

      let backend_type : backend_type typ =
        skia_c_enum_no_prefix
          "GR_BACKEND"
          "gr_backend_t"
          [ `OpenGL, "OPENGL"
          ; `Vulkan, "VULKAN"
          ; `Metal, "METAL"
          ; `Direct3D, "DIRECT3D"
          ; `Unsupported, "UNSUPPORTED"
          ]
    end

    module Backend_render_target = struct
      type t

      let t : t structure typ = structure "gr_backendrendertarget_t"
    end

    module Backend_texture = struct
      type t

      let t : t structure typ = structure "gr_backendtexture_t"
    end
  end
end
