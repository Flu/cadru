(lang dune 3.20)

(name cadru)

(version 0.0.2)

(generate_opam_files true)

(source
 (github Flu/cadru))

(authors "Adrian Fluturel <fluturel.adrian@gmail.com>")

(maintainers "Adrian Fluturel <fluturel.adrian@gmail.com>")

(license Unlicense)

(package
 (name cadru)
 (synopsis "Terminal game for learning programming languages")
 (description "A game you can run offline that teaches you different programming languages through exercises, taking the scenic view on your way to mastering said language.")
 (depends ANSITerminal bos ocaml ppx_deriving_yojson xdg yaml yojson)
 (tags
  (learning programming offline hackable game)))
