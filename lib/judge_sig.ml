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

module type Judge = sig
  val run : Config.config -> Config.problem -> string -> judge_result
end
