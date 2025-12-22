type language_session = {
    language_name: string;
    start_time_epoch: float;
    last_problem_solved: int;
    finished: bool;
    config_hash: string;
  }
[@@deriving yojson]

type session = {
    schema_version: int;
    languages: language_session list;
  }
[@@deriving yojson]

(* Constants and default session values *)
let session_schema_version = 1

let default = {
    schema_version = session_schema_version;
    languages = [];
  }

let default_language_session name = {
    language_name = name;
    start_time_epoch = Unix.time ();
    last_problem_solved = -1;
    finished = false;
    config_hash = "";
  }

(* Functions for managing the session *)
(* TODO: implement the hash to check tampering with the configs *)
let ensure_state_dir () =
  let dir = Utils.state_dir () in
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o755

let rebuild_session_file () =
  let session_file = Utils.session_file () in
  ensure_state_dir ();
  Yojson.Safe.to_file session_file (session_to_yojson default);
  default

let load_session () =
  let session_file = Utils.session_file () in
  ensure_state_dir ();
  match Utils.read_file session_file with
  | Error _ -> rebuild_session_file ()
  | Ok json_string ->
     match session_of_yojson (Yojson.Safe.from_string json_string) with
     | Ok session -> session
     | Error _ -> rebuild_session_file ()

let save_session session =
  let session_file = Utils.session_file () in
  Yojson.Safe.to_file session_file (session_to_yojson session)

let load_language_session language =
  let loaded_session = load_session () in
  match List.find_opt (fun lang -> lang.language_name = language) loaded_session.languages with
  | Some value -> value
  | None ->
     let new_lang_session = default_language_session language in
     save_session { loaded_session with
         languages = new_lang_session :: loaded_session.languages
       };
     new_lang_session

let set_last_problem language last_problem_index =
  let loaded_session = load_session () in
  let replace list new_val = List.map (fun x -> if x.language_name = language then new_val else x) list in
  let lang_session = load_language_session language in
  let updated_lang_session = {
      lang_session with
      last_problem_solved = last_problem_index
    } in
  begin
  let new_languages = replace loaded_session.languages updated_lang_session in
  save_session { loaded_session with
      languages = new_languages
    };
  end
  
let set_language_as_finished language =
  let loaded_session = load_session () in
  let lang_session = load_language_session language in
  let replace list new_val = List.map (fun x -> if x.language_name = language then new_val else x) list in
  let updated_lang_session = {
      lang_session with
      finished = true
    } in
  let new_languages = replace loaded_session.languages updated_lang_session in
  save_session { loaded_session with
      languages = new_languages
    }
