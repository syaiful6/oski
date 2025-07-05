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

  module Color = struct
    let t = uint32_t
  end

  module PMColor = struct
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

  module ColorType = struct
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

  module AlphaType = struct
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

  module PixelGeometry = struct
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

  module SurfaceProps = struct
    type flag = Unsigned.uint32

    let flag = Ctypes.uint32_t

    type t

    let t : t structure typ = structure "sk_surfaceprops_t"
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

  module Canvas = struct
    type t

    let t : t structure typ = structure "sk_canvas_t"
  end

  module Drawable = struct
    type t

    let t : t structure typ = structure "sk_drawable"
  end

  module Image = struct
    type t

    let t : t structure typ = structure "sk_image_t"
  end

  module MaskFilter = struct
    type t

    let t : t structure typ = structure "sk_maskfilter_t"
  end

  module Paint = struct
    type t

    let t : t structure typ = structure "sk_paint_t"
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

  module PathMeasure = struct
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

  module Picture = struct
    type t

    let t : t structure typ = structure "sk_picture_t"

    type recorder

    let recorder : recorder structure typ = structure "sk_picture_recorder_t"
  end

  module BbhFactory = struct
    type t

    let t : t structure typ = structure "sk_bbh_factory_t"
  end

  module RtreeFactory = struct
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

  module FontStyle = struct
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

    let set : set structure typ = F.structure "sk_fontstyleset_t"
    let set = typedef set "sk_fontstyleset_t"
  end

  module Codec = struct
    type t

    let t : t structure typ = structure "sk_codec_t"
  end

  module ColorSpace = struct
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

  module ImageInfo = struct
    type t

    let t : t structure typ = structure "sk_imageinfo_t"
    let t = typedef t "sk_imageinfo_t"
    let colorspace = field t "colorspace" (ptr ColorSpace.t)
    let width = field t "width" int32_t
    let height = field t "height" int32_t
    let color_type = field t "colorType" ColorType.t
    let alpha_type = field t "alphaType" AlphaType.t
    let () = seal t
  end

  module Blendmode = struct
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

  module TextEncoding = struct
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

  module TextAlign = struct
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

  module ColorChannel = struct
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

    let t : t structure F.typ = F.structure "sk_data_t"
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

  module Document = struct
    type t

    let t : t structure typ = structure "sk_document_t"
  end

  module PointMode = struct
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

  module String = struct
    type t

    let t : t structure typ = structure "sk_string_t"
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
  end

  module Typeface = struct
    type t

    let t : t structure typ = structure "sk_typeface_t"

    type id = Unsigned.uint32

    let id = uint32_t

    type font_table_tag = Unsigned.uint32

    let font_table_tag = uint32_t
  end

  module FontManager = struct
    type t

    let t : t structure typ = structure "sk_fontmgr_t"
  end

  module FontMetrics = struct
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

  module Bitmap = struct
    type t

    let t : t structure typ = structure "sk_bitmap_t"
  end

  module Pixmap = struct
    type t

    let t : t structure typ = structure "sk_pixmap_t"
  end

  module ColorFilter = struct
    type t

    let t : t structure typ = structure "sk_colorfilter_t"
  end

  module ImageFilter = struct
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
end
