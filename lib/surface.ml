module F = Oski_ffi.M
module T = Oski_types.M

type t = F.Surface.t

external to_native : t -> F.Surface.t = "%identity"

let make_raster ?(row_bytes = 0) info =
  let props = Ctypes.from_voidp T.Surface_props.t Ctypes.null in
  match
    F.Surface.make_raster
      (Image_info.to_native info)
      (Unsigned.Size_t.of_int row_bytes)
      props
  with
  | None -> invalid_arg "Surface.make_raster: failed to allocate raster surface"
  | Some surface ->
    Gc.finalise F.Surface.unref surface;
    surface

let get_canvas t = F.Surface.get_canvas t

let peek_pixels t =
  let pixmap = Pixmap.make () in
  if F.Surface.peek_pixels t pixmap then Some pixmap else None

let save_png ?(zlib_level = 6) ?(filter_flags = `All) t path =
  let pixmap = F.Pixmap.make () in
  Gc.finalise F.Pixmap.delete pixmap;
  if not (F.Surface.peek_pixels t pixmap)
  then
    invalid_arg "Surface.save_png: surface pixels are not directly accessible";
  match F.File_wstream.make path with
  | None ->
    invalid_arg
      (Printf.sprintf "Surface.save_png: could not open %s for writing" path)
  | Some file ->
    Fun.protect
      ~finally:(fun () -> F.File_wstream.delete file)
      (fun () ->
         if not (F.File_wstream.is_valid file)
         then
           invalid_arg
             (Printf.sprintf
                "Surface.save_png: could not open %s for writing"
                path);
         let wstream = F.File_wstream.as_wstream file in
         let options = F.Png_encoder.Options.make ~filter_flags ~zlib_level in
         if not (F.Png_encoder.encode wstream pixmap options)
         then invalid_arg "Surface.save_png: PNG encoding failed";
         F.WStream.flush wstream)
