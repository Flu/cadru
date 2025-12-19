open Config

type judge_error = Judge_sig.judge_error
type judge_result = Judge_sig.judge_result

module type JUDGE = Judge_sig.Judge

(* Dispatcher *)
let get_judge_module interpreted =
  if interpreted then
    (module Interpreted : JUDGE)
  else
    (module Compiled : JUDGE)

let run config filepath =
  let module J = (val get_judge_module config.interpreted : JUDGE) in
  J.run config filepath
