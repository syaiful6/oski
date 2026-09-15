module Color : sig
  module HSV : sig
    type t =
      { h : float
      ; s : float
      ; v : float
      }

    val make : float -> float -> float -> t
    (** [make h s v] returns an HSV color. *)

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
  (** [make x y] returns a vector with coordinates [x] and [y]. *)

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
  (** An {!Stdlib.In_channel}-style interface to Skia streams. Reads can
      target bigstrings to avoid intermediate copies. *)

  type t
  (** A Skia stream. *)

  type bigstring =
    (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  (** A one-dimensional array of bytes. *)

  (** {1 Native Interface} *)

  val to_native : t -> Oski_ffi.M.Stream.t
  (** [to_native stream] returns the underlying FFI handle. *)

  (** {1 Stream Operations} *)

  val duplicate : t -> t option
  (** [duplicate stream] returns a copy with its own position, or [None] if
      [stream] does not support duplication. *)

  val fork : t -> t option
  (** [fork stream] returns a stream at the same position as [stream], or
      [None] if [stream] does not support forking. *)

  (** {1 Stream Properties} *)

  val has_position : t -> bool
  (** [has_position stream] is [true] when [stream] supports position queries. *)

  val is_at_end : t -> bool
  (** [is_at_end stream] is [true] at the end of [stream]. *)

  val get_position : t -> Unsigned.Size_t.t
  (** [get_position stream] returns its current position. Call it only when
      [has_position stream] is [true]. *)

  val has_length : t -> bool
  (** [has_length stream] is [true] when its length is known. *)

  val get_length : t -> int
  (** [get_length stream] returns its length. Call it only when
      [has_length stream] is [true]. *)

  (** {1 Reading}

      Reads may return fewer than the requested number of bytes at the end
      of a stream. *)

  val read : t -> bigstring -> pos:int -> len:int -> int
  (** [read stream buffer ~pos ~len] reads at most [len] bytes into [buffer]
      at [pos] and returns the number read.

      @raise Invalid_argument if the requested range lies outside [buffer]. *)

  val peek : t -> bigstring -> pos:int -> len:int -> int
  (** [peek stream buffer ~pos ~len] reads at most [len] bytes into [buffer]
      at [pos] without advancing [stream], and returns the number read.

      @raise Invalid_argument if the requested range lies outside [buffer]. *)

  val read_bigstring : t -> int -> bigstring
  (** [read_bigstring stream len] reads at most [len] bytes into a new
      bigstring. *)

  val peek_bigstring : t -> int -> bigstring
  (** [peek_bigstring stream len] reads at most [len] bytes into a new
      bigstring without advancing [stream]. *)

  val read_bytes : t -> int -> bytes
  (** [read_bytes stream len] reads at most [len] bytes. *)

  val read_string : t -> int -> string
  (** [read_string stream len] reads at most [len] bytes. *)

  (** {1 Complete reads} *)

  val really_read : t -> bigstring -> pos:int -> len:int -> bool
  (** [really_read stream buffer ~pos ~len] fills the requested range and
      returns [true]. It returns [false] if the stream ends first.

      @raise Invalid_argument if the requested range lies outside [buffer]. *)

  val really_read_bigstring : t -> int -> bigstring option
  (** [really_read_bigstring stream len] reads [len] bytes into a new
      bigstring, or returns [None] if the stream ends first. *)

  val really_read_string : t -> int -> string option
  (** [really_read_string stream len] reads a string of [len] bytes, or
      returns [None] if the stream ends first. *)

  val get_memory_base : t -> unit Ctypes.ptr
  (** [get_memory_base stream] returns the address of its memory-backed data,
      or a null pointer when no address is available. The pointer remains
      valid only while [stream] is alive. *)
end

module Stream_asset : sig
  type t

  val delete : t -> unit
  val to_stream : t -> Stream.t

  val to_native : t -> Oski_ffi.M.Stream_asset.t
  (** [to_native asset] returns the underlying FFI handle. *)
end

module File_stream : sig
  type t

  val make : string -> t option
  val is_valid : t -> bool
  val delete : t -> unit
  val to_stream : t -> Stream.t

  val to_native : t -> Oski_ffi.M.File_stream.t
  (** [to_native file] returns the underlying FFI handle. *)
end

module Data : sig
  (** Immutable byte buffers owned by Skia. OCaml finalizers release their
      reference counts. *)

  type t
  (** An immutable Skia byte buffer. *)

  (** {1 Native Interface} *)

  val to_native : t -> Oski_ffi.M.Data.t
  (** [to_native data] returns the underlying FFI handle. *)

  (** {1 Creation} *)

  val of_file : string -> t option
  (** [of_file path] reads a buffer from [path], or returns [None] if the
      file cannot be read. *)

  val of_stream : Oski_ffi.M.Stream.t -> int -> t option
  (** [of_stream stream size] reads [size] bytes from [stream], or returns
      [None] if the read fails. *)

  (** {1 Access} *)

  val get_size : t -> Unsigned.Size_t.t
  (** [get_size data] returns its size in bytes. *)

  val to_string : t -> string
  (** [to_string data] copies its raw bytes into a string. *)
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
  (** [match_family mgr family] returns the styles for [family], or [None]
      if the family is unavailable. *)

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
  (** [make_with_values face size scalex skewx] creates a font with the given
      typeface, size, horizontal scale, and skew. *)

  val get_typeface : t -> Typeface.t
  (** [get_typeface font] returns its typeface. *)

  val set_typeface : t -> Typeface.t -> unit
  (** [set_typeface font face] sets its typeface to [face]. *)

  val get_size : t -> float
  (** [get_size font] returns its size. *)

  val set_size : t -> float -> unit
  (** [set_size font size] sets its size. *)

  val is_subpixel : t -> bool
  (** [is_subpixel font] is [true] when subpixel rendering is enabled. *)

  val set_subpixel : t -> bool -> unit
  (** [set_subpixel font subpixel] controls subpixel rendering. *)

  val get_metrics : t -> Font_metrics.t
  (** [get_metrics font] returns its metrics. *)

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

  val to_native : t -> Oski_ffi.M.Text_blob.t
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
  (** [of_mode mode] creates a blender that uses [mode]. *)

  val of_arithmetic :
     k1:float
    -> k2:float
    -> k3:float
    -> k4:float
    -> enforce_premul:bool
    -> t option
  (** [of_arithmetic ~k1 ~k2 ~k3 ~k4 ~enforce_premul] creates an arithmetic
      blender, or returns [None] if the coefficients are invalid. *)
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
  (** [make ()] creates an empty path. *)

  val to_native : t -> Oski_ffi.M.Path.t
  (** [to_native path] returns the underlying FFI handle. *)

  val make_from :
     Point.t list
    -> verb list
    -> float list
    -> fill_type
    -> is_volatile:bool
    -> t
  (** [make_from points verbs weights fill_type ~is_volatile] constructs a
      path by consuming [points] and [weights] in verb order. [`Move] and
      [`Line] consume one point, [`Quad] and [`Conic] consume two, and
      [`Cubic] consumes three. [`Conic] also consumes one weight; [`Close]
      consumes neither.

      Each contour begins with [`Move] and may end with [`Close]. Invalid
      sequences or insufficient points and weights produce an empty path.

      @raise Invalid_argument if [verbs] contains [`Done]. *)

  val equal : t -> t -> bool
  (** [equal path1 path2] is [true] when the paths are equal. *)

  val reset : t -> unit
  (** [reset path] clears the path. *)

  val rewind : t -> unit
  (** [rewind path] clears the path. In this Skia version it is equivalent to
      [reset path]. *)

  val count_points : t -> int
  (** [count_points path] returns its number of points. *)

  val count_verbs : t -> int
  (** [count_verbs path] returns its number of verbs. *)

  val get_fill_type : t -> fill_type
  (** [get_fill_type path] returns its fill rule. *)

  val set_fill_type : t -> fill_type -> unit
  (** [set_fill_type path fill_type] sets its fill rule. *)

  val transform : t -> Matrix.t -> unit

  val is_rect : t -> (Rect.t * bool * direction) option
  (** [is_rect path] returns [Some (rect, is_closed, direction)] if the
      filled path is rectangular, and [None] otherwise. *)

  val get_points : t -> int -> int * Point.t list
  (** [get_points path max_points] returns the number of available points and
      at most [max_points] of them. *)
end

module Path_builder : sig
  type t
  type direction = Oski_types.M.Path.direction
  type arc_size = Oski_types.M.Path.arc_size
  type fill_type = Oski_types.M.Path.fill_type
  type add_mode = Oski_types.M.Path.add_mode

  val make : unit -> t
  (** [make ()] creates an empty path builder. *)

  val make_from_path : Path.t -> t
  (** [make_from_path path] creates a builder initialized from [path]. *)

  val to_native : t -> Oski_ffi.M.Path_builder.t

  val move_to : t -> Point.t -> unit
  (** [move_to builder point] starts a contour at [point]. *)

  val line_to : t -> Point.t -> unit
  (** [line_to builder point] adds a line from the current point to [point]. *)

  val quad_to : t -> Point.t -> Point.t -> unit
  (** [quad_to builder control endpoint] adds a quadratic Bezier segment. *)

  val conic_to : t -> Point.t -> Point.t -> float -> unit
  (** [conic_to builder control endpoint weight] adds a weighted conic
      segment. *)

  val cubic_to : t -> Point.t -> Point.t -> Point.t -> unit
  (** [cubic_to builder control1 control2 endpoint] adds a cubic Bezier
      segment. *)

  val arc_to :
     t
    -> Rect.t
    -> start_angle:float
    -> sweep_angle:float
    -> force_move_to:bool
    -> unit
  (** [arc_to builder oval ~start_angle ~sweep_angle ~force_move_to] adds an
      arc of [oval]. Angles are in degrees. If [force_move_to] is [true], a
      move starts at the first point of the arc. *)

  val arc_to_with_oval :
     t
    -> Rect.t
    -> start_angle:float
    -> sweep_angle:float
    -> force_move_to:bool
    -> unit

  val rmove_to : t -> Point.t -> unit
  (** [rmove_to builder offset] starts a contour at [offset] from the current
      point. *)

  val rline_to : t -> Point.t -> unit
  (** [rline_to builder offset] adds a line to [offset] from the current
      point. *)

  val rquad_to : t -> Point.t -> Point.t -> unit
  (** [rquad_to builder control endpoint] adds a quadratic Bezier segment
      whose points are offsets from the current point. *)

  val rconic_to : t -> Point.t -> Point.t -> float -> unit
  (** [rconic_to builder control endpoint weight] adds a weighted conic
      segment whose points are offsets from the current point. *)

  val rcubic_to : t -> Point.t -> Point.t -> Point.t -> unit
  (** [rcubic_to builder control1 control2 endpoint] adds a cubic Bezier
      segment whose points are offsets from the current point. *)

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

  val close : t -> unit
  (** [close builder] closes the current contour. *)

  val add_path : t -> Path.t -> Point.t -> ?mode:add_mode -> unit -> unit
  (** [add_path dst src offset ~mode] adds [src] to [dst] after translating
      it by [offset]. [mode] defaults to [`Append]. *)

  val add_path_matrix :
     t
    -> Path.t
    -> Matrix.t
    -> ?mode:add_mode
    -> unit
    -> unit
  (** [add_path_matrix dst src matrix ~mode] adds [src] to [dst] after
      applying [matrix]. [mode] defaults to [`Append]. *)

  val add_path_reverse : t -> Path.t -> unit
  (** [add_path_reverse builder src] appends [src] in reverse order as a new
      contour. *)

  val set_fill_type : t -> fill_type -> unit
  val get_fill_type : t -> fill_type
  val reset : t -> unit

  val detach : t -> Path.t
  (** [detach builder] returns the path and resets [builder]. *)

  val snapshot : t -> Path.t
  (** [snapshot builder] copies the current path without resetting [builder]. *)
end

module Path_iterator : sig
  type t

  val make : Path.t -> bool -> t option
  (** [make path force_close] creates an iterator over [path]. If
      [force_close] is [true], open contours end with a closing line. *)

  val next : t -> Path.verb * Point.t list
  (** [next iterator] returns the next verb and its point buffer. [`Done]
      marks the end of the path. *)

  val conic_weight : t -> float
  (** [conic_weight iterator] returns the weight of the last conic segment
      returned by [next]. *)

  val is_close_line : t -> bool
  (** [is_close_line iterator] is [true] when the last segment returned by
      [next] was a closing line. *)

  val is_closed_contour : t -> bool
  (** [is_closed_contour iterator] is [true] when the current contour is
      closed. *)
end

module Path_measure : sig
  type t

  val of_path : Path.t -> bool -> float -> t option
  val make : unit -> t option
  val set_path : t -> Path.t -> bool -> unit
  val get_length : t -> float
  val get_pos_tan : t -> float -> (Point.t * Vec2.t) option
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
  (** [make ~width ~height ~color_type ~alpha_type ()] describes a raster
      surface's dimensions and pixel layout. *)

  val make_n32_premul :
     ?color_space:Color_space.t
    -> width:int
    -> height:int
    -> unit
    -> t
  (** [make_n32_premul ~width ~height ()] describes a surface that uses the
      native 32-bit premultiplied RGBA layout. *)

  val width : t -> int
  val height : t -> int
  val color_type : t -> color_type
  val alpha_type : t -> alpha_type
  val to_native : t -> Oski_ffi.M.Image_info.t
end

module Image : sig
  type t

  val of_file : string -> t option
  (** [of_file path] decodes an image from [path], or returns [None] if it
      cannot read or decode the file. *)

  val of_data : Data.t -> t option
  (** [of_data data] decodes an image held in [data], or returns [None] if
      the data has an unsupported or invalid encoding. *)

  val width : t -> int
  val height : t -> int
  val alpha_type : t -> Oski_types.M.Alpha_type.t
  val color_type : t -> Oski_types.M.Color_type.t
  val is_alpha_only : t -> bool
  val to_native : t -> Oski_ffi.M.Image.t
end

module Pixmap : sig
  type t

  val make : unit -> t
  val width : t -> int
  val height : t -> int
  val row_bytes : t -> int
  val get_pixel_color : t -> x:int -> y:int -> Color.t

  val to_bigarray :
     t
    -> (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  (** [to_bigarray pixmap] returns a zero-copy, row-major view of its raw
      pixels. The view contains [row_bytes pixmap * height pixmap] bytes and
      remains valid while the surface or image that owns [pixmap] is alive. *)

  val to_native : t -> Oski_ffi.M.Pixmap.t
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
  (** [make_fill ~antialias color] creates a fill paint. Antialiasing
      defaults to [true]. *)

  val make_stroke : ?antialias:bool -> ?width:float -> Color.t -> t
  (** [make_stroke ~antialias ~width color] creates a stroke paint.
      Antialiasing defaults to [true]. *)

  val to_native : t -> Oski_ffi.M.Paint.t
end

module Stroke_rec : sig
  type t
  type style = Oski_types.M.Paint.style

  val make_fill : unit -> t
  (** [make_fill ()] creates a fill-only stroke context. *)

  val make_hairline : unit -> t
  (** [make_hairline ()] creates an unscaled, one-pixel stroke context. *)

  val of_paint : ?res_scale:float -> Paint.t -> style -> t
  (** [of_paint paint style] creates a stroke context from [paint]'s width,
      cap, join, and miter, with [style] overriding the paint's style. *)

  val to_native : t -> Oski_ffi.M.Stroke_rec.t
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

  val filter_path :
     ?cull_rect:Rect.t
    -> ?ctm:Matrix.t
    -> t
    -> stroke_rec:Stroke_rec.t
    -> Path.t
    -> Path.t option
  (** [filter_path effect ~stroke_rec src] applies [effect] to [src]. It
      returns [None] if the operation fails. [stroke_rec] supplies the stroke
      settings; use [Stroke_rec.make_fill ()] for a fill-only path.
      [cull_rect] takes effect only when [ctm] is present. *)

  val to_native : t -> Oski_ffi.M.Path_effect.t
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

  val draw_image : ?paint:Paint.t -> t -> Image.t -> Point.t -> unit
  (** [draw_image canvas image point] draws [image] at [point] with
      nearest-neighbor sampling. *)

  val draw_image_rect :
     ?paint:Paint.t
    -> t
    -> Image.t
    -> src:Rect.t
    -> dst:Rect.t
    -> unit
  (** [draw_image_rect canvas image ~src ~dst] scales [src] from [image]
      into [dst] with nearest-neighbor sampling. *)

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
  (** [make_raster info] allocates a CPU-backed surface with the dimensions
      and pixel layout in [info]. *)

  val get_canvas : t -> Canvas.t
  (** [get_canvas surface] returns its drawing canvas. [surface] owns the
      canvas. *)

  val peek_pixels : t -> Pixmap.t option
  (** [peek_pixels surface] returns direct access to its pixels, or [None]
      for surfaces that cannot expose them, including GPU-backed surfaces. *)

  val save_png :
     ?zlib_level:int
    -> ?filter_flags:Oski_types.M.Png_encoder_filter_flags.t
    -> t
    -> string
    -> unit
  (** [save_png surface path] writes its current contents to [path].

      @raise Invalid_argument if the pixels are inaccessible or the write
      fails. *)

  val to_native : t -> Oski_ffi.M.Surface.t
end

module Document : sig
  type t

  type metadata =
    { title : string option
    ; author : string option
    ; subject : string option
    ; keywords : string option
    ; creator : string option
    ; producer : string option
    ; raster_dpi : float option
    ; pdfa : bool
    ; encoding_quality : int option
    }

  val default_metadata : metadata
  (** [default_metadata] leaves every optional field unset and sets [pdfa]
      to [false]. Use record update syntax to set individual fields. *)

  val make_pdf_to_file : ?metadata:metadata -> string -> t
  (** [make_pdf_to_file ?metadata path] opens a PDF document at [path].

      @raise Invalid_argument if [path] cannot be opened or Skia cannot
      create the document. *)

  val begin_page :
     ?content:Rect.t
    -> t
    -> width:float
    -> height:float
    -> Canvas.t
  (** [begin_page document ~width ~height] starts a page measured in points
      and returns its canvas. [content] restricts drawing to a subrectangle;
      it defaults to the full page. [document] owns the canvas. *)

  val end_page : t -> unit
  (** [end_page document] finishes the current page. *)

  val with_page :
     ?content:Rect.t
    -> t
    -> width:float
    -> height:float
    -> (Canvas.t -> 'a)
    -> 'a
  (** [with_page document ~width ~height f] runs [f] with a new page's canvas
      and ends the page even if [f] raises. *)

  val close : t -> unit
  (** [close document] finishes the document and releases its resources.
      Repeated calls have no effect. *)

  val abort : t -> unit
  (** [abort document] discards the unfinished document and releases its
      resources. Repeated calls have no effect. *)
end

(** Skia's Graphite GPU backend. {!Graphite_vk} creates Vulkan contexts.

    A [Context] manages a GPU connection. A [Recorder] creates surfaces and
    records drawing commands; it is not thread-safe. [Recorder.snap] returns
    an immutable [Recording], which a context schedules and submits. *)
module Graphite : sig
  type backend = Oski_types.M.Graphite.backend

  val backend_is_available : backend -> bool
  (** [backend_is_available backend] is [true] when this Skia build includes
      [backend]. It does not require a context. *)

  module Read_pixels_result : sig
    type t

    val get_row_bytes : t -> int

    val to_bigarray :
       t
      -> height:int
      -> (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
    (** [to_bigarray result ~height] returns a zero-copy view of its pixels.
        Pass the height used for [dst_info], since [result] does not store it.
        The view remains valid until [delete result]. *)

    val delete : t -> unit
  end

  module Recording : sig
    type t

    val delete : t -> unit
    (** No finalizer is installed; call [delete] when finished. *)
  end

  module Recorder : sig
    type t

    val delete : t -> unit
    (** No finalizer is installed; call [delete] when finished. *)

    val snap : t -> Recording.t option
  end

  module Context : sig
    type t

    val get_backend : t -> backend
    val is_device_lost : t -> bool
    val get_max_texture_size : t -> int
    val free_gpu_resources : t -> unit

    val delete : t -> unit
    (** No finalizer is installed. Release every recorder, recording, and
        surface created from the context before calling [delete]. *)

    val make_recorder : ?budget_bytes:int64 -> t -> Recorder.t option

    val insert_recording :
       t
      -> recording:Recording.t
      -> ?target_surface:Surface.t
      -> ?translation_x:int
      -> ?translation_y:int
      -> ?clip:IRect.t
      -> unit
      -> Oski_types.M.Graphite.insert_status
    (** [insert_recording context ~recording ()] schedules [recording].
        [target_surface] selects another playback surface. The translation
        and clip arguments restrict its playback region. *)

    val submit :
       ?sync:bool
      -> ?mark_boundary:bool
      -> ?frame_id:int64
      -> t
      -> bool
    (** [submit context] sends all inserted recordings to the GPU queue. *)

    val read_pixels_sync :
       ?max_iterations:int
      -> ?gamma:[ `Src | `Linear ]
      -> ?mode:[ `Nearest | `Linear | `Repeated_linear | `Repeated_cubic ]
      -> t
      -> Surface.t
      -> dst_info:Image_info.t
      -> src_rect:IRect.t
      -> Read_pixels_result.t option
    (** [read_pixels_sync context surface ~dst_info ~src_rect] reads pixels
        from a Graphite surface. It polls asynchronous work at most
        [max_iterations] times (default [1_000_000]) and returns [None] on
        failure or timeout. *)
  end

  val make_render_target :
     Recorder.t
    -> Image_info.t
    -> ?mipmapped:bool
    -> unit
    -> Surface.t
  (** [make_render_target recorder info ()] allocates a GPU render target
      with the dimensions and pixel layout in [info].

      @raise Invalid_argument if allocation fails. *)
end

(** Creates Vulkan devices and Graphite contexts for offscreen rendering. *)
module Graphite_vk : sig
  module Device : sig
    type t

    val make : unit -> t option
    (** [make ()] creates a headless Vulkan instance, device, and graphics
        queue for {!make_context}. Applications that render to windows
        should provide their own Vulkan setup. Returns [None] if Vulkan
        initialization fails. Available only on Linux. *)
  end

  val make_context :
     ?protected_context:bool
    -> Device.t
    -> Graphite.Context.t option
  (** [make_context device] creates a Graphite context from [device], or
      returns [None] if initialization fails. *)
end
