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

let to_native t =
  let metrics = Ctypes.make Oski_types.M.Font_metrics.t in
  Ctypes.(
    setf metrics Oski_types.M.Font_metrics.flags t.flags;
    setf metrics Oski_types.M.Font_metrics.top t.top;
    setf metrics Oski_types.M.Font_metrics.ascent t.ascent;
    setf metrics Oski_types.M.Font_metrics.descent t.descent;
    setf metrics Oski_types.M.Font_metrics.bottom t.bottom;
    setf metrics Oski_types.M.Font_metrics.leading t.leading;
    setf metrics Oski_types.M.Font_metrics.avg_char_width t.avg_char_width;
    setf metrics Oski_types.M.Font_metrics.max_char_width t.max_char_width;
    setf metrics Oski_types.M.Font_metrics.xmin t.xmin;
    setf metrics Oski_types.M.Font_metrics.xmax t.xmax;
    setf metrics Oski_types.M.Font_metrics.xheight t.xheight;
    setf metrics Oski_types.M.Font_metrics.cap_height t.cap_height;
    setf
      metrics
      Oski_types.M.Font_metrics.underline_thickness
      t.underline_thickness;
    setf
      metrics
      Oski_types.M.Font_metrics.underline_position
      t.underline_position;
    setf
      metrics
      Oski_types.M.Font_metrics.strikeout_thickness
      t.strikeout_thickness;
    setf
      metrics
      Oski_types.M.Font_metrics.strikeout_position
      t.strikeout_position);
  metrics

let to_native_ptr t = to_native t |> Ctypes.addr

let of_native metrics =
  { flags = Ctypes.getf metrics Oski_types.M.Font_metrics.flags
  ; top = Ctypes.getf metrics Oski_types.M.Font_metrics.top
  ; ascent = Ctypes.getf metrics Oski_types.M.Font_metrics.ascent
  ; descent = Ctypes.getf metrics Oski_types.M.Font_metrics.descent
  ; bottom = Ctypes.getf metrics Oski_types.M.Font_metrics.bottom
  ; leading = Ctypes.getf metrics Oski_types.M.Font_metrics.leading
  ; avg_char_width =
      Ctypes.getf metrics Oski_types.M.Font_metrics.avg_char_width
  ; max_char_width =
      Ctypes.getf metrics Oski_types.M.Font_metrics.max_char_width
  ; xmin = Ctypes.getf metrics Oski_types.M.Font_metrics.xmin
  ; xmax = Ctypes.getf metrics Oski_types.M.Font_metrics.xmax
  ; xheight = Ctypes.getf metrics Oski_types.M.Font_metrics.xheight
  ; cap_height = Ctypes.getf metrics Oski_types.M.Font_metrics.cap_height
  ; underline_thickness =
      Ctypes.getf metrics Oski_types.M.Font_metrics.underline_thickness
  ; underline_position =
      Ctypes.getf metrics Oski_types.M.Font_metrics.underline_position
  ; strikeout_thickness =
      Ctypes.getf metrics Oski_types.M.Font_metrics.strikeout_thickness
  ; strikeout_position =
      Ctypes.getf metrics Oski_types.M.Font_metrics.strikeout_position
  }
