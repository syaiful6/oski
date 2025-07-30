module Color : sig
  module HSV : sig
    type t =
      { h : float
      ; s : float
      ; v : float
      }

    val make : float -> float -> float -> t
    (** [make h s v] return a new HSV color *)

    val to_color : int -> t -> Unsigned.uint32
  end

  module RGB : sig
    type t =
      { r : Unsigned.uint8
      ; g : Unsigned.uint8
      ; b : Unsigned.uint8
      }

    val make : int -> int -> int -> t
    val to_hsv : t -> HSV.t
  end

  type t = Unsigned.uint32

  val of_argb : int -> int -> int -> int -> t
  val of_rgb : int -> int -> int -> t
  val alpha : t -> int
  val red : t -> int
  val green : t -> int
  val blue : t -> int
  val to_rgb : t -> RGB.t
  val to_hsv : t -> HSV.t

  module Color4f : sig
    type t =
      { r : float
      ; g : float
      ; b : float
      ; a : float
      }

    val make : float -> float -> float -> float -> t
    val to_native : t -> Oski_types.M.Color4f.t Ctypes.structure
    val to_native_ptr : t -> Oski_ffi.M.Color4f.t
    val of_native : Oski_types.M.Color4f.t Ctypes.structure -> t
    val of_color : Unsigned.uint32 -> t
    val to_color : t -> Unsigned.uint32
    val transparent : t
    val black : t
    val grey : t
    val light_grey : t
    val white : t
    val red : t
    val green : t
    val blue : t
    val yellow : t
    val cyan : t
    val magenta : t
  end
end

module Vec2 : sig
  type t =
    { x : float
    ; y : float
    }

  val make : float -> float -> t
  (** [make x y] create Vec2.t with pair of float. *)

  val dot : t -> t -> float
  val cross : t -> t -> float
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val mul_float : t -> float -> t
  val scalar_div : t -> float -> t
  val scalar_div2 : float -> t -> t
  val length_squared : t -> float
  val length : t -> float
  val normalize : t -> t
  val is_zero : t -> bool
  val to_native : t -> Oski_types.M.Vector.t Ctypes.structure
  val to_native_ptr : t -> Oski_ffi.M.Vector.t
  val of_native : Oski_types.M.Vector.t Ctypes.structure -> t
end

module Vec3 : sig
  type t =
    { x : float
    ; y : float
    ; z : float
    }

  val make : float -> float -> float -> t
  val to_native : t -> Oski_types.M.Vector3.t Ctypes.structure
  val to_native_ptr : t -> Oski_ffi.M.Vec3.t
  val of_native : Oski_types.M.Vector3.t Ctypes.structure -> t
  val dot : t -> t -> float
  val cross : t -> t -> t
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val mul_float : t -> float -> t
  val scalar_div : t -> float -> t
  val scalar_div2 : float -> t -> t
  val length_squared : t -> float
  val length : t -> float
  val normalize : t -> t
  val is_zero : t -> bool
  val zero : t
  val unit_x : t
  val unit_y : t
  val unit_z : t
end

module Vec4 : sig
  type t =
    { x : float
    ; y : float
    ; z : float
    ; w : float
    }

  val make : float -> float -> float -> float -> t
  val to_native : t -> Oski_types.M.Vector4.t Ctypes.structure
  val of_native : Oski_types.M.Vector4.t Ctypes.structure -> t
  val to_native_ptr : t -> Oski_types.M.Vector4.t Ctypes.structure Ctypes.ptr
  val dot : t -> t -> float
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val mul_float : t -> float -> t
  val scalar_div : t -> float -> t
  val scalar_div2 : float -> t -> t
  val length_squared : t -> float
  val length : t -> float
  val normalize : t -> t
  val is_zero : t -> bool
  val zero : t
  val unit_x : t
  val unit_y : t
  val unit_z : t
  val unit_w : t
end

module Point : sig
  type t =
    { x : float
    ; y : float
    }

  val make : float -> float -> t
  val dot : t -> t -> float
  val cross : t -> t -> float
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val mul_float : t -> float -> t
  val scalar_div : t -> float -> t
  val scalar_div2 : float -> t -> t
  val length_squared : t -> float
  val length : t -> float
  val normalize : t -> t
  val is_zero : t -> bool
  val to_native : t -> Oski_types.M.Point.t Ctypes.structure
  val to_native_ptr : t -> Oski_ffi.M.Point.t
  val of_native : Oski_types.M.Point.t Ctypes.structure -> t

  module IPoint : sig
    type t =
      { x : int
      ; y : int
      }

    val make : int -> int -> t
    val to_native : t -> Oski_types.M.IPoint.t Ctypes.structure
    val of_native : Oski_types.M.IPoint.t Ctypes.structure -> t
    val to_native_ptr : t -> Oski_ffi.M.IPoint.t
    val add : t -> t -> t
    val sub : t -> t -> t
    val mul : t -> t -> t
    val mul_int : t -> int -> t
    val is_zero : t -> bool
    val unit_x : t
    val unit_y : t
    val to_vec2 : t -> Vec2.t
    val of_vec2 : Vec2.t -> t
  end
end

module Size : sig
  type t =
    { w : float
    ; h : float
    }

  val make : float -> float -> t
  val to_native : t -> Oski_types.M.Size.t Ctypes.structure
  val of_native : Oski_types.M.Size.t Ctypes.structure -> t
  val to_native_ptr : t -> Oski_types.M.Size.t Ctypes.structure Ctypes.ptr
  val area : t -> float
  val is_empty : t -> bool
  val is_zero : t -> bool
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val mul_float : t -> float -> t
  val scalar_div : t -> float -> t
  val aspect_ratio : t -> float
  val zero : t
  val unit : t
  val to_vec2 : t -> Vec2.t
  val of_vec2 : Vec2.t -> t
end

module ISize : sig
  type t =
    { w : int
    ; h : int
    }

  val make : int -> int -> t
  val to_native : t -> Oski_types.M.ISize.t Ctypes.structure
  val of_native : Oski_types.M.ISize.t Ctypes.structure -> t
  val to_native_ptr : t -> Oski_types.M.ISize.t Ctypes.structure Ctypes.ptr
  val area : t -> int
  val is_empty : t -> bool
  val is_zero : t -> bool
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val mul_int : t -> int -> t
  val aspect_ratio : t -> float
  val zero : t
  val unit : t
  val to_size : t -> Size.t
  val of_size : Size.t -> t
end

module Rect : sig
  type t =
    { left : float
    ; top : float
    ; right : float
    ; bottom : float
    }

  val make : left:float -> top:float -> right:float -> bottom:float -> t
  val to_native : t -> Oski_types.M.Rect.t Ctypes.structure
  val to_native_ptr : t -> Oski_ffi.M.Rect.t
  val of_native : Oski_types.M.Rect.t Ctypes.structure -> t
  val width : t -> float
  val height : t -> float
  val area : t -> float
  val is_empty : t -> bool
  val center_x : t -> float
  val center_y : t -> float
  val center : t -> Vec2.t
  val contains_point : t -> Vec2.t -> bool
  val intersects : t -> t -> bool
  val intersection : t -> t -> t option
  val union : t -> t -> t
  val empty : t
  val of_xywh : x:float -> y:float -> w:float -> h:float -> t
  val of_center_size : Vec2.t -> Vec2.t -> t
end

module IRect : sig
  type t =
    { left : int
    ; top : int
    ; right : int
    ; bottom : int
    }

  val make : left:int -> top:int -> right:int -> bottom:int -> t
  val to_native : t -> Oski_types.M.IRect.t Ctypes.structure
  val to_native_ptr : t -> Oski_ffi.M.IRect.t
  val of_native : Oski_types.M.IRect.t Ctypes.structure -> t
  val width : t -> int
  val height : t -> int
  val area : t -> int
  val is_empty : t -> bool
  val center_x : t -> int
  val center_y : t -> int
  val center : t -> Point.IPoint.t
  val contains_point : t -> Point.IPoint.t -> bool
  val intersects : t -> t -> bool
  val intersection : t -> t -> t option
  val union : t -> t -> t
  val empty : t
  val of_xywh : x:int -> y:int -> w:int -> h:int -> t
  val to_rect : t -> Rect.t
  val of_rect : Rect.t -> t
end

module Matrix : sig
  type t =
    { scale_x : float
    ; skew_x : float
    ; trans_x : float
    ; skew_y : float
    ; scale_y : float
    ; trans_y : float
    ; persp0 : float
    ; persp1 : float
    ; persp2 : float
    }

  val make :
     scale_x:float
    -> skew_x:float
    -> trans_x:float
    -> skew_y:float
    -> scale_y:float
    -> trans_y:float
    -> persp0:float
    -> persp1:float
    -> persp2:float
    -> t

  val to_native : t -> Oski_types.M.Matrix.t Ctypes.structure
  val to_native_ptr : t -> Oski_ffi.M.Matrix.t
  val of_native : Oski_types.M.Matrix.t Ctypes.structure -> t
  val identity : unit -> t
  val translate : x:float -> y:float -> t
  val scale : x:float -> y:float -> t
  val rotate : float -> t
end

module RRect : sig
  type t
  type type_ = Oski_types.M.RRect.type_
  type corner = Oski_types.M.RRect.corner

  val to_native : t -> Oski_ffi.M.RRect.t
  val make : unit -> t
  val copy : t -> t
  val get_type : t -> type_
  val get_rect : t -> Rect.t
  val get_width : t -> float
  val get_height : t -> float
  val set_empty : t -> unit
  val set_rect : t -> Rect.t -> unit
  val set_oval : t -> Rect.t -> unit
  val set_rect_xy : t -> Rect.t -> float -> float -> unit
  val set_nine_patch : t -> Rect.t -> float -> float -> float -> float -> unit
  val set_rect_radii : t -> Rect.t -> Vec2.t -> unit
  val inset : t -> float -> float -> unit
  val outset : t -> float -> float -> unit
  val offset : t -> float -> float -> unit
  val is_valid : t -> bool
  val contains : t -> Rect.t -> bool
  val transform : t -> Matrix.t -> t option
end

module Matrix44 : sig
  type t =
    { m00 : float
    ; m01 : float
    ; m02 : float
    ; m03 : float
    ; m10 : float
    ; m11 : float
    ; m12 : float
    ; m13 : float
    ; m20 : float
    ; m21 : float
    ; m22 : float
    ; m23 : float
    ; m30 : float
    ; m31 : float
    ; m32 : float
    ; m33 : float
    }

  val make :
     m00:float
    -> m01:float
    -> m02:float
    -> m03:float
    -> m10:float
    -> m11:float
    -> m12:float
    -> m13:float
    -> m20:float
    -> m21:float
    -> m22:float
    -> m23:float
    -> m30:float
    -> m31:float
    -> m32:float
    -> m33:float
    -> t

  val to_native : t -> Oski_types.M.Matrix44.t Ctypes.structure
  val to_native_ptr : t -> Oski_types.M.Matrix44.t Ctypes.structure Ctypes.ptr
  val of_native : Oski_types.M.Matrix44.t Ctypes.structure -> t
  val pp : Format.formatter -> t -> unit
  val to_string : t -> string
  val identity : unit -> t
  val translate : x:float -> y:float -> z:float -> t
  val scale : x:float -> y:float -> z:float -> t
  val concat : t -> t -> t
  val invert : t -> t option
end

module RSXform : sig
  type t =
    { scos : float
    ; ssin : float
    ; tx : float
    ; ty : float
    }

  val make : scos:float -> ssin:float -> tx:float -> ty:float -> t
  val to_native : t -> Oski_types.M.RSXform.t Ctypes.structure
  val to_native_ptr : t -> Oski_types.M.RSXform.t Ctypes.structure Ctypes.ptr
  val of_native : Oski_types.M.RSXform.t Ctypes.structure -> t
  val identity : unit -> t
  val from_rotation_translation : angle:float -> tx:float -> ty:float -> t

  val from_scale_rotation_translation :
     scale:float
    -> angle:float
    -> tx:float
    -> ty:float
    -> t

  val translate : tx:float -> ty:float -> t
  val scale : scale:float -> t
  val rotate : angle:float -> t
end

module Stream : sig
  (** Stream interface for reading data from Skia streams in a safe, OCaml-friendly way.

        This module provides an In_channel-like API for working with Skia streams,
        using Bigstring for efficient memory management and safe pointer operations. *)

  type t
  (** Abstract type representing a Skia stream *)

  type bigstring =
    (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  (** Bigstring type for efficient byte array operations *)

  (** {1 Native Interface} *)

  val to_native : t -> Oski_ffi.M.Stream.t
  (** [to_native stream] returns the underlying FFI stream handle.
        Use this when interfacing with other Skia functions that expect a native stream. *)

  (** {1 Stream Operations} *)

  val duplicate : t -> t option
  (** [duplicate stream] creates a duplicate of the stream.
        Returns [Some duplicated_stream] on success, [None] if duplication is not supported. *)

  val fork : t -> t option
  (** [fork stream] creates a fork of the stream.
        Returns [Some forked_stream] on success, [None] if forking is not supported. *)

  (** {1 Stream Properties} *)

  val has_position : t -> bool
  (** [has_position stream] returns [true] if the stream supports position queries *)

  val is_at_end : t -> bool
  (** [is_at_end stream] returns [true] if the stream is at its end *)

  val get_position : t -> Unsigned.Size_t.t
  (** [get_position stream] returns the current position in the stream.
        Only valid if [has_position stream] returns [true]. *)

  val has_length : t -> bool
  (** [has_length stream] returns [true] if the stream has a known length *)

  val get_length : t -> int
  (** [get_length stream] returns the total length of the stream.
        Only valid if [has_length stream] returns [true]. *)

  (** {1 Reading Functions} *)

  val read : t -> bigstring -> pos:int -> len:int -> int
  (** [read stream buffer ~pos ~len] reads up to [len] bytes from [stream] 
        into [buffer] starting at position [pos].
        Returns the actual number of bytes read.
        Raises [Invalid_argument] if [pos] or [len] are out of bounds. *)

  val peek : t -> bigstring -> pos:int -> len:int -> int
  (** [peek stream buffer ~pos ~len] peeks up to [len] bytes from [stream]
        into [buffer] starting at position [pos], without advancing the stream position.
        Returns the actual number of bytes peeked.
        Raises [Invalid_argument] if [pos] or [len] are out of bounds. *)

  val read_bigstring : t -> int -> bigstring
  (** [read_bigstring stream len] allocates a new bigstring and reads up to [len] bytes.
        Returns a bigstring containing the actual bytes read (may be shorter than [len]). *)

  val peek_bigstring : t -> int -> bigstring
  (** [peek_bigstring stream len] allocates a new bigstring and peeks up to [len] bytes.
        Returns a bigstring containing the actual bytes peeked (may be shorter than [len]). *)

  val read_bytes : t -> int -> bytes
  (** [read_bytes stream len] reads up to [len] bytes and returns them as a [bytes] value.
        Returns bytes containing the actual data read (may be shorter than [len]). *)

  val read_string : t -> int -> string
  (** [read_string stream len] reads up to [len] bytes and returns them as a string.
        Returns string containing the actual data read (may be shorter than [len]). *)

  (** {1 Complete Reading Functions} *)

  val really_read : t -> bigstring -> pos:int -> len:int -> bool
  (** [really_read stream buffer ~pos ~len] ensures exactly [len] bytes are read
        from [stream] into [buffer] starting at position [pos].
        Returns [true] on success, [false] if EOF is reached before reading [len] bytes.
        Raises [Invalid_argument] if [pos] or [len] are out of bounds. *)

  val really_read_bigstring : t -> int -> bigstring option
  (** [really_read_bigstring stream len] allocates a new bigstring and reads exactly [len] bytes.
        Returns [Some bigstring] on success, [None] if EOF is reached before reading [len] bytes. *)

  val really_read_string : t -> int -> string option
  (** [really_read_string stream len] reads exactly [len] bytes and returns them as a string.
        Returns [Some string] on success, [None] if EOF is reached before reading [len] bytes. *)
end

module Data : sig
  (** Data interface for working with immutable byte arrays from Skia.

      Data objects are reference-counted and automatically managed by the garbage collector. *)

  type t
  (** Abstract type representing a Skia data object *)

  (** {1 Native Interface} *)

  val to_native : t -> Oski_ffi.M.Data.t
  (** [to_native data] returns the underlying FFI data handle.
      Use this when interfacing with other Skia functions that expect native data. *)

  (** {1 Creation} *)

  val of_file : string -> t option
  (** [of_file path] creates a data object from a file.
      Returns [Some data] on success, [None] if the file cannot be read. *)

  val of_stream : Oski_ffi.M.Stream.t -> int -> t option
  (** [of_stream stream size] creates a data object by reading [size] bytes from [stream].
      Returns [Some data] on success, [None] if the stream cannot be read. *)

  (** {1 Access} *)

  val get_size : t -> Unsigned.Size_t.t
  (** [get_size data] returns the size of the data in bytes *)

  val to_string : t -> string
  (** [to_string data] converts the data to a string.
      The data is interpreted as raw bytes. *)
end
