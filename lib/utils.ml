open Bos

let file_exists = Sys.file_exists

let state_dir () =
  let xdg = Xdg.create ~env:Sys.getenv_opt () in
  Xdg.state_dir xdg

let read_file filename =
  try
    let ic = open_in filename in
    let len = in_channel_length ic in
    let contents = really_input_string ic len in
    close_in ic;
    Ok contents
  with
  | Sys_error msg -> Error ("Failed to read file: " ^ msg)

let check_if_file path =
  if file_exists path then
    if Sys.is_directory path then
      false
    else
      true
  else
    false

let make_temp_dir ?(prefix="cadru") () =
  Filename.temp_dir prefix ""

let copy_source_file_contents src dest =
  let content =
    In_channel.with_open_text src In_channel.input_all in
  Out_channel.with_open_text dest (fun out_channel ->
      Out_channel.output_string out_channel content)

let create_source_file tempdir filename =
  let new_path = tempdir ^ "/" ^ filename in
  let oc = open_out new_path
  in
  close_out oc;
  new_path   

let run_with_input ~(cmd : Cmd.t) ~(input : string)
  : (string, Rresult.R.msg) result =
  let run_out =
    OS.Cmd.run_io
      cmd
      (OS.Cmd.in_string input)
  in
  OS.Cmd.to_string run_out
