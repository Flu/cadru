open Config
open Judge_sig

let run config filepath =
  {
    success = true;
    last_failed_test = if config.interpreted == true then Some 6 else Some 2;
    is_failed_test_hidden = Some (filepath = "here");
    error_type = None;
  }
