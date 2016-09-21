#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "integers" @@ fun c ->
  Ok [ Pkg.mllib "src/integers.mllib";
       Pkg.clib "src/libintegers.clib";
       Pkg.mllib "top/integer_printers.mllib";
       Pkg.lib "src/ocaml_integers.h"; ]
