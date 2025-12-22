open Cadru

let () =
  begin match CommandLineOptions.parse_arguments () with
  | { version = true; _ } -> print_string "v0.0.2"
  | { version = false; exercise = _; language = language } ->
     Interface.interface_main ~language_name:language
  end;
  ();
