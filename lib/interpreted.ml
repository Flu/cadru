open Config
open Bos
open Bos.Cmd

let rec test_solution ?(index=0) interpreter temp_file test_cases : (bool * int) =
  if index >= Array.length test_cases then
    (true, 0)
  else
    let test = test_cases.(index) in
    let cmd = Cmd.v interpreter % temp_file in
    match Utils.run_with_input ~cmd ~input:test.input with
    | Ok out ->
       if String.trim out = String.trim test.output then
         test_solution interpreter temp_file test_cases ~index:(index+1)
       else (false, index)
    | Error _ -> (false, index)

let prepare
      ~source_filename:source_filename
      ~compiler:_ ~compiler_args:_
      ~solution_path:solution_path
      ~executable:_ =
  let temp_dir = Utils.make_temp_dir () in
  let temp_file = Utils.create_source_file temp_dir source_filename in
  Utils.copy_source_file_contents solution_path temp_file;
  Some temp_file

let run problem ~compiler:interpreter ~temp_file_path:temp_file_path =
  let test_cases = Array.of_list problem.test_cases in
  let hidden_test_cases = Array.of_list problem.hidden_test_cases in

  match test_solution interpreter temp_file_path test_cases with
  | (false, n) -> Judge_sig.return_failed_test_error (Some false) (Some n)
  | _ -> match test_solution interpreter temp_file_path hidden_test_cases with
         | (false, n) -> Judge_sig.return_failed_test_error (Some true) (Some n)
         | _ -> Judge_sig.return_judge_success ()

let cleanup _ = ()
