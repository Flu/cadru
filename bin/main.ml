open Cadru

let () =
  begin match CommandLineOptions.parse_arguments () with
  | { version = true; _ } -> print_string "v0.0.2"
  | { version = false; exercise = ex; language = language } ->
     Interface.interface_loop ~language_name:language ~current_index:ex
  end;
  ();
