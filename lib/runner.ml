open Config

type executable =
  | Binary of {path: string}
  | Script of {
      interpreter: string;
      script: string;
    }

let rec test_solution ?(index=0) cmd test_cases : (bool * int) =
  if index >= Array.length test_cases then
    (true, 0)
  else
    let test = test_cases.(index) in
    match Utils.run_with_input ~cmd ~input:test.input with
    | Ok out ->
       if String.trim out = String.trim test.output then
         test_solution cmd test_cases ~index:(index+1)
       else (false, index)
    | Error _ -> (false, index)

let run test_cases executable =
  let open Bos.Cmd in
  let test_cases = Array.of_list test_cases in
  let cmd = begin match executable with
  | Script { interpreter; script } -> v interpreter % script
  | Binary { path } -> v ("./" ^ path) end in

  test_solution cmd test_cases
