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
  let p1 = Oski.Point.make 10 20 in
  let p2 = Oski.Point.make 5 8 in
  let sum = Oski.Point.add p1 p2 in
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
  ]
