let prologue = {|
#include "c/sk_types.h"
|}

let () =
  print_endline prologue;
  Cstubs.Types.write_c Format.std_formatter (module Skia_bindings_types.M)
