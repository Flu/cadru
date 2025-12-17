[@@@ocaml.warning "-32-37"]

open Cadru

let () =
  match Config.read_config_from_yaml "./assets/python.yaml" with
  | Ok config ->
     Printf.printf "Config name: %s\n" config.name;
     print_newline ();
     List.iter (Interface.pretty_print_problem (List.length config.problems)) config.problems
  | Error msg ->
     Printf.eprintf "Error: %s\n" msg
