open Cadru

let pretty_print_problem (length: int) (problem : Config.problem) =
  Printf.printf "%d/%d: %s\n" length problem.id problem.title;
  Printf.printf "%s\n" problem.description

let () =
  match Config.read_config_from_yaml "./assets/python.yaml" with
  | Ok config ->
     Printf.printf "Config name: %s\n" config.name;
     print_newline ();
     List.iter (pretty_print_problem (List.length config.problems)) config.problems
  | Error msg ->
     Printf.eprintf "Error: %s\n" msg
