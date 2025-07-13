open Oski_ffi.M

let flt_min = 0x1.0p-1022
let flt_max = 0x1.F_FFFF_FFFF_FFFFp+1023
let flt_epsilon = 0x1.0p-52

(* Relative floating-poit comparison using Knuth's algorithm *)
let float_testable epsilon =
  let pp ppf f = Format.fprintf ppf "%g" f in
  let equal a b =
    if Float.equal a b
    then true
    else
      let diff = Float.abs (a -. b) in
      if Float.equal a 0. || Float.equal b 0. || diff < flt_min
      then
        (* very close to zero, scale the epsilon for denormalized numbers *)
        2.0 *. diff < epsilon *. flt_min
      else
        let sum = Float.abs a +. Float.abs b in
        (2.0 *. diff /. if sum > flt_max then flt_max else sum) < epsilon
  in
  Alcotest.testable pp equal

let float_nearly_equal = float_testable (3.0 *. flt_epsilon)

let test_matrix_set_translate () =
  let matrix = Matrix.make () in
  Matrix.set_translate matrix 8.0 16.0;
  let vector = Vector.make 0. 0. in
  Matrix.map_xy matrix 1. 2. vector;
  Alcotest.(check float_nearly_equal)
    "Matrix x translation"
    9.0
    (Vector.get_x vector);
  Alcotest.(check float_nearly_equal)
    "Matrix y translation"
    18.0
    (Vector.get_y vector)

let test_matrix_set_scale () =
  let matrix = Matrix.make () in
  Matrix.set_scale matrix 3. 4. 0. 0.;

  let vector = Vector.make 0. 0. in
  Matrix.map_xy matrix 1. 2. vector;

  Alcotest.(check float_nearly_equal) "Matrix x scale" 3.0 (Vector.get_x vector);
  Alcotest.(check float_nearly_equal) "Matrix y scale" 8.0 (Vector.get_y vector)

let test_font_manager_count_families () =
  let fontmgr = Font_manager.ref_default () in
  Gc.finalise Font_manager.unref fontmgr;
  let count = Font_manager.count_families fontmgr in
  Alcotest.(check bool)
    "Font_manager.count_families expected to returns at least 1 families"
    true
    (count > 0)

let test_font_manager_match_family_style () =
  let fontmgr = Font_manager.ref_default () in
  Gc.finalise Font_manager.unref fontmgr;
  let style = Font_style.make 400 5 `Upright in
  Gc.finalise Font_style.delete style;
  let maybe_typeface = Font_manager.match_family_style fontmgr "Arial" style in
  Alcotest.(check bool)
    "Font_manager.match_family_style Arial not found"
    true
    (Option.is_some maybe_typeface);

  match maybe_typeface with
  | None -> ()
  | Some typeface -> Typeface.unref typeface

let () =
  Alcotest.run
    "FFI"
    [ ( "Matrix"
      , [ "set translate", `Quick, test_matrix_set_translate
        ; "set scale", `Quick, test_matrix_set_scale
        ] )
    ; ( "Font manager"
      , [ "Count families", `Quick, test_font_manager_count_families
        ; "match family styles", `Quick, test_font_manager_match_family_style
        ] )
    ]
