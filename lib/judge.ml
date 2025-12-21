open Config

module type JUDGE = Judge_sig.Judge

(* Dispatcher *)
let get_judge_module interpreted =
  if interpreted then
    (module Interpreted : JUDGE)
  else
    (module Compiled : JUDGE)

let run config problem filepath =
  let module J = (val get_judge_module config.interpreted : JUDGE) in
  match Judge_sig.check_compilers config.compiler config.check_exists_args with
  | None -> Judge_sig.return_compiler_not_found ()
  | Some index ->
     let compiler = List.nth config.compiler index in
     let compiler_args = List.nth config.compiler_args index in
     let tempfile = J.prepare
                      ~source_filename:config.source_file
                      ~compiler:compiler
                      ~compiler_args:compiler_args
                      ~solution_path:filepath
                      ~executable:config.executable_file in
     match tempfile with
     | Some file ->
        let return = J.run problem
                       ~compiler:compiler
                       ~temp_file_path:file in
        J.cleanup config;
        return
     | None ->
        Judge_sig.return_compilation_error ()
