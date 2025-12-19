open Judge_sig

let file_exists = Sys.file_exists

let check_if_file path =
  if file_exists path then
    if Sys.is_directory path then
      false
    else
      true
  else
    false

let make_temp_dir () =
  Filename.temp_dir "cadru" ""

let copy_source_file_contents src dest =
  let content =
    In_channel.with_open_text src In_channel.input_all in
  Out_channel.with_open_text dest (fun out_channel ->
      Out_channel.output_string out_channel content)

let create_source_file tempdir filename =
  let new_path = tempdir ^ "/" ^ filename in
  let oc = open_out new_path
  in
  close_out oc;
  new_path   

let return_compilation_error () =
  {
      success = false;
      last_failed_test = None;
      is_failed_test_hidden = None;
      error_type = Some CompilationError;
  }

let return_runtime_error () =
  {
      success = false;
      last_failed_test = None;
      is_failed_test_hidden = None;
      error_type = Some RuntimeError;
  }

let return_failed_test_error hidden which =
  {
      success = false;
      last_failed_test = which;
      is_failed_test_hidden = hidden;
      error_type = Some FailedTest;
  }

let return_judge_success () =
  {
      success = true;
      last_failed_test = None;
      is_failed_test_hidden = None;
      error_type = None;
  }
