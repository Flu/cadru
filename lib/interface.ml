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

(* Prettyprint a single problem from the data set *)
let pretty_print_problem (length: int) (problem: Config.problem) =
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
