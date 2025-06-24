(lang dune 3.19)

(name skia)

(generate_opam_files true)

(source
 (github syaiful6/skia))

(authors "Syaiful Bahri <syai.bahri6@gmail.com>")

(maintainers "Syaiful Bahri <syai.bahri6@gmail.com>")

(license LICENCE)

(documentation https://url/to/documentation)

(package
 (name skia)
 (synopsis "ocaml binding to SKIA")
 (description "skia is a binding to SKIA")
 (depends
   ocaml
   dune
   (ctypes (>= 0.14.0))
   (ocaml-lsp-server :with-dev-setup)
   (dot-merlin-reader :with-dev-setup)
   (ocamlformat :with-dev-setup))
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
