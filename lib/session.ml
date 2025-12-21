type language_session = {
    language_name: string;
    start_time_unix: int;
    last_problem_solved: int;
    finished: bool;
    config_hash: string;
  }

type session = {
    schema_version: int;
    languages: language_session list;
  }
