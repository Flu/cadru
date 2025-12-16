type test_case = {
  input : string;
  output : string;
}
[@@deriving yojson]

type problem = {
  id : int;
  title : string;
  difficulty : string;
  description : string;
  hint : string option;
  reference : string option;
  test_cases : test_case list;
  hidden_test_cases : test_case list;
}
[@@deriving yojson]

type config = {
  name : string;
  interpreted : bool;
  compiler : string list;
  compiler_args : string option;
  check_exists_args : string list;
  run_command : string option;
  class_name : string option;
  problems : problem list;
}
[@@deriving yojson]

let rec yaml_to_yojson = function
  | `Null -> `Null
  | `Bool b -> `Bool b
  | `Float f -> 
      if Float.is_integer f then
        `Int (int_of_float f)
      else
        `Float f
  | `String s -> `String s
  | `A lst -> `List (List.map yaml_to_yojson lst)
  | `O assoc -> `Assoc (List.map (fun (k, v) -> (k, yaml_to_yojson v)) assoc)

let read_file filename =
  let ic = open_in filename in
  let len = in_channel_length ic in
  let contents = really_input_string ic len in
  close_in ic;
  contents

let read_config_from_yaml filename =
  let yaml_string = read_file filename in
  match Yaml.of_string yaml_string with
  | Ok yaml_value ->
      let json = yaml_to_yojson yaml_value in
      (match config_of_yojson json with
      | Ok config -> Ok config
      | Error msg -> Error ("Failed to parse config: " ^ msg))
  | Error (`Msg msg) -> Error ("Failed to parse YAML: " ^ msg)
