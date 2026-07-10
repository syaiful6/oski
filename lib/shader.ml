module F = Oski_ffi.M

type t = F.Shader.t
type tile_mode = F.Shader.tile_mode

let of_empty () =
  let empty = F.Shader.of_empty () in
  Gc.finalise F.Shader.unref empty;
  empty

let of_linear_gradient2
      ~start_point
      ~stop_point
      ~start_color
      ~stop_color
      ~tile_mode
  =
  let gradient =
    F.Shader.of_linear_gradient2
      (Point.to_native_ptr start_point)
      (Point.to_native_ptr stop_point)
      start_color
      stop_color
      tile_mode
  in
  Gc.finalise F.Shader.unref gradient;
  gradient

type color_stop =
  { color : Color.t
  ; position : float
  }

let of_linear_gradient ~start_point ~stop_point ~color_stops ~tile_mode =
  let colors, positions =
    List.fold_left
      (fun acc curr ->
         let colors, positions = acc in
         let { color; position } = curr in
         color :: colors, position :: positions)
      ([], [])
      color_stops
  in
  Ctypes.(
    let colors_arr = CArray.of_list uint32_t (colors |> List.rev) in
    let positions_arr = CArray.of_list float (positions |> List.rev) in

    let gradient =
      F.Shader.of_linear_gradient
        (Point.to_native_ptr start_point)
        (Point.to_native_ptr stop_point)
        (CArray.start colors_arr)
        (CArray.start positions_arr)
        (CArray.length colors_arr)
        tile_mode
    in
    Gc.finalise F.Shader.unref gradient;
    gradient)
