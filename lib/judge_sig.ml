type judge_error =
  | CompilerNotFound
  | InterpreterNotFound
  | CompilationError
  | RuntimeError
  | FailedTest

type judge_result = {
    success: bool;
    failed_test_index: int option;
    is_failed_test_hidden: bool option;
    error_type: judge_error option;
  }

let return_compiler_not_found () =
  {
    success = false;
    failed_test_index = None;
    is_failed_test_hidden = None;
    error_type = Some CompilerNotFound;
  }

let return_interpreter_not_found () =
  {
    success = false;
    failed_test_index = None;
    is_failed_test_hidden = None;
    error_type = Some InterpreterNotFound;
  }

let return_compilation_error () =
  {
      success = false;
      failed_test_index = None;
      is_failed_test_hidden = None;
      error_type = Some CompilationError;
  }

let return_runtime_error () =
  {
      success = false;
      failed_test_index = None;
      is_failed_test_hidden = None;
      error_type = Some RuntimeError;
  }

let return_failed_test_error hidden which =
  {
      success = false;
      failed_test_index = which;
      is_failed_test_hidden = hidden;
      error_type = Some FailedTest;
  }

let return_judge_success () =
  {
      success = true;
      failed_test_index = None;
      is_failed_test_hidden = None;
      error_type = None;
  }

let check_compilers compiler_list arg_list =
  let open Bos.Cmd in
  let compiler_array = Array.of_list compiler_list in
  let arg_array = Array.of_list arg_list in
  let rec aux index =
    if index == Array.length compiler_array then
      None
    else
      let cmd = v compiler_array.(index) % arg_array.(index) in
      begin match Utils.run_with_input ~cmd ~input:"" with
      | Ok _ -> Some index
      | Error _ -> aux (index+1)
      end
  in
  aux 0

module type Judge = sig
  val prepare : source_filename:string ->
                compiler:string ->
                compiler_args:string ->
                solution_path:string ->
                executable:string option ->
                string option
  
  val run : Config.problem ->
            compiler:string ->
            temp_file_path:string ->
            judge_result
  
  val cleanup : Config.config -> unit
end
