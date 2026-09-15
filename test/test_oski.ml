let test_color_make_rgba () =
  let color = Oski.Color.of_rgb 37 5 0 in
  Alcotest.(check int) "Color's red" 37 (Oski.Color.red color);
  Alcotest.(check int) "Color's green" 5 (Oski.Color.green color);
  Alcotest.(check int) "Color's blue" 0 (Oski.Color.blue color)

let test_color_convert_hsv () =
  (* TODO: this probably better to express in quicktest instead *)
  let color = Oski.Color.of_rgb 37 5 0 in
  let converted = Oski.Color.(to_hsv color |> HSV.to_color 0) in
  Alcotest.(check int)
    "Color to_hsv convertion"
    (Unsigned.UInt32.to_int color)
    (Unsigned.UInt32.to_int converted)

let test_vec2_basic () =
  let v1 = Oski.Vec2.make 3. 4. in
  let v2 = Oski.Vec2.make 1. 2. in
  let sum = Oski.Vec2.add v1 v2 in
  Alcotest.(check (float 0.001)) "Vec2 add x" 4. sum.x;
  Alcotest.(check (float 0.001)) "Vec2 add y" 6. sum.y;
  Alcotest.(check (float 0.001)) "Vec2 length" 5. (Oski.Vec2.length v1)

let test_vec3_cross_product () =
  let v1 = Oski.Vec3.make 1. 0. 0. in
  let v2 = Oski.Vec3.make 0. 1. 0. in
  let cross = Oski.Vec3.cross v1 v2 in
  Alcotest.(check (float 0.001)) "Cross product x" 0. cross.x;
  Alcotest.(check (float 0.001)) "Cross product y" 0. cross.y;
  Alcotest.(check (float 0.001)) "Cross product z" 1. cross.z

let test_vec4_dot_product () =
  let v1 = Oski.Vec4.make 1. 2. 3. 4. in
  let v2 = Oski.Vec4.make 2. 3. 4. 5. in
  let dot = Oski.Vec4.dot v1 v2 in
  Alcotest.(check (float 0.001)) "Vec4 dot product" 40. dot

let test_point_integer () =
  let open Oski.Point in
  let p1 = IPoint.make 10 20 in
  let p2 = IPoint.make 5 8 in
  let sum = IPoint.add p1 p2 in
  Alcotest.(check int) "Point add x" 15 sum.x;
  Alcotest.(check int) "Point add y" 28 sum.y

let test_matrix_identity () =
  let identity = Oski.Matrix.identity () in
  Alcotest.(check (float 0.001)) "Matrix identity scale_x" 1. identity.scale_x;
  Alcotest.(check (float 0.001)) "Matrix identity scale_y" 1. identity.scale_y;
  Alcotest.(check (float 0.001)) "Matrix identity persp2" 1. identity.persp2;
  Alcotest.(check (float 0.001)) "Matrix identity skew_x" 0. identity.skew_x

let test_matrix44_identity () =
  let identity = Oski.Matrix44.identity () in
  Alcotest.(check (float 0.001)) "Matrix44 identity m00" 1. identity.m00;
  Alcotest.(check (float 0.001)) "Matrix44 identity m11" 1. identity.m11;
  Alcotest.(check (float 0.001)) "Matrix44 identity m22" 1. identity.m22;
  Alcotest.(check (float 0.001)) "Matrix44 identity m33" 1. identity.m33;
  Alcotest.(check (float 0.001)) "Matrix44 identity m01" 0. identity.m01

let test_rect_geometry () =
  let rect = Oski.Rect.make ~left:10. ~top:20. ~right:30. ~bottom:40. in
  Alcotest.(check (float 0.001)) "Rect width" 20. (Oski.Rect.width rect);
  Alcotest.(check (float 0.001)) "Rect height" 20. (Oski.Rect.height rect);
  Alcotest.(check (float 0.001)) "Rect area" 400. (Oski.Rect.area rect);
  Alcotest.(check (float 0.001)) "Rect center_x" 20. (Oski.Rect.center_x rect)

let test_irect_intersection () =
  let rect1 = Oski.IRect.make ~left:0 ~top:0 ~right:10 ~bottom:10 in
  let rect2 = Oski.IRect.make ~left:5 ~top:5 ~right:15 ~bottom:15 in
  let intersection = Oski.IRect.intersection rect1 rect2 in
  match intersection with
  | Some rect ->
    Alcotest.(check int) "IRect intersection left" 5 rect.left;
    Alcotest.(check int) "IRect intersection right" 10 rect.right;
    Alcotest.(check int) "IRect intersection area" 25 (Oski.IRect.area rect)
  | None -> Alcotest.fail "Expected intersection"

let test_size_operations () =
  let size1 = Oski.Size.make 10. 20. in
  let size2 = Oski.Size.make 5. 8. in
  let sum = Oski.Size.add size1 size2 in
  Alcotest.(check (float 0.001)) "Size add width" 15. sum.w;
  Alcotest.(check (float 0.001)) "Size add height" 28. sum.h;
  Alcotest.(check (float 0.001))
    "Size aspect ratio"
    0.5
    (Oski.Size.aspect_ratio size1)

let test_isize_operations () =
  let isize = Oski.ISize.make 16 9 in
  let ratio = Oski.ISize.aspect_ratio isize in
  Alcotest.(check (float 0.001)) "ISize aspect ratio" (16. /. 9.) ratio;
  Alcotest.(check int) "ISize area" 144 (Oski.ISize.area isize)

let test_rsxform_rotation () =
  let angle = Float.pi /. 4. in
  (* 45 degrees *)
  let rsxform = Oski.RSXform.from_rotation_translation ~angle ~tx:10. ~ty:20. in
  let expected_cos = Float.cos angle in
  let expected_sin = Float.sin angle in
  Alcotest.(check (float 0.001)) "RSXform cos" expected_cos rsxform.scos;
  Alcotest.(check (float 0.001)) "RSXform sin" expected_sin rsxform.ssin;
  Alcotest.(check (float 0.001)) "RSXform tx" 10. rsxform.tx;
  Alcotest.(check (float 0.001)) "RSXform ty" 20. rsxform.ty

let test_conversions () =
  let vec2 = Oski.Vec2.make 10. 20. in
  let size = Oski.Size.of_vec2 vec2 in
  let vec2_back = Oski.Size.to_vec2 size in
  Alcotest.(check (float 0.001)) "Vec2 to Size conversion" vec2.x vec2_back.x;
  Alcotest.(check (float 0.001)) "Vec2 to Size conversion" vec2.y vec2_back.y

let test_font_mgr_count_families () =
  let mgr = Oski.Font_manager.make () in
  let count = Oski.Font_manager.count_families mgr in
  Alcotest.(check bool) "Font manager has families" (count > 0) true

let test_font_mgr_match_family_style () =
  let mgr = Oski.Font_manager.make () in
  let style = Oski.Font_style.make 400 5 `Upright in
  let maybe_typeface = Oski.Font_manager.match_family_style mgr "Arial" style in
  let maybe_name = Option.map Oski.Typeface.get_family_name maybe_typeface in
  Alcotest.(check bool) "Typeface family name" (Option.is_some maybe_name) true

let test_font_mgr_match_family_style_character () =
  let mgr = Oski.Font_manager.make () in
  let style = Oski.Font_style.make 400 5 `Upright in
  (* The emoji 😁 has the Unicode code point U+1F601, which is 128513 in
     decimal. *)
  let emoji = Uchar.of_int 0x1F601 in
  let maybe_typeface =
    Oski.Font_manager.match_family_style_character
      mgr
      "Arial"
      style
      [ "en_US" ]
      emoji
  in
  Alcotest.(check bool)
    "Typeface found for emoji"
    (Option.is_some maybe_typeface)
    true

let test_font_mgr_get_styleset mgr name =
  let maybe_styleset = Oski.Font_manager.match_family mgr name in
  Alcotest.(check bool)
    "Font manager matches Arial family"
    (Option.is_some maybe_styleset)
    true;
  Option.get maybe_styleset

let test_font_mgr_match_family () =
  let mgr = Oski.Font_manager.make () in
  ignore (test_font_mgr_get_styleset mgr "Arial")

let test_font_mgr_styleset_get_count () =
  let mgr = Oski.Font_manager.make () in
  let styleset = test_font_mgr_get_styleset mgr "Arial" in
  let count = Oski.Font_manager.Font_style_set.get_count styleset in
  Alcotest.(check bool) "Font style set count" (count > 0) true;
  for i = 0 to count - 1 do
    let _, maybe_name = Oski.Font_manager.Font_style_set.get_style styleset i in
    Alcotest.(check bool)
      ("Style " ^ string_of_int i ^ " has a name")
      (Option.is_some maybe_name)
      true
  done

let test_font_mgr_styleset_get_style () =
  let mgr = Oski.Font_manager.make () in
  let styleset = test_font_mgr_get_styleset mgr "Arial" in
  let _, maybe_name = Oski.Font_manager.Font_style_set.get_style styleset 0 in
  let valid_names = [ "Regular"; "Bold"; "Italic"; "Bold Italic" ] in
  Alcotest.(check bool)
    "Font style name is valid"
    (Option.is_some maybe_name)
    true;
  let name = Option.get maybe_name in
  (* Check if the name is one of the valid names *)

  Alcotest.(check bool)
    "Font style name is valid"
    (List.mem name valid_names)
    true

let test_path_get_points () =
  let builder = Oski.Path_builder.make () in
  Oski.Path_builder.add_rect
    builder
    (Oski.Rect.make ~left:0. ~top:0. ~right:10. ~bottom:10.)
    ();
  let path = Oski.Path_builder.detach builder in
  let points_count = Oski.Path.count_points path in
  let count, points = Oski.Path.get_points path points_count in
  Alcotest.(check int) "Path get points count" points_count (List.length points);
  Alcotest.(check int) "Path get points returned count" points_count count;
  Alcotest.(check int) "Path get points count" points_count 4

let test_path_effect_filter_path () =
  let builder = Oski.Path_builder.make () in
  Oski.Path_builder.add_rect
    builder
    (Oski.Rect.make ~left:0. ~top:0. ~right:40. ~bottom:40.)
    ();
  let src = Oski.Path_builder.detach builder in
  let matrix = Oski.Matrix.scale ~x:8. ~y:8. in
  let path_effect = Oski.Path_effect.create2d_line ~width:2. ~matrix in
  let stroke_rec = Oski.Stroke_rec.make_fill () in
  match Oski.Path_effect.filter_path path_effect ~stroke_rec src with
  | None -> Alcotest.fail "Path_effect.filter_path returned None"
  | Some result ->
    Alcotest.(check bool)
      "filtered path has points"
      true
      (Oski.Path.count_points result > 0);
    Alcotest.(check bool)
      "filtered path differs from source (2D line effect applied)"
      true
      (Oski.Path.count_verbs result <> Oski.Path.count_verbs src)

let test_surface_draw_and_save_png () =
  let info = Oski.Image_info.make_n32_premul ~width:64 ~height:64 () in
  let surface = Oski.Surface.make_raster info in
  let canvas = Oski.Surface.get_canvas surface in
  Oski.Canvas.clear canvas (Oski.Color.of_argb 255 255 255 255);
  let paint = Oski.Paint.make_fill (Oski.Color.of_argb 255 220 20 60) in
  Oski.Canvas.draw_circle canvas (Oski.Point.make 32. 32.) 20. paint;
  let path = Filename.temp_file "oski_test" ".png" in
  Fun.protect
    ~finally:(fun () -> Sys.remove path)
    (fun () ->
       Oski.Surface.save_png surface path;
       let ic = open_in_bin path in
       let len = in_channel_length ic in
       let signature = really_input_string ic 8 in
       close_in ic;
       Alcotest.(check bool) "PNG file is non-empty" true (len > 8);
       Alcotest.(check string) "PNG signature" "\137PNG\r\n\026\n" signature)

let test_surface_pixels_and_image_roundtrip () =
  let info = Oski.Image_info.make_n32_premul ~width:64 ~height:64 () in
  let surface = Oski.Surface.make_raster info in
  let canvas = Oski.Surface.get_canvas surface in
  Oski.Canvas.clear canvas (Oski.Color.of_argb 255 255 255 255);
  let paint = Oski.Paint.make_fill (Oski.Color.of_argb 255 220 20 60) in
  Oski.Canvas.draw_circle canvas (Oski.Point.make 32. 32.) 20. paint;
  let pixmap =
    match Oski.Surface.peek_pixels surface with
    | Some pixmap -> pixmap
    | None -> Alcotest.fail "Surface.peek_pixels returned None"
  in
  let ba = Oski.Pixmap.to_bigarray pixmap in
  Alcotest.(check int)
    "bigarray size matches row_bytes * height"
    (Oski.Pixmap.row_bytes pixmap * Oski.Pixmap.height pixmap)
    (Bigarray.Array1.dim ba);
  let expected = Oski.Color.of_argb 255 220 20 60 in
  Alcotest.(check bool)
    "center pixel matches the drawn color"
    true
    (Oski.Pixmap.get_pixel_color pixmap ~x:32 ~y:32 = expected);
  let path = Filename.temp_file "oski_test" ".png" in
  Fun.protect
    ~finally:(fun () -> Sys.remove path)
    (fun () ->
       Oski.Surface.save_png surface path;
       let image =
         match Oski.Image.of_file path with
         | Some image -> image
         | None -> Alcotest.fail "Image.of_file returned None"
       in
       Alcotest.(check int) "loaded image width" 64 (Oski.Image.width image);
       Alcotest.(check int) "loaded image height" 64 (Oski.Image.height image);
       let surface2 = Oski.Surface.make_raster info in
       let canvas2 = Oski.Surface.get_canvas surface2 in
       Oski.Canvas.clear canvas2 (Oski.Color.of_argb 255 0 0 0);
       Oski.Canvas.draw_image canvas2 image (Oski.Point.make 0. 0.);
       let pixmap2 =
         match Oski.Surface.peek_pixels surface2 with
         | Some pixmap -> pixmap
         | None -> Alcotest.fail "Surface.peek_pixels (surface2) returned None"
       in
       Alcotest.(check bool)
         "center pixel matches after PNG round-trip + draw_image"
         true
         (Oski.Pixmap.get_pixel_color pixmap2 ~x:32 ~y:32 = expected))

(* Graphite+Vulkan needs an actual GPU, a Vulkan loader able to find a working
   ICD, and Skia to have been compiled with SUPPORT_GRAPHITE=true
   SUPPORT_VULKAN=true (see CLAUDE.md) -- none of which are guaranteed in every
   environment this test suite runs in. Every step below degrades to a printed
   note (test still passes) rather than a hard failure when that's the case,
   since it reflects the environment, not a bug. *)
let test_graphite_vulkan_render_and_read_pixels () =
  match Oski.Graphite_vk.Device.make () with
  | None -> print_endline "  (skipped: no Vulkan device available)"
  | Some device ->
    (match Oski.Graphite_vk.make_context device with
    | None -> print_endline "  (skipped: Graphite+Vulkan context unavailable)"
    | Some context ->
      Fun.protect
        ~finally:(fun () -> Oski.Graphite.Context.delete context)
        (fun () ->
           match Oski.Graphite.Context.make_recorder context with
           | None ->
             Alcotest.fail "Graphite.Context.make_recorder returned None"
           | Some recorder ->
             Fun.protect
               ~finally:(fun () -> Oski.Graphite.Recorder.delete recorder)
               (fun () ->
                  let info =
                    Oski.Image_info.make_n32_premul ~width:64 ~height:64 ()
                  in
                  let surface =
                    Oski.Graphite.make_render_target recorder info ()
                  in
                  let canvas = Oski.Surface.get_canvas surface in
                  Oski.Canvas.clear canvas (Oski.Color.of_argb 255 255 255 255);
                  let paint =
                    Oski.Paint.make_fill (Oski.Color.of_argb 255 220 20 60)
                  in
                  Oski.Canvas.draw_circle
                    canvas
                    (Oski.Point.make 32. 32.)
                    20.
                    paint;
                  match Oski.Graphite.Recorder.snap recorder with
                  | None -> Alcotest.fail "Graphite.Recorder.snap returned None"
                  | Some recording ->
                    Fun.protect
                      ~finally:(fun () ->
                        Oski.Graphite.Recording.delete recording)
                      (fun () ->
                         let status =
                           Oski.Graphite.Context.insert_recording
                             context
                             ~recording
                             ()
                         in
                         Alcotest.(check bool)
                           "insert_recording succeeds"
                           true
                           (status = `Success);
                         Alcotest.(check bool)
                           "submit succeeds"
                           true
                           (Oski.Graphite.Context.submit ~sync:true context);
                         let dst_info = info in
                         let src_rect =
                           Oski.IRect.make ~left:0 ~top:0 ~right:64 ~bottom:64
                         in
                         match
                           Oski.Graphite.Context.read_pixels_sync
                             context
                             surface
                             ~dst_info
                             ~src_rect
                         with
                         | None ->
                           Alcotest.fail "read_pixels_sync returned None"
                         | Some result ->
                           Fun.protect
                             ~finally:(fun () ->
                               Oski.Graphite.Read_pixels_result.delete result)
                             (fun () ->
                                let ba =
                                  Oski.Graphite.Read_pixels_result.to_bigarray
                                    result
                                    ~height:64
                                in
                                let row_bytes =
                                  Oski.Graphite.Read_pixels_result.get_row_bytes
                                    result
                                in
                                let off = (32 * row_bytes) + (32 * 4) in
                                let byte i =
                                  Char.code (Bigarray.Array1.get ba (off + i))
                                in
                                Alcotest.(check (list int))
                                  "center pixel is opaque crimson (R,G,B,A)"
                                  [ 220; 20; 60; 255 ]
                                  [ byte 0; byte 1; byte 2; byte 3 ])))))

let test_document_pdf () =
  let path = Filename.temp_file "oski_test" ".pdf" in
  Fun.protect
    ~finally:(fun () -> Sys.remove path)
    (fun () ->
       let metadata =
         { Oski.Document.default_metadata with
           title = Some "Oski Test Document"
         }
       in
       let doc = Oski.Document.make_pdf_to_file ~metadata path in
       Oski.Document.with_page doc ~width:100. ~height:100. (fun canvas ->
         Oski.Canvas.clear canvas (Oski.Color.of_argb 255 255 255 255);
         let paint = Oski.Paint.make_fill (Oski.Color.of_argb 255 220 20 60) in
         Oski.Canvas.draw_rect
           canvas
           (Oski.Rect.make ~left:10. ~top:10. ~right:90. ~bottom:90.)
           paint);
       Oski.Document.close doc;
       let ic = open_in_bin path in
       let len = in_channel_length ic in
       let signature = really_input_string ic 5 in
       close_in ic;
       Alcotest.(check bool) "PDF file is non-empty" true (len > 5);
       Alcotest.(check string) "PDF signature" "%PDF-" signature)

let tests =
  [ ( "Color"
    , [ "color make rgb", `Quick, test_color_make_rgba
      ; "color hsv convertion", `Quick, test_color_convert_hsv
      ] )
  ; "Vec2", [ "vec2 basic operations", `Quick, test_vec2_basic ]
  ; "Vec3", [ "vec3 cross product", `Quick, test_vec3_cross_product ]
  ; "Vec4", [ "vec4 dot product", `Quick, test_vec4_dot_product ]
  ; "Point", [ "point integer operations", `Quick, test_point_integer ]
  ; "Matrix", [ "matrix identity", `Quick, test_matrix_identity ]
  ; "Matrix44", [ "matrix44 identity", `Quick, test_matrix44_identity ]
  ; "Rect", [ "rect geometry", `Quick, test_rect_geometry ]
  ; "IRect", [ "irect intersection", `Quick, test_irect_intersection ]
  ; "Size", [ "size operations", `Quick, test_size_operations ]
  ; "ISize", [ "isize operations", `Quick, test_isize_operations ]
  ; "RSXform", [ "rsxform rotation", `Quick, test_rsxform_rotation ]
  ; "Conversions", [ "type conversions", `Quick, test_conversions ]
  ; ( "Font_manager"
    , [ "match family style", `Quick, test_font_mgr_match_family_style
      ; "match family", `Quick, test_font_mgr_match_family
      ; "count families", `Quick, test_font_mgr_count_families
      ; ( "match family style character"
        , `Quick
        , test_font_mgr_match_family_style_character )
      ; "Font styleset get style", `Quick, test_font_mgr_styleset_get_style
      ; "Font styleset get count", `Quick, test_font_mgr_styleset_get_count
      ] )
  ; "Path", [ "get points", `Quick, test_path_get_points ]
  ; "Path_effect", [ "filter_path", `Quick, test_path_effect_filter_path ]
  ; ( "Surface"
    , [ "draw and save png", `Quick, test_surface_draw_and_save_png
      ; ( "pixels and image round-trip"
        , `Quick
        , test_surface_pixels_and_image_roundtrip )
      ] )
  ; "Document", [ "create pdf", `Quick, test_document_pdf ]
  ; ( "Graphite"
    , [ ( "vulkan render and read pixels"
        , `Quick
        , test_graphite_vulkan_render_and_read_pixels )
      ] )
  ]
