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

let tests =
  [ ( "Color"
    , [ "color make rgb", `Quick, test_color_make_rgba
      ; "color hsv convertion", `Quick, test_color_convert_hsv
      ] )
  ]
