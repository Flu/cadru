open Config
open Bos
open Bos.Cmd

let check_compilers compiler_list arg_list =
  let compiler_array = Array.of_list compiler_list in
  let arg_array = Array.of_list arg_list in
  let rec aux index found =
    if index == Array.length compiler_array then
      found
    else
      let cmd = Cmd.v compiler_array.(index) % arg_array.(index) in
      begin match Utils.run_with_input ~cmd ~input:"" with
      | Ok _ -> aux (index+1) (compiler_array.(index) :: found)
      | Error _ -> aux (index+1) found
      end
  in
  aux 0 []

let rec test_solution ?(index=0) interpreter temp_file test_cases : (bool * int) =
  if index >= Array.length test_cases then
    (true, 0)
  else
    let test = test_cases.(index) in
    let cmd = Cmd.v interpreter % temp_file in
    begin match Utils.run_with_input ~cmd ~input:test.input with
    | Ok out ->
       if String.trim out = String.trim test.output then
         test_solution interpreter temp_file test_cases ~index:(index+1)
       else begin
           Printf.printf "Failed test %d. Output: %s. Expected: %s\n" index out test.output;
           (false, index)
         end
    | Error _ -> (false, index)
    end
          
let run config problem solution_path =
  let interpreters = check_compilers config.compiler config.check_exists_args in
  if List.length interpreters = 0 then
    Utils.return_interpreter_not_found ()
  else
    let interpreter = List.nth interpreters 0 in 
    
    let temp_dir = Utils.make_temp_dir () in
    let temp_file = Utils.create_source_file temp_dir config.source_file in
    Utils.copy_source_file_contents solution_path temp_file;
    
    let test_cases = Array.of_list problem.test_cases in
    let hidden_test_cases = Array.of_list problem.hidden_test_cases in
    
    match test_solution interpreter temp_file test_cases with
    | (false, n) -> Utils.return_failed_test_error (Some false) (Some n)
    | _ -> begin match test_solution interpreter temp_file hidden_test_cases with
           | (false, n) -> Utils.return_failed_test_error (Some true) (Some n)
           | _ -> Utils.return_judge_success ()
           end;
