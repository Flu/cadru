[@@@ocaml.warning "-32-37"]

open Cadru

let () =
  begin match CommandLineOptions.parse_arguments () with
  | { version = true; _ } -> print_string "v0.0.2"
  | { version = false; exercise = ex; language = language } -> Interface.interface_loop ex language
  end;
  ();
