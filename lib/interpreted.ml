open Config

  (* { *)
  (*   success = false; *)
  (*   last_failed_test = if config.interpreted == true then Some 6 else Some 2; *)
  (*   is_failed_test_hidden = Some (filepath = "here"); *)
  (*   error_type = None; *)
  (* } *)

let run config solution_path =
  let temp_dir = Utils.make_temp_dir () in
  let temp_file = Utils.create_source_file temp_dir config.source_file in
  Utils.copy_source_file_contents solution_path temp_file;
  Utils.return_judge_success ()
  
