module M (F : Ctypes.TYPE) = struct
  let skia_c_enum name mapping =
    F.enum
      name
      ~typedef:true
      ~unexpected:(fun i ->
        invalid_arg (Printf.sprintf "Unsupported %s enum: %Ld" name i))
      (mapping
      |> List.map (fun (constructor, constant_name) ->
        constructor, F.constant constant_name F.int64_t))

  module Color = struct
    let t = F.uint32_t
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
end
