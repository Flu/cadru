open ANSITerminal

(* Basic pattern string *)
let pattern count =
  let rec repeat n acc =
    if n <= 0 then acc
    else repeat (n - 1) (acc ^ "<>")
  in
  repeat count ""

(* Print an alternating pattern with the colours of the Romanian flag *)
let print_pattern_alternating ~repeat:repeat =
  let colors = [| red; yellow; blue |] in
  let rec aux n = match n with
    | 1 -> print_string [Bold; colors.(n mod 3)] "<>"
    | _ ->
       print_string [Bold; colors.(n mod 3)] "<>";
       aux (n - 1)
  in
  aux repeat

(* Print a titled section with alternating patterns *)
let print_header ?current ?total ?(left_count=3) ?(right_count=25) title =
  let counter = match current, total with
    | Some i, Some n -> Printf.sprintf " (%d/%d)" i n
    | _ -> ""
  in
  print_pattern_alternating ~repeat:left_count;
  print_string [] counter;
  print_string [] " ";
  print_string [Bold] title;
  print_string [] " ";
  print_pattern_alternating ~repeat:right_count;
  print_string [] "\n"

(* Print the description of a problem *)
let print_description text =
  print_string [] (text ^ "\n")

(* Print the hint of a problem *)
let print_hint = printf [Bold; green] "Hint: %s\n"

(* Print an individual test case *)
let print_test_case (test_case: Config.test_case)  =
  print_string [yellow] "Input:\n";
  print_string [] test_case.input;
  print_string [yellow] "Expected output:\n";
  print_string [] test_case.output

(* Print all shown test cases with some separator between them *)
let print_test_cases test_cases =
  let rec print_test_case_with_separator list num =
    match list with
    | [] -> ()
    | hd :: tl ->
       print_newline ();
       print_header ~left_count:3 ~right_count:10 (Printf.sprintf "Test %d" num);
       print_newline ();
       print_test_case hd;
       print_test_case_with_separator tl (num + 1)
  in
  print_test_case_with_separator test_cases 1;
  print_newline ();
  print_pattern_alternating ~repeat:17;
  print_newline ()

(* Print a full separator line, not alternating in colour *)
let print_separator ?(count=30) ?(color=blue) () =
  print_string [color] (pattern count);
  print_string [] "\n"

(* Print success message *)
let print_success msg =
  print_string [green; Bold] "✓";
  print_string [] (" " ^ msg ^ "\n")

(* Print error message *)
let print_error msg =
  print_string [red; Bold] "✗";
  print_string [] (" " ^ msg ^ "\n")

(* Print info message *)
let print_info msg =
  print_string [blue; Bold] "→";
  print_string [] (" " ^ msg ^ "\n")

(* Read the path to the solution from the user *)
let read_path_from_user () =
  try
    print_string [] "Path to solution file: ";
    flush stdout;
    Some (read_line ())
  with End_of_file -> None

(* Prettyprint a single problem from the data set *)
let show_problem (length: int) (problem: Config.problem) =
  erase Screen;
  set_cursor 1 1;
  print_header ~current:problem.id ~total:length problem.title;
  print_description problem.description;
  begin match problem.hint with
  | Some hint ->
     print_hint hint;
     print_newline ();
  | None -> ()
  end;
  print_test_cases problem.test_cases

let problemset_done language =
  erase Screen;
  set_cursor 1 1;
  printf [Bold; red] "You are done with all the problems for %s, congratulations!\n" language

let wait_for_enter () =
  printf [] "Press Enter to continue.\n";
  let _ = read_line () in
  ()

let get_config language =
    match Config.read_config_from_yaml ("./assets/" ^ language ^ ".yaml") with
    | Ok config -> config
    | Error _ ->
       Printf.eprintf "Config for language \"%s\" not found. Are you sure it exists?\n" language;
       exit 1

let rec interface_loop ~language_name:language ?(current_index=0) =
  let lang_config = get_config language in
  let problems = Array.of_list lang_config.problems in
  let num_problems = Array.length problems in

  if current_index = num_problems - 1 then
    printf [Bold; green] "You've solved all the available problems for %s. Congratulations!\n" language;
  
  let problem = problems.(current_index) in

  show_problem (num_problems - 1) problem;
  let solution_path = read_path_from_user () in

  if solution_path = None then begin
      eprintf [] "EOF reached. Exiting.";
      exit 2
    end;
  
  if not (Utils.check_if_file (Option.get solution_path)) then begin
      printf [] "File does not exist, is inaccessible or is a directory.\n";
      wait_for_enter ();
      interface_loop ~language_name:language ~current_index:current_index
    end
  else begin
      (* TODO: judge the solution here and move on to the next problem if ok *)
      printf [] "something\n";
      wait_for_enter ();
      interface_loop ~language_name:language ~current_index:(current_index+1)
    end
