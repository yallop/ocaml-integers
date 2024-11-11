(* Adapted from Anil Madhavapeddy's ocaml-uri package. *)

let printers = [ "fun fmt v -> Format.fprintf fmt \"<sint %s>\" (Signed.SInt.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<long %s>\" (Signed.Long.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<llong %s>\" (Signed.LLong.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<uchar %s>\" (Unsigned.UChar.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<uint8 %s>\" (Unsigned.UInt8.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<uint16 %s>\" (Unsigned.UInt16.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<uint32 %s>\" (Unsigned.UInt32.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<uint64 %s>\" (Unsigned.UInt64.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<ushort %s>\" (Unsigned.UShort.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<uint %s>\" (Unsigned.UInt.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<ulong %s>\" (Unsigned.ULong.to_string v)";
                 "fun fmt v -> Format.fprintf fmt \"<ullong %s>\" (Unsigned.ULLong.to_string v)";]

let eval_string
      ?(print_outcome = false) ?(err_formatter = Format.err_formatter) str =
  let lexbuf = Lexing.from_string str in
  let phrase = !Toploop.parse_toplevel_phrase lexbuf in
  Toploop.execute_phrase print_outcome err_formatter phrase

let install_printer printer =
  begin
    ignore (eval_string (Printf.sprintf "let _printer = %s;;" printer));
    ignore (eval_string (Printf.sprintf "#install_printer _printer;;"));
  end

let is_utop () =
  Option.is_some (Toploop.get_directive "utop_help")

let () =
  (* Preload the toplevel environment and integers library if we are in utop.
     This is done to ensure the required modules are in scope before the
     printers are installed, as dune will not do this automatically. *)
  if is_utop () then begin
    Toploop.initialize_toplevel_env ();
    ignore (eval_string "#require \"integers\";;");
  end;

  List.iter install_printer printers
