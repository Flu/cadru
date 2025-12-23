open Config

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

let compile_source ~compiler:compiler ~compiler_args:args ~source_path:source_path ~executable:name =
  let open Bos.Cmd in
  let cmd = List.fold_left (%) (v compiler) (source_path :: (String.split_on_char ' ' args)) in
  match Utils.run_with_input ~cmd ~input:"" with
  | Ok _ ->
     Some (Runner.Binary {
               path = name
       })
  | Error _ -> None

let prepare_workspace config ~compiler:compiler ~compiler_args:args ~solution_path:sol_path =
  let temp_dir = Utils.make_temp_dir () in
  let temp_file = Utils.create_source_file temp_dir config.source_file in
  Utils.copy_source_file_contents sol_path temp_file;
  if config.interpreted = true then
  Some (Runner.Script {
      interpreter = compiler;
      script = temp_file
    })
  else
    compile_source
      ~compiler:compiler
      ~compiler_args:args
      ~source_path:sol_path
      ~executable:(Option.get config.executable_file)

let run_judge config problem filepath =
  match check_compilers config.compiler config.check_exists_args with
  | None -> return_compiler_not_found ()
  | Some index ->
     let compiler = List.nth config.compiler index in
     let compiler_args = List.nth config.compiler_args index in
     let executable = prepare_workspace
                        config
                        ~compiler:compiler
                        ~compiler_args:compiler_args
                        ~solution_path:filepath in
     match executable with
     | Some (exec) ->
        begin match Runner.run problem.test_cases exec with
        | (false, n) -> return_failed_test_error (Some false) (Some n)
        | _ -> match Runner.run problem.hidden_test_cases exec with
               | (false, n) -> return_failed_test_error (Some true) (Some n)
               | _ -> return_judge_success ()
        end
     | None -> return_compilation_error ()
     
