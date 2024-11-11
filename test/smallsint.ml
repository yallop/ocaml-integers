let () = print_endline "Small int operations test: ?"

(* Asserting max and min integers are correct *)
let () =
  let check8 expected res =
    let open Signed.Int8 in
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  let check16 expected res =
    let open Signed.Int16 in
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  assert (check8 127 Signed.Int8.max_int);
  assert (check8 (-128) Signed.Int8.min_int);
  assert (check16 32767 Signed.Int16.max_int);
  assert (check16 (-32768) Signed.Int16.min_int);
  ()

(* Asserting that integer conversions correctly overflow *)
let () =
  let open Signed.Int8 in
  let check expected res =
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  assert (check 0 zero);
  assert (check (-1) minus_one);
  assert (check 127 (of_int 127));
  assert (check (-128) (of_int 128));
  assert (check (-64) (of_int 192));
  ()

(* Asserting that roundtrip int -> string -> int conversions survive *)
let () =
  let open Signed.Int8 in
  let check i =
    let str = to_string i in
    equal i (of_string str)
  in
  assert (check (of_int 1));
  assert (check (of_int 127));
  assert (check (of_int (-128)));
  assert (check (of_int 192));
  ()

(* Asserting that addition performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  assert (check 1 (add zero one));
  assert (check (-128) (add max_int one));
  assert (check (-65) (add max_int (of_int 64)));
  ()

(* Asserting that subtraction performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  assert (check (-1) (sub zero one));
  assert (check 127 (sub min_int one));
  assert (check 64 (sub min_int (of_int 64)));
  ()

(* Asserting that multiplication performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  assert (check (-1) (mul minus_one one));
  assert (check (-128) (mul minus_one min_int));
  assert (check (-2) (mul max_int (of_int 2)));
  ()

(* Asserting that logical right shifting performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  assert (check (-1) (shift_right_logical minus_one 0));
  assert (check 127 (shift_right_logical minus_one 1));
  ()

(* Asserting that integer parsing performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    let equal : int -> int -> bool = Stdlib.( = ) in
    equal expected (to_int res) in
  assert (check 1 (of_string "1"));
  assert (check 127 (of_string "127"));
  assert (check (-128) (of_string "-128"));
  assert (try (ignore (of_string "128"); false) with Failure _ -> true);
  assert (try (ignore (of_string "-129"); false) with Failure _ -> true);
  assert (check (-1) (of_string "-1"));
  assert (check (0b01) (of_string "0b01"));
  assert (check (-0b01) (of_string "-0b01"));
  assert (check (0xf) (of_string "0xf"));
  assert (check (-0xf) (of_string "-0xf"));
  assert (check (0x7f) (of_string "0x7f"));
  assert (check (-0x80) (of_string "-0x80"));
  assert (try (ignore (of_string "0x80"); false) with Failure _ -> true);
  assert (try (ignore (of_string "-0x81"); false) with Failure _ -> true);
  ()

(* Asserting that integer printing performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    let equal : string -> string -> bool = Stdlib.( = ) in
    equal expected res in
  assert (check "1" (to_string (of_int 1)));
  assert (check "127" (to_string (of_int 127)));
  assert (check "-128" (to_string (of_int 128)));       (* FIXME: This value seems strange? *)
  assert (check "-128" (to_string (of_int (-128))));
  assert (check "127" (to_string (of_int (-129))));     (* FIXME: This value seems strange? *)
  assert (check "-1" (to_string (of_int (-1))));
  assert (check "f" (to_hexstring (of_int (0xf))));
  assert (check "7f" (to_hexstring max_int));
  assert (check "80" (to_hexstring min_int));
  assert (check "81" (to_hexstring (of_int (-0x7f))));  (* FIXME: This value seems strange? *)
  ()

let () = print_endline "Small int operations test: ✓"
