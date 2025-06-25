(lang dune 3.19)
(using directory-targets 0.1)

(name oski)

(generate_opam_files true)

(source
 (github syaiful6/oski))

(authors "Syaiful Bahri <syai.bahri6@gmail.com>")

(maintainers "Syaiful Bahri <syai.bahri6@gmail.com>")

(license LICENCE)

(documentation https://url/to/documentation)

(package
 (name oski)
 (synopsis "ocaml binding to SKIA")
 (description "oski is Ocaml binding to SKIA")
 (depends
   ocaml
   dune
   (ctypes (>= 0.14.0))
   (alcotest :with-test)
   (dune-site :with-test)
   (ocaml-lsp-server :with-dev-setup)
   (dot-merlin-reader :with-dev-setup)
   (ocamlformat :with-dev-setup))
 (tags
  ("skia" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
