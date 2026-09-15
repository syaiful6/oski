module F = Oski_ffi.M
module T = Oski_types.M

type owner = File of F.File_wstream.t

type t =
  { doc : F.Document.t
  ; mutable owner : owner option
  }

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

let default_metadata =
  { title = None
  ; author = None
  ; subject = None
  ; keywords = None
  ; creator = None
  ; producer = None
  ; raster_dpi = None
  ; pdfa = false
  ; encoding_quality = None
  }

let null_string_ptr = Ctypes.from_voidp T.String.t Ctypes.null
let null_rect_ptr = Ctypes.from_voidp T.Rect.t Ctypes.null
let null_datetime_ptr = Ctypes.from_voidp T.Document.pdf_datetime Ctypes.null

(* Allocate a string for the metadata structure. SkPDF::Metadata copies its
   contents during document creation, so the caller can free it afterwards. *)
let alloc_string_field = function
  | None -> null_string_ptr, None
  | Some s ->
    (match F.String.with_copy s (Unsigned.Size_t.of_int (String.length s)) with
    | None -> invalid_arg "Document: failed to allocate PDF metadata string"
    | Some sk_str -> sk_str, Some sk_str)

let with_pdf_metadata (m : metadata) f =
  let native = Ctypes.make T.Document.pdf_metadata in
  let title_ptr, title_owned = alloc_string_field m.title in
  let author_ptr, author_owned = alloc_string_field m.author in
  let subject_ptr, subject_owned = alloc_string_field m.subject in
  let keywords_ptr, keywords_owned = alloc_string_field m.keywords in
  let creator_ptr, creator_owned = alloc_string_field m.creator in
  let producer_ptr, producer_owned = alloc_string_field m.producer in
  Ctypes.setf native T.Document.title title_ptr;
  Ctypes.setf native T.Document.author author_ptr;
  Ctypes.setf native T.Document.subject subject_ptr;
  Ctypes.setf native T.Document.keywords keywords_ptr;
  Ctypes.setf native T.Document.creator creator_ptr;
  Ctypes.setf native T.Document.producer producer_ptr;
  Ctypes.setf native T.Document.creation null_datetime_ptr;
  Ctypes.setf native T.Document.modified null_datetime_ptr;
  Ctypes.setf
    native
    T.Document.raster_dpi
    (Option.value m.raster_dpi ~default:72.0);
  Ctypes.setf native T.Document.pdfa m.pdfa;
  Ctypes.setf
    native
    T.Document.encoding_quality
    (Option.value m.encoding_quality ~default:101);
  Fun.protect
    ~finally:(fun () ->
      List.iter
        (Option.iter F.String.delete)
        [ title_owned
        ; author_owned
        ; subject_owned
        ; keywords_owned
        ; creator_owned
        ; producer_owned
        ])
    (fun () -> f (Ctypes.addr native))

let make_pdf_to_file ?metadata path =
  match F.File_wstream.make path with
  | None ->
    invalid_arg
      (Printf.sprintf
         "Document.make_pdf_to_file: could not open %s for writing"
         path)
  | Some file ->
    if not (F.File_wstream.is_valid file)
    then (
      F.File_wstream.delete file;
      invalid_arg
        (Printf.sprintf
           "Document.make_pdf_to_file: could not open %s for writing"
           path));
    let wstream = F.File_wstream.as_wstream file in
    let doc_opt =
      match metadata with
      | None -> F.Document.make_pdf wstream
      | Some m ->
        with_pdf_metadata m (F.Document.make_pdf_with_metadata wstream)
    in
    (match doc_opt with
    | None ->
      F.File_wstream.delete file;
      invalid_arg "Document.make_pdf_to_file: failed to create PDF document"
    | Some doc -> { doc; owner = Some (File file) })

let begin_page ?content t ~width ~height =
  let content_ptr =
    match content with
    | None -> null_rect_ptr
    | Some rect -> Rect.to_native_ptr rect
  in
  F.Document.begin_page t.doc width height content_ptr

let end_page t = F.Document.end_page t.doc

let with_page ?content t ~width ~height f =
  let canvas = begin_page ?content t ~width ~height in
  Fun.protect ~finally:(fun () -> end_page t) (fun () -> f canvas)

let release t =
  match t.owner with
  | None -> ()
  | Some (File file) ->
    F.Document.unref t.doc;
    F.File_wstream.delete file;
    t.owner <- None

let close t =
  if Option.is_some t.owner
  then (
    F.Document.close t.doc;
    release t)

let abort t =
  if Option.is_some t.owner
  then (
    F.Document.abort t.doc;
    release t)
