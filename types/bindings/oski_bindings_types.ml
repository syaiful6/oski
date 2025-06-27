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

  module FillType = struct
    type t =
      [ `Winding
      | `Even_odd
      | `Inverse_winding
      | `Inverse_even_odd
      ]

    let t : t typ =
      skia_c_enum
        "PATH_FILLTYPE"
        "sk_path_filltype_t"
        [ `Winding, "WINDING"
        ; `Even_odd, "EVENODD"
        ; `Inverse_winding, "INVERSE_WINDING"
        ; `Inverse_even_odd, "INVERSE_EVENODD"
        ]
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
end
