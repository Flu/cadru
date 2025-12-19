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
  
module type Judge = sig
  val run : Config.config -> Config.problem -> string -> judge_result
end
