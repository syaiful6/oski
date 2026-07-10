type t = Oski_ffi.M.Text_blob_builder.t

let make () =
  let builder = Oski_ffi.M.Text_blob_builder.make () in
  Gc.finalise Oski_ffi.M.Text_blob_builder.delete builder;
  builder

let with_builder fn =
  let builder = Oski_ffi.M.Text_blob_builder.make () in
  Fun.protect
    ~finally:(fun () -> Oski_ffi.M.Text_blob_builder.delete builder)
    (fun () -> fn builder)

let build builder =
  match Oski_ffi.M.Text_blob_builder.build builder with
  | Some text_blob ->
    Gc.finalise Oski_ffi.M.Text_blob.unref text_blob;
    Some text_blob
  | None -> None

external to_native : t -> Oski_ffi.M.Text_blob_builder.t = "%identity"

type shape =
  { glyph_id : int
  ; cluster : int
  ; x_advance : float
  ; y_advance : float
  ; x_offset : float
  ; y_offset : float
  ; units_per_em : float
  }

let alloc_run ~font ~glyphs ?bounds ?(x = 0.) ?(y = 0.) builder =
  let count = List.length glyphs in
  let run_buffer = Oski_ffi.M.Text_blob_builder.Run_buffer.make () in
  Oski_ffi.M.Text_blob_builder.alloc_run
    builder
    (Font.to_native font)
    count
    x
    y
    (Option.map Rect.to_native_ptr bounds)
    run_buffer;
  let glyphs_ptr =
    Ctypes.CArray.from_ptr
      (Ctypes.coerce
         (Ctypes.ptr Ctypes.void)
         (Ctypes.ptr Ctypes.uint16_t)
         (Oski_ffi.M.Text_blob_builder.Run_buffer.glyphs run_buffer))
      count
  in
  List.iteri
    (fun i glyph ->
       Ctypes.CArray.set glyphs_ptr i (Unsigned.UInt16.of_int glyph))
    glyphs

let alloc_run_pos
      ~font
      ~font_size
      ~shapes
      ?bounds
      ~base_line_x
      ~base_line_y
      builder
  =
  let count = List.length shapes in
  let run_buffer = Oski_ffi.M.Text_blob_builder.Run_buffer.make () in
  Oski_ffi.M.Text_blob_builder.alloc_run_pos
    builder
    (Font.to_native font)
    count
    (Option.map Rect.to_native_ptr bounds)
    run_buffer;
  let glyphs_ptr =
    Ctypes.CArray.from_ptr
      (Ctypes.coerce
         (Ctypes.ptr Ctypes.void)
         (Ctypes.ptr Ctypes.uint16_t)
         (Oski_ffi.M.Text_blob_builder.Run_buffer.glyphs run_buffer))
      count
  in
  let pos_carray =
    Ctypes.CArray.from_ptr
      (Ctypes.coerce
         (Ctypes.ptr Ctypes.void)
         Oski_ffi.M.Point.t
         (Oski_ffi.M.Text_blob_builder.Run_buffer.pos run_buffer))
      count
  in

  let current_x = ref base_line_x in
  List.iteri
    (fun i shape ->
       Ctypes.CArray.set glyphs_ptr i (Unsigned.UInt16.of_int shape.glyph_id);

       let scale_factor = font_size /. shape.units_per_em in
       let scale_x_offset = shape.x_offset *. scale_factor in
       let scale_y_offset = shape.y_offset *. scale_factor in
       let scale_x_advance = shape.x_advance *. scale_factor in

       let glyph_origin_x = !current_x +. scale_x_offset in
       let glyph_origin_y = base_line_y +. scale_y_offset in

       Ctypes.CArray.set
         pos_carray
         i
         (Point.make glyph_origin_x glyph_origin_y |> Point.to_native);

       current_x := !current_x +. scale_x_advance)
    shapes
