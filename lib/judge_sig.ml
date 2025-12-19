type judge_error =
  | CompilationError
  | RuntimeError
  | FailedTest

type judge_result = {
    success: bool;
    last_failed_test: int option;
    is_failed_test_hidden: bool option;
    error_type: judge_error option;
  }
  
module type Judge = sig
  val run : Config.config -> string -> judge_result
end
