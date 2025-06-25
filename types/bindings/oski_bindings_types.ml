open Ctypes

module M (F : Ctypes.TYPE) = struct
  open F

  let skia_c_enum name mapping =
    enum
      name
      ~typedef:true
      ~unexpected:(fun i ->
        invalid_arg (Printf.sprintf "Unsupported %s enum: %Ld" name i))
      (mapping
      |> List.map (fun (constructor, constant_name) ->
        constructor, constant constant_name int64_t))

  module Color = struct
    let t = uint32_t
  end

  module FontStyle = struct
    type t

    let t : t structure typ = F.structure "sk_fontstyle_t"

    type slant =
      | Upright
      | Italic
      | Oblique

    let slant =
      skia_c_enum
        "sk_font_style_slant_t"
        [ Upright, "UPRIGHT_SK_FONT_STYLE_SLANT"
        ; Italic, "ITALIC_SK_FONT_STYLE_SLANT"
        ; Oblique, "OBLIQUE_SK_FONT_STYLE_SLANT"
        ]

    type set

    let set : set structure typ = F.structure "sk_fontstyleset_t"
    let set = typedef set "sk_fontstyleset_t"
  end

  module TextEncoding = struct
    type t =
      | Utf8
      | Utf16
      | Utf32
      | GlyphId

    let t =
      skia_c_enum
        "sk_text_encoding_t"
        [ Utf8, "UTF8_SK_TEXT_ENCODING"
        ; Utf16, "UTF16_SK_TEXT_ENCODING"
        ; Utf32, "UTF32_SK_TEXT_ENCODING"
        ; GlyphId, "GLYPH_ID_SK_TEXT_ENCODING"
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
        "sk_font_hinting_t"
        [ `nohint, "NONE_SK_FONT_HINTING"
        ; `slight, "SLIGHT_SK_FONT_HINTING"
        ; `normal, "NORMAL_SK_FONT_HINTING"
        ; `full, "FULL_SK_FONT_HINTING"
        ]
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
end
