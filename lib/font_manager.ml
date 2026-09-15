module F = Oski_ffi.M

module Font_style_set = struct
  type t = F.Font_style_set.t

  let get_count = F.Font_style_set.get_count

  let make_empty () =
    let styleset = F.Font_style_set.make_empty () in
    Gc.finalise F.Font_style_set.unref styleset;
    styleset

  let get_style styleset index =
    let font_style = F.Font_style.make_empty () in
    let style = F.String.empty () in
    F.Font_style_set.get_style styleset index font_style style;
    let name = F.String.to_string style in
    F.String.delete style;
    font_style, if name = "" then None else Some name

  let make_typeface styleset index =
    match F.Font_style_set.make_typeface styleset index with
    | Some typeface ->
      Gc.finalise F.Typeface.unref typeface;
      Some typeface
    | None -> None

  let match_style styleset font_style =
    match F.Font_style_set.match_style styleset font_style with
    | Some typeface ->
      Gc.finalise F.Typeface.unref typeface;
      Some typeface
    | None -> None
end

type t = F.Font_manager.t

let make () =
  let mgr = F.Font_manager.make_default () in
  Gc.finalise F.Font_manager.unref mgr;
  mgr

let make_style_set mgr index =
  match F.Font_manager.make_styleset mgr index with
  | Some styleset ->
    Gc.finalise F.Font_style_set.unref styleset;
    Some styleset
  | None -> None

let match_family mgr family =
  match F.Font_manager.match_family mgr family with
  | Some styleset ->
    Gc.finalise F.Font_style_set.unref styleset;
    Some styleset
  | None -> None

let match_family_style mgr family style =
  match F.Font_manager.match_family_style mgr family style with
  | Some typeface ->
    Gc.finalise F.Typeface.unref typeface;
    Some typeface
  | None -> None

let count_families = F.Font_manager.count_families

let match_family_style_character mgr family style locales character =
  let open Ctypes in
  let c_locales = CArray.of_list string locales in
  let character_32 = character |> Uchar.to_int |> Int32.of_int in

  let maybe_typeface =
    F.Font_manager.match_family_style_character
      mgr
      family
      style
      (c_locales |> CArray.start)
      (CArray.length c_locales)
      character_32
  in

  match maybe_typeface with
  | Some typeface ->
    Gc.finalise F.Typeface.unref typeface;
    Some typeface
  | None -> None

let get_family_name mgr index =
  let family_name = F.String.empty () in
  F.Font_manager.get_family_name mgr index family_name;
  let name = F.String.to_string family_name in
  F.String.delete family_name;
  name
