module F = Oski_ffi.M
module T = Oski_types.M

type backend = T.Graphite.backend

let backend_is_available (backend : backend) =
  F.Graphite.backend_is_available backend

module Read_pixels_result = struct
  type t = F.Read_pixels_result.t

  let get_row_bytes t =
    F.Read_pixels_result.get_row_bytes t |> Unsigned.Size_t.to_int

  (** [to_bigarray t ~height] returns a zero-copy, row-major view of its
      pixels. The view contains [get_row_bytes t * height] bytes. Pass the
      height used for [dst_info], since [t] does not store it. The view
      remains valid until [delete t]. *)
  let to_bigarray t ~height =
    let row_bytes = get_row_bytes t in
    let char_ptr =
      Ctypes.from_voidp Ctypes.char (F.Read_pixels_result.get_data t)
    in
    Ctypes.bigarray_of_ptr
      Ctypes.array1
      (row_bytes * height)
      Bigarray.char
      char_ptr

  let delete = F.Read_pixels_result.delete
end

module Context = struct
  type t = F.Graphite.context

  let get_backend = F.Graphite.context_get_backend
  let is_device_lost = F.Graphite.context_is_device_lost

  let get_max_texture_size t =
    F.Graphite.context_get_max_texture_size t |> Int32.to_int

  let free_gpu_resources = F.Graphite.context_free_gpu_resources

  (** No finalizer is installed. Release every recorder, recording, and
      surface created from the context before calling [delete]. *)
  let delete = F.Graphite.context_delete

  let make_recorder ?(budget_bytes = -1L) t =
    F.Graphite.context_make_recorder t budget_bytes None

  let insert_recording
        t
        ~recording
        ?target_surface
        ?(translation_x = 0)
        ?(translation_y = 0)
        ?clip
        ()
    =
    let info = Ctypes.make T.Graphite.insert_recording_info in
    Ctypes.setf info T.Graphite.recording_field recording;
    Ctypes.setf
      info
      T.Graphite.target_surface
      (match target_surface with
      | None -> Ctypes.from_voidp T.Surface.t Ctypes.null
      | Some s -> s);
    Ctypes.setf
      info
      T.Graphite.target_translation_x
      (Int32.of_int translation_x);
    Ctypes.setf
      info
      T.Graphite.target_translation_y
      (Int32.of_int translation_y);
    let clip = Option.value clip ~default:Irect.empty in
    Ctypes.setf info T.Graphite.target_clip (Irect.to_native clip);
    F.Graphite.context_insert_recording t (Ctypes.addr info)

  let submit ?(sync = false) ?(mark_boundary = false) ?(frame_id = 0L) t =
    let info = Ctypes.make T.Graphite.submit_info in
    Ctypes.setf info T.Graphite.sync sync;
    Ctypes.setf info T.Graphite.mark_boundary mark_boundary;
    Ctypes.setf info T.Graphite.frame_id (Unsigned.UInt64.of_int64 frame_id);
    F.Graphite.context_submit t (Ctypes.addr info)

  (* Graphite readback is asynchronous. The C++ wrapper polls
     checkAsyncWorkCompletion and copies the result before Skia invalidates
     it. *)
  let read_pixels_sync
        ?(max_iterations = 1_000_000)
        ?(gamma = `Src)
        ?(mode = `Nearest)
        t
        surface
        ~dst_info
        ~src_rect
    =
    F.Read_pixels_result.context_read_pixels_sync
      t
      surface
      (Image_info.to_native dst_info)
      (Irect.to_native_ptr src_rect)
      gamma
      mode
      (Int32.of_int max_iterations)
end

module Recorder = struct
  type t = F.Graphite.recorder

  (** No finalizer is installed; call [delete] when finished. *)
  let delete = F.Graphite.recorder_delete

  let snap = F.Graphite.recorder_snap
end

module Recording = struct
  type t = F.Graphite.recording

  (** No finalizer is installed; call [delete] when finished. *)
  let delete = F.Graphite.recording_delete
end

let make_render_target recorder info ?(mipmapped = false) () =
  let props = Ctypes.from_voidp T.Surface_props.t Ctypes.null in
  match
    F.Graphite.surface_make_render_target
      recorder
      (Image_info.to_native info)
      mipmapped
      props
  with
  | None ->
    invalid_arg
      "Graphite.make_render_target: failed to allocate GPU render target"
  | Some surface ->
    Gc.finalise F.Surface.unref surface;
    surface
