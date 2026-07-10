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

  val get_memory_base : t -> unit Ctypes.ptr
  (** Returns the starting address for the data. *)
end

module Stream_asset : sig
  type t

  val delete : t -> unit
  val to_stream : t -> Stream.t

  val to_native : t -> Oski_ffi.M.Stream_asset.t
  (** [to_native asset] returns the underlying FFI stream asset handle.
      Use this when interfacing with other Skia functions that expect a native stream asset. *)
end

module File_stream : sig
  type t

  val make : string -> t option
  val is_valid : t -> bool
  val delete : t -> unit
  val to_stream : t -> Stream.t

  val to_native : t -> Oski_ffi.M.File_stream.t
  (** [to_native file] returns the underlying FFI file stream handle.
      Use this when interfacing with other Skia functions that expect a native file stream. *)
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

module Memory_stream : sig
  type t

  val of_string : string -> int -> t option
  val of_data : Data.t -> t option
  val to_stream : t -> Stream.t
end

module Typeface : sig
  type t
  type id = Oski_types.M.Typeface.id
  type font_table_tag = Oski_types.M.Typeface.font_table_tag

  val of_name : string -> Font_style.t -> t option
  val of_file : string -> int -> t option
  val of_asset : Stream_asset.t -> int -> t option
  val of_data : Data.t -> int -> t option
  val open_stream : t -> Stream_asset.t option * int
  val open_existing_stream : t -> Stream_asset.t option * int
  val get_unique_id : t -> id
  val equal : t -> t -> bool
  val copy_table_data : t -> font_table_tag -> Data.t option
  val get_font_style : t -> Font_style.t
  val get_family_name : t -> string
  val get_units_per_em : t -> int
  val to_native : t -> Oski_ffi.M.Typeface.t
  val of_native : Oski_ffi.M.Typeface.t -> t
end

module Font_style : sig
  type t
  type slant = Oski_types.M.Font_style.slant

  val make : int -> int -> slant -> t
  val get_slant : t -> slant
  val get_weight : t -> int
  val get_width : t -> int
end

module Font_manager : sig
  module Font_style_set : sig
    type t

    val get_count : t -> int
    val make_empty : unit -> t
    val get_style : t -> int -> Font_style.t * string option
    val make_typeface : t -> int -> Typeface.t option
    val match_style : t -> Font_style.t -> Typeface.t option
  end

  type t

  val make : unit -> t
  val make_style_set : t -> int -> Font_style_set.t option

  val match_family : t -> string -> Font_style_set.t option
  (** [match_family mgr family] returns a Font_style_set for the given family name.
      Returns [None] if the family is not found. *)

  val match_family_style : t -> string -> Font_style.t -> Typeface.t option
  val get_family_name : t -> int -> string
  val count_families : t -> int

  val match_family_style_character :
     t
    -> string
    -> Font_style.t
    -> string list
    -> Uchar.t
    -> Typeface.t option
end

module Text_encoding : sig
  type t = Oski_types.M.Text_encoding.t
end

module Font_metrics : sig
  type t =
    { flags : Unsigned.uint32
    ; top : float
    ; ascent : float
    ; descent : float
    ; bottom : float
    ; leading : float
    ; avg_char_width : float
    ; max_char_width : float
    ; xmin : float
    ; xmax : float
    ; xheight : float
    ; cap_height : float
    ; underline_thickness : float
    ; underline_position : float
    ; strikeout_thickness : float
    ; strikeout_position : float
    }

  val to_native : t -> Oski_types.M.Font_metrics.t Ctypes.structure
  val to_native_ptr : t -> Oski_ffi.M.Font_metrics.t
  val of_native : Oski_types.M.Font_metrics.t Ctypes.structure -> t
end

module Font : sig
  type t
  type hinting = Oski_types.M.Font.hinting

  val make : unit -> t

  val make_with_values : Typeface.t -> float -> float -> float -> t
  (** [make_with_values face size scalex skewx] creates a new Font with the given Typeface, size, scale, and skew. *)

  val get_typeface : t -> Typeface.t
  (** [get_typeface font] returns the Typeface associated with the Font. *)

  val set_typeface : t -> Typeface.t -> unit
  (** [set_typeface font face] sets the Typeface for the Font. *)

  val get_size : t -> float
  (** [get_size font] returns the size of the Font. *)

  val set_size : t -> float -> unit
  (** [set_size font size] sets the size of the Font. *)

  val is_subpixel : t -> bool
  (** [is_subpixel font] returns true if the Font is using subpixel rendering. *)

  val set_subpixel : t -> bool -> unit
  (** [set_subpixel font subpixel] enables or disables subpixel rendering for the Font. *)

  val get_metrics : t -> Font_metrics.t
  (** [get_metrics font] retrieves the Font_metrics for the Font. *)

  val measure_text :
     ?bounds:Rect.t
    -> paint:Paint.t
    -> ?encoding:Text_encoding.t
    -> t
    -> string
    -> unit
    -> float

  val to_native : t -> Oski_ffi.M.Font.t
end

module Text_blob : sig
  type t
end

module Text_blob_builder : sig
  type t

  val make : unit -> t
  val with_builder : (t -> 'a) -> 'a
  val build : t -> Text_blob.t option
  val to_native : t -> Oski_ffi.M.Text_blob_builder.t

  type shape =
    { glyph_id : int
    ; cluster : int
    ; x_advance : float
    ; y_advance : float
    ; x_offset : float
    ; y_offset : float
    ; units_per_em : float
    }

  val alloc_run :
     font:Font.t
    -> glyphs:int list
    -> ?bounds:Rect.t
    -> ?x:float
    -> ?y:float
    -> t
    -> unit

  val alloc_run_pos :
     font:Font.t
    -> font_size:float
    -> shapes:shape list
    -> ?bounds:Rect.t
    -> base_line_x:float
    -> base_line_y:float
    -> t
    -> unit
end

module Blend_mode : sig
  type t = Oski_types.M.Blend_mode.t
end

module Blender : sig
  type t

  val of_mode : Blend_mode.t -> t
  (** [of_mode mode] creates a Blender for the given blend mode. *)

  val of_arithmetic :
     k1:float
    -> k2:float
    -> k3:float
    -> k4:float
    -> enforce_premul:bool
    -> t option
  (** [of_arithmetic k1 k2 k3 k4 enforce_premul] creates a Blender with the given arithmetic coefficients.
      Returns [Some blender] on success, [None] if the coefficients are invalid. *)
end

module Shader : sig
  type t
  type tile_mode

  type color_stop =
    { color : Color.t
    ; position : float
    }

  val of_empty : unit -> t

  val of_linear_gradient2 :
     start_point:Point.t
    -> stop_point:Point.t
    -> start_color:Color.t
    -> stop_color:Color.t
    -> tile_mode:tile_mode
    -> t

  val of_linear_gradient :
     start_point:Point.t
    -> stop_point:Point.t
    -> color_stops:color_stop list
    -> tile_mode:tile_mode
    -> t
end

module Path : sig
  type t
  type direction = Oski_types.M.Path.direction
  type arc_size = Oski_types.M.Path.arc_size
  type fill_type = Oski_types.M.Path.fill_type
  type add_mode = Oski_types.M.Path.add_mode
  type verb = Oski_types.M.Path.verb

  val make : unit -> t
  (** [make ()] creates a new empty path. *)

  val to_native : t -> Oski_ffi.M.Path.t
  (** [to_native path] returns the underlying FFI path handle.
      Use this when interfacing with other Skia functions that expect a native path. *)

  val make_from :
     Point.t list
    -> int list
    -> float list
    -> fill_type
    -> bool
    -> t option
  (** [make_from points verbs conic_weights fill_type is_volatile] creates a new path with specified segements.

      The points and weights array are read in order, based, on the sequence of verbs.

      Move 1 point
      Line 1 point
      Quad 2 point
      Conic 2 points and 1 weight
      Cubic 3 points
      Close 0 points

      If an illegal sequence of verbs is encountered, or the specified of points
      or weights is not sufficient given the verbs, and empty Path is returned.

      A legal sequence of verbs consists of any number of Contours. A contour always begins
      with a Move verb, followed by 0 or more segements: Line, Quad, Conic, Cubic, followed
      by an optional Close. *)

  val equal : t -> t -> bool
  (** [equal path1 path2] returns true if the two paths are equal. *)

  val reset : t -> unit
  (** [reset path] clears the path, removing all segments and contours. *)

  val rewind : t -> unit
  (** [rewind path] rewinds the path, resetting the current point to the start of the first contour.
      This does not clear the path, but allows for reusing it without starting from scratch. *)

  val count_points : t -> int
  (** [count_points path] returns the number of points in the path. *)

  val count_verbs : t -> int
  (** [count_verbs path] returns the number of verbs in the path.
      This includes Move, Line, Quad, Conic, Cubic, and Close verbs. *)

  val get_fill_type : t -> fill_type
  (** [get_fill_type path] returns the current fill type of the path. *)

  val set_fill_type : t -> fill_type -> unit
  (** [set_fill_type path fill_type] sets the fill type of the path.
      - `fill_type`: the fill type to set, e.g., `Winding`, `Even_odd`, etc. *)

  val move_to : t -> Point.t -> unit
  (** [move_to path point] Adds beginning of contour to the path at the given point. 

      - `x`: x-axis value of contour start 
      - `y`: y-axis value of contour start *)

  val line_to : t -> Point.t -> unit
  (** [line_to path point] Adds a line segment to the path from the current point to the given point.

      - `x`: x-axis value of line end
      - `y`: y-axis value of line end *)

  val quad_to : t -> Point.t -> Point.t -> unit
  (** [quad_to path pt1 pt2] Adds a quadratic bezier curve to the path.
      - `pt1`: control point of the curve
      - `pt2`: end point of the curve *)

  val conic_to : t -> Point.t -> Point.t -> float -> unit
  (** [conic_to path pt1 pt2 weight] Adds a conic curve to the path.
      - `pt1`: control point of the curve
      - `pt2`: end point of the curve
      - `weight`: weight of the conic curve *)

  val cubic_to : t -> Point.t -> Point.t -> Point.t -> unit
  (** [cubic_to path pt1 pt2 pt3] Adds a cubic bezier curve to the path.
      - `pt1`: first control point of the curve
      - `pt2`: second control point of the curve
      - `pt3`: end point of the curve *)

  val arc_to :
     t
    -> Rect.t
    -> start_angle:float
    -> sweep_angle:float
    -> force_move_to:bool
    -> unit
  (** [arc_to path oval ~start_angle ~sweep_angle ~force_move_to] Adds an arc to the path.
      - `oval`: bounding rectangle of the arc
      - `start_angle`: starting angle of the arc in degrees
      - `sweep_angle`: angle to sweep for the arc in degrees
      - `force_move_to`: if true, forces a move to the start point of the arc *)

  val rmove_to : t -> Point.t -> unit
  (** [rmove_to path point] Adds a relative move to the path by the given offset.
      - `dx`: x-axis offset from the current point
      - `dy`: y-axis offset from the current point *)

  val rline_to : t -> Point.t -> unit
  (** [rline_to path point] Adds a relative line segment to the path by the given offset.
      - `dx`: x-axis offset from the current point
      - `dy`: y-axis offset from the current point *)

  val rquad_to : t -> Point.t -> Point.t -> unit
  (** [rquad_to path pt1 pt2] Adds a relative quadratic bezier curve to the path.
      - `pt1`: control point offset from the current point
      - `pt2`: end point offset from the current point *)

  val rconic_to : t -> Point.t -> Point.t -> float -> unit
  (** [rconic_to path pt1 pt2 weight] Adds a relative conic curve to the path.
      - `pt1`: control point offset from the current point
      - `pt2`: end point offset from the current point
      - `weight`: weight of the conic curve *)

  val rcubic_to : t -> Point.t -> Point.t -> Point.t -> unit
  (** [rcubic_to path pt1 pt2 pt3] Adds a relative cubic bezier curve to the path.
      - `pt1`: first control point offset from the current point
      - `pt2`: second control point offset from the current point
      - `pt3`: end point offset from the current point *)

  val arc_to_with_oval :
     t
    -> Rect.t
    -> start_angle:float
    -> sweep_angle:float
    -> force_move_to:bool
    -> unit

  val add_rect : t -> Rect.t -> ?dir_start:direction * int -> unit -> unit
  val add_rrect : t -> RRect.t -> ?dir_start:direction * int -> unit -> unit
  val add_oval : t -> Rect.t -> ?direction:direction -> unit -> unit

  val add_circle :
     t
    -> x:float
    -> y:float
    -> radius:float
    -> ?direction:direction
    -> unit
    -> unit

  val transform : t -> Matrix.t -> unit

  val close : t -> unit
  (** Append Verb.Close to the path, closing the current contour. *)

  val is_rect : t -> (Rect.t * bool * direction) option
  (** [is_rect path] returns `Some(Rect.t * bool * direction)`` if path is equivalent
      to Rect.t when filled.*)

  val add_path : t -> t -> Point.t -> ?mode:add_mode -> unit -> unit
  (** [add_path dst src offset ~mode] adds the source path to the destination path,
      offset by the given point.
      - `offset`: translation to apply to the source path before adding
      - `mode`: how to combine the source and destination paths (default is `Append`) *)

  val add_path_matrix : t -> t -> Matrix.t -> ?mode:add_mode -> unit -> unit
  (** [add_path_matrix dst src matrix ~mode] adds the source path to the destination path,
      transformed by the given matrix.
      - `matrix`: transformation to apply to the source path before adding
      - `mode`: how to combine the source and destination paths (default is `Append`) *)

  val add_path_reverse : t -> t -> unit
  (** [add_path_reverse path src] Appends src to path, from back to front. 
      Reversed src always appends a new contour to path. *)

  val get_points : t -> int -> int * Point.t list
  (** [get_points path max_points] retrieves up to [max_points] points from the path.
      Returns a list of points. If [max_points] is greater than the number of points in the path,
      all points are returned. *)
end

module Path_iterator : sig
  type t

  val make : Path.t -> bool -> t option
  (** [make path force_close] creates a new path iterator for the given path. *)

  val next : t -> Path.verb * Point.t list
  (** [next iterator] retrieves the next verb and its associated points from the path.
      Returns [Some (verb, points)] if there are more segments, or [None] if the end is reached. *)

  val conic_weight : t -> float
  (** [conic_weight iterator] returns the weight of the last conic segment returned by [next]. *)

  val is_close_line : t -> bool
  (** [is_close_line iterator] returns true if the last segment returned by [next] was a close line. *)

  val is_closed_contour : t -> bool
  (** [is_closed_contour iterator] returns true if the current contour is closed. *)
end

module Path_measure : sig
  type t

  val of_path : Path.t -> bool -> float -> t option
  val make : unit -> t option
  val set_path : t -> Path.t -> bool -> unit
  val get_length : t -> float
  val get_pos_tan : t -> float -> (Point.t * Vec2.t) option
end

module Path_effect : sig
  module Style : sig
    type t =
      [ `Translate
      | `Rotate
      | `Morph
      ]
  end

  type t

  val compose : t -> t -> t
  val sum : t -> t -> t
  val create1d : style:Style.t -> advance:float -> phase:float -> Path.t -> t
  val create2d_line : width:float -> matrix:Matrix.t -> t
  val create2d_path : matrix:Matrix.t -> Path.t -> t
  val to_native : t -> Oski_ffi.M.Path_effect.t
end

module Color_space : sig
  type t

  val of_srgb : unit -> t
  val of_srgb_linear : unit -> t
  val equal : t -> t -> bool
  val to_native : t -> Oski_ffi.M.Color_space.t
end

module Image_info : sig
  type t
  type color_type = Oski_types.M.Color_type.t
  type alpha_type = Oski_types.M.Alpha_type.t

  val make :
     ?color_space:Color_space.t
    -> width:int
    -> height:int
    -> color_type:color_type
    -> alpha_type:alpha_type
    -> unit
    -> t
  (** [make ~width ~height ~color_type ~alpha_type ()] describes the pixel
      layout of a raster surface: dimensions, color type, and alpha type. *)

  val make_n32_premul :
     ?color_space:Color_space.t
    -> width:int
    -> height:int
    -> unit
    -> t
  (** [make_n32_premul ~width ~height ()] is a convenience constructor using
      the common native 32-bit premultiplied RGBA layout. *)

  val width : t -> int
  val height : t -> int
  val color_type : t -> color_type
  val alpha_type : t -> alpha_type
  val to_native : t -> Oski_ffi.M.Image_info.t
end

module Paint : sig
  type t
  type style = Oski_types.M.Paint.style
  type stroke_cap = Oski_types.M.Paint.stroke_cap
  type stroke_join = Oski_types.M.Paint.stroke_join

  val make : unit -> t
  val clone : t -> t
  val reset : t -> unit
  val is_antialias : t -> bool
  val set_antialias : t -> bool -> unit
  val is_dither : t -> bool
  val set_dither : t -> bool -> unit
  val get_color : t -> Color.t
  val set_color : t -> Color.t -> unit
  val get_color4f : t -> Color.Color4f.t
  val set_color4f : ?color_space:Color_space.t -> t -> Color.Color4f.t -> unit
  val get_style : t -> style
  val set_style : t -> style -> unit
  val get_stroke_width : t -> float
  val set_stroke_width : t -> float -> unit
  val get_stroke_miter : t -> float
  val set_stroke_miter : t -> float -> unit
  val get_stroke_cap : t -> stroke_cap
  val set_stroke_cap : t -> stroke_cap -> unit
  val get_stroke_join : t -> stroke_join
  val set_stroke_join : t -> stroke_join -> unit
  val set_path_effect : t -> Path_effect.t -> unit
  val get_path_effect : t -> Path_effect.t
  val set_shader : t -> Shader.t -> unit

  val make_fill : ?antialias:bool -> Color.t -> t
  (** [make_fill color] is a convenience constructor for an antialiased fill paint. *)

  val make_stroke : ?antialias:bool -> ?width:float -> Color.t -> t
  (** [make_stroke color] is a convenience constructor for an antialiased stroke paint. *)

  val to_native : t -> Oski_ffi.M.Paint.t
end

module Canvas : sig
  type t
  type clip_op = Oski_types.M.Clip_op.t

  val clear : t -> Color.t -> unit
  val clear_color4f : t -> Color.Color4f.t -> unit
  val discard : t -> unit
  val get_save_count : t -> int
  val restore_to_count : t -> int -> unit
  val save : t -> int
  val save_layer : t -> Rect.t -> Paint.t -> int
  val restore : t -> unit
  val draw_color : t -> Color.t -> Blend_mode.t -> unit
  val draw_color4f : t -> Color.Color4f.t -> Blend_mode.t -> unit
  val draw_paint : t -> Paint.t -> unit
  val draw_point : t -> Point.t -> Paint.t -> unit
  val draw_line : t -> Point.t -> Point.t -> Paint.t -> unit
  val draw_rect : t -> Rect.t -> Paint.t -> unit
  val draw_round_rect : t -> Rect.t -> rx:float -> ry:float -> Paint.t -> unit
  val draw_rrect : t -> RRect.t -> Paint.t -> unit
  val draw_circle : t -> Point.t -> float -> Paint.t -> unit
  val draw_oval : t -> Rect.t -> Paint.t -> unit
  val draw_path : t -> Path.t -> Paint.t -> unit

  val draw_simple_text :
     ?encoding:Text_encoding.t
    -> t
    -> string
    -> float
    -> float
    -> Font.t
    -> Paint.t
    -> unit
    -> unit

  val draw_text : t -> string -> float -> float -> Font.t -> Paint.t -> unit
  val clip_rect : ?op:clip_op -> ?antialias:bool -> t -> Rect.t -> unit
  val clip_path : ?op:clip_op -> ?antialias:bool -> t -> Path.t -> unit
  val clip_rrect : ?op:clip_op -> ?antialias:bool -> t -> RRect.t -> unit
  val quick_reject : t -> Rect.t -> bool
  val translate : t -> float -> float -> unit
  val scale : t -> float -> float -> unit
  val rotate_degrees : t -> float -> unit
  val rotate_radians : t -> float -> unit
  val skew : t -> float -> float -> unit
  val reset_matrix : t -> unit
  val to_native : t -> Oski_ffi.M.Canvas.t
end

module Surface : sig
  type t

  val make_raster : ?row_bytes:int -> Image_info.t -> t
  (** [make_raster info] allocates a raster surface backed by CPU memory
      matching [info]'s dimensions and pixel layout. *)

  val get_canvas : t -> Canvas.t
  (** [get_canvas surface] returns the canvas used to draw into [surface].
      The canvas is owned by the surface and must not be freed separately. *)

  val save_png :
     ?zlib_level:int
    -> ?filter_flags:Oski_types.M.Png_encoder_filter_flags.t
    -> t
    -> string
    -> unit
  (** [save_png surface path] encodes the current contents of [surface] as a
      PNG file at [path]. Raises [Invalid_argument] if the surface's pixels
      cannot be read directly or if writing fails. *)

  val to_native : t -> Oski_ffi.M.Surface.t
end
