module F = Oski_ffi.M
module T = Oski_types.M

module Device = struct
  type t = F.Vk_device.t

  (** [make ()] creates a headless Vulkan instance, device, and graphics
      queue for [make_context]. Applications that render to windows should
      provide their own Vulkan setup. Returns [None] if Vulkan initialization
      fails. Available only on Linux. *)
  let make () =
    match F.Vk_device.make () with
    | None -> None
    | Some dev ->
      Gc.finalise F.Vk_device.delete dev;
      Some dev

  let to_native t = t
end

let make_context ?(protected_context = false) (device : Device.t) =
  let init = Ctypes.make T.Graphite_vk.backend_context_init in
  Ctypes.setf init T.Graphite_vk.instance (F.Vk_device.get_instance device);
  Ctypes.setf
    init
    T.Graphite_vk.physical_device
    (F.Vk_device.get_physical_device device);
  Ctypes.setf init T.Graphite_vk.device (F.Vk_device.get_device device);
  Ctypes.setf init T.Graphite_vk.queue (F.Vk_device.get_queue device);
  Ctypes.setf
    init
    T.Graphite_vk.graphics_queue_index
    (F.Vk_device.get_queue_family_index device);
  Ctypes.setf
    init
    T.Graphite_vk.max_api_version
    (F.Vk_device.get_api_version device);
  Ctypes.setf init T.Graphite_vk.get_proc_field (F.Vk_device.get_proc_fn ());
  Ctypes.setf
    init
    T.Graphite_vk.get_proc_user_data
    (Ctypes.from_voidp Ctypes.void Ctypes.null);
  Ctypes.setf init T.Graphite_vk.protected_context protected_context;
  let default_options =
    Ctypes.from_voidp T.Graphite.context_options Ctypes.null
  in
  F.Graphite_vk.context_make_vulkan init default_options
