module F = Oski_ffi.M

type t = F.Typeface.t
type id = F.Typeface.id
type font_table_tag = F.Typeface.font_table_tag

let get_unique_id = F.Typeface.get_unique_id
let equal = F.Typeface.equal

let get_family_name face =
  let sk_str = F.Typeface.get_family_name face in
  let name = F.String.to_string sk_str in
  F.String.delete sk_str;
  name

let of_name name style =
  match F.Typeface.of_name name style with
  | Some face ->
    Gc.finalise F.Typeface.unref face;
    Some face
  | None -> None

let of_file path ix =
  match F.Typeface.of_file path ix with
  | Some face ->
    Gc.finalise F.Typeface.unref face;
    Some face
  | None -> None

let of_asset asset ix =
  match F.Typeface.of_asset asset ix with
  | Some face ->
    Gc.finalise F.Typeface.unref face;
    Some face
  | None -> None

let of_data data ix =
  match F.Typeface.of_data data ix with
  | Some face ->
    Gc.finalise F.Typeface.unref face;
    Some face
  | None -> None

let open_stream face =
  let idx_ptr = Ctypes.allocate Ctypes.int 0 in
  let stream = F.Typeface.open_stream face (Some idx_ptr) in
  stream, Ctypes.(!@ idx_ptr)

let open_existing_stream face =
  let idx_ptr = Ctypes.allocate Ctypes.int 0 in
  let stream = F.Typeface.open_existing_stream face (Some idx_ptr) in
  stream, Ctypes.(!@ idx_ptr)

let get_font_style face =
  let style = F.Typeface.get_font_style face in
  Gc.finalise F.Font_style.delete style;
  style

let copy_table_data face tag =
  match F.Typeface.copy_table_data face tag with
  | Some data ->
    Gc.finalise F.Data.unref data;
    Some data
  | None -> None

let get_units_per_em = F.Typeface.get_units_per_em
