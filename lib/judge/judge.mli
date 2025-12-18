open Config

type judge_error =
  | CompilationError
  | RuntimeError
  | FailedTest
(* For future features*)
(*| ExceededTime
  | ExceededSpace *)

type judge_result = {
    success: bool;
    last_failed_test: int option;
    is_failed_test_hidden: bool option;
    error_type: judge_error;
  }

val run : string -> string
