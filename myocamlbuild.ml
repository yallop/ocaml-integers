open Ocamlbuild_plugin

let () = dispatch begin function
    | After_rules ->
      dep ["c"; "compile"; "use_integer_headers"] ["src/ocaml_integers.h"];

      flag ["use_integer_stubs"] &
        S[A"-I"; A"src"];

      dep ["ocaml"; "link"; "byte"; "library"; "use_integer_stubs"]
        ["src/dllintegers"-.-(!Options.ext_dll)];
      flag ["ocaml"; "link"; "byte"; "library"; "use_integer_stubs"] &
        S[A"-dllib"; A"-lintegers"];

      dep ["ocaml"; "link"; "native"; "library"; "use_integer_stubs"]
        ["src/libintegers"-.-(!Options.ext_lib)];
      flag ["ocaml"; "link"; "native"; "library"; "use_integer_stubs"] &
        S[A"-cclib"; A"-lintegers"];
    | _ -> ()
end
