type options = {
    version: bool;
    exercise: int;
    language: string
  }

let usage_message = "cadru [--help|--version|--exercise] <language>"

let version_flag = ref false
let exercise_option = ref 0
let language_option = ref ""

let speclist =
  [("--version", Arg.Set version_flag, "Print the version of the current program");
   ("--exercise", Arg.Set_int exercise_option, "Start from this exercise on")]

let anon_function language_name =
  language_option := language_name

let parse_arguments () =
  Arg.parse speclist anon_function usage_message;
  {
    version = !version_flag;
    exercise = !exercise_option;
    language = !language_option;
  }
