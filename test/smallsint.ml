let () = print_endline "Small signed int operations test: ?"

(* --- Int8 tests --- *)

(* Asserting max and min integers are correct *)
let () =
  let open Signed.Int8 in
  assert (to_int max_int = 127);
  assert (to_int min_int = (-128));
  ()

(* Asserting that of_int truncates to 8 bits *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 zero);
  assert (check 1 one);
  assert (check (-1) minus_one);
  assert (check 127 (of_int 127));
  (* of_int truncates: 128 wraps to -128 in 8-bit signed *)
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
  assert (check (of_int 0));
  assert (check (of_int 1));
  assert (check (of_int 127));
  assert (check (of_int (-1)));
  assert (check (of_int (-128)));
  ()

(* Asserting that addition performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 1 (add zero one));
  assert (check (-128) (add max_int one));
  assert (check (-65) (add max_int (of_int 64)));
  ()

(* Asserting that subtraction performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check (-1) (sub zero one));
  assert (check 127 (sub min_int one));
  assert (check 64 (sub min_int (of_int 64)));
  ()

(* Asserting that multiplication performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check (-1) (mul minus_one one));
  assert (check (-128) (mul minus_one min_int));
  assert (check (-2) (mul max_int (of_int 2)));
  ()

(* Asserting that division and remainder perform as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 63 (div max_int (of_int 2)));
  assert (check (-64) (div min_int (of_int 2)));
  assert (check 1 (rem max_int (of_int 2)));
  assert (check 0 (rem min_int (of_int 2)));
  ()

(* Asserting that bitwise operations perform as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 (logand (of_int 0x0F) (of_int 0x70)));
  assert (check 0x7F (logor (of_int 0x0F) (of_int 0x70)));
  assert (check 0x7F (logxor (of_int 0x0F) (of_int 0x70)));
  assert (check 0 (logxor max_int max_int));
  assert (check 0 (logand zero max_int));
  assert (check (-1) (lognot zero));
  assert (check 0 (lognot minus_one));
  ()

(* Asserting that shift operations perform as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 2 (shift_left one 1));
  assert (check (-128) (shift_left one 7));
  assert (check (-1) (shift_right minus_one 1));
  assert (check 63 (shift_right max_int 1));
  assert (check (-1) (shift_right_logical minus_one 0));
  assert (check 127 (shift_right_logical minus_one 1));
  ()

(* Asserting that neg and abs perform as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check (-1) (neg one));
  assert (check 1 (neg minus_one));
  assert (check 1 (abs one));
  assert (check 1 (abs minus_one));
  assert (check 127 (abs max_int));
  ()

(* Asserting that succ and pred perform as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 1 (succ zero));
  assert (check (-1) (pred zero));
  assert (check (-128) (succ max_int));
  assert (check 127 (pred min_int));
  ()

(* Asserting that compare and equal perform as expected *)
let () =
  let open Signed.Int8 in
  assert (equal zero zero);
  assert (equal max_int max_int);
  assert (not (equal zero one));
  assert (compare zero one < 0);
  assert (compare one zero > 0);
  assert (compare min_int max_int < 0);
  assert (Stdlib.( = ) (max zero one) one);
  assert (Stdlib.( = ) (min zero one) zero);
  ()

(* Asserting that integer parsing performs as expected *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 1 (of_string "1"));
  assert (check 127 (of_string "127"));
  assert (check (-128) (of_string "-128"));
  assert (try (ignore (of_string "128"); false) with Failure _ -> true);
  assert (try (ignore (of_string "-129"); false) with Failure _ -> true);
  assert (check (-1) (of_string "-1"));
  assert (check 0b01 (of_string "0b01"));
  assert (check (-0b01) (of_string "-0b01"));
  assert (check 0xf (of_string "0xf"));
  assert (check (-0xf) (of_string "-0xf"));
  assert (check 0x7f (of_string "0x7f"));
  assert (check (-0x80) (of_string "-0x80"));
  assert (try (ignore (of_string "0x80"); false) with Failure _ -> true);
  assert (try (ignore (of_string "-0x81"); false) with Failure _ -> true);
  assert (Signed.Int8.of_string_opt "127" <> None);
  assert (Signed.Int8.of_string_opt "bad" = None);
  ()

(* Asserting that integer printing performs as expected *)
let () =
  let open Signed.Int8 in
  assert (to_string one = "1");
  assert (to_string (of_int 127) = "127");
  (* of_int truncates: 128 wraps to -128 in 8-bit signed *)
  assert (to_string (of_int 128) = "-128");
  assert (to_string (of_int (-128)) = "-128");
  (* of_int truncates: -129 wraps to 127 in 8-bit signed *)
  assert (to_string (of_int (-129)) = "127");
  assert (to_string (of_int (-1)) = "-1");
  (* hexstring prints unsigned two's complement representation *)
  assert (to_hexstring (of_int 0xf) = "f");
  assert (to_hexstring max_int = "7f");
  assert (to_hexstring min_int = "80");
  assert (to_hexstring (of_int (-0x7f)) = "81");
  ()

(* Asserting that of_int64/to_int64 conversions work *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 (of_int64 0L));
  assert (check 1 (of_int64 1L));
  assert (check 127 (of_int64 127L));
  assert (check (-128) (of_int64 128L));
  assert (Int64.equal (to_int64 one) 1L);
  assert (Int64.equal (to_int64 minus_one) (-1L));
  assert (Int64.equal (to_int64 max_int) 127L);
  assert (Int64.equal (to_int64 min_int) (-128L));
  ()

(* Asserting that of_nativeint/to_nativeint conversions work *)
let () =
  let open Signed.Int8 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 (of_nativeint 0n));
  assert (check 127 (of_nativeint 127n));
  assert (check (-128) (of_nativeint 128n));
  assert (Nativeint.equal (to_nativeint one) 1n);
  assert (Nativeint.equal (to_nativeint minus_one) (-1n));
  ()

(* --- Int16 tests --- *)

(* Asserting max and min integers are correct *)
let () =
  let open Signed.Int16 in
  assert (to_int max_int = 32767);
  assert (to_int min_int = (-32768));
  ()

(* Asserting that of_int truncates to 16 bits *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 zero);
  assert (check 1 one);
  assert (check (-1) minus_one);
  assert (check 32767 (of_int 32767));
  (* of_int truncates: 32768 wraps to -32768 in 16-bit signed *)
  assert (check (-32768) (of_int 32768));
  assert (check (-1) (of_int 65535));
  ()

(* Asserting that roundtrip int -> string -> int conversions survive *)
let () =
  let open Signed.Int16 in
  let check i =
    let str = to_string i in
    equal i (of_string str)
  in
  assert (check (of_int 0));
  assert (check (of_int 1));
  assert (check (of_int 32767));
  assert (check (of_int (-1)));
  assert (check (of_int (-32768)));
  ()

(* Asserting that addition performs as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 1 (add zero one));
  assert (check (-32768) (add max_int one));
  assert (check (-1) (add max_int (of_int 32768)));
  ()

(* Asserting that subtraction performs as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check (-1) (sub zero one));
  assert (check 32767 (sub min_int one));
  ()

(* Asserting that multiplication performs as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check (-1) (mul minus_one one));
  assert (check (-32768) (mul minus_one min_int));
  assert (check (-2) (mul max_int (of_int 2)));
  ()

(* Asserting that division and remainder perform as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 16383 (div max_int (of_int 2)));
  assert (check (-16384) (div min_int (of_int 2)));
  assert (check 1 (rem max_int (of_int 2)));
  assert (check 0 (rem min_int (of_int 2)));
  ()

(* Asserting that bitwise operations perform as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 (logand (of_int 0x00FF) (of_int 0x7F00)));
  assert (check 0x7FFF (logor (of_int 0x00FF) (of_int 0x7F00)));
  assert (check 0x7FFF (logxor (of_int 0x00FF) (of_int 0x7F00)));
  assert (check 0 (logxor max_int max_int));
  assert (check (-1) (lognot zero));
  assert (check 0 (lognot minus_one));
  ()

(* Asserting that shift operations perform as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 2 (shift_left one 1));
  assert (check (-32768) (shift_left one 15));
  assert (check (-1) (shift_right minus_one 1));
  assert (check 16383 (shift_right max_int 1));
  assert (check (-1) (shift_right_logical minus_one 0));
  assert (check 32767 (shift_right_logical minus_one 1));
  ()

(* Asserting that neg and abs perform as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check (-1) (neg one));
  assert (check 1 (neg minus_one));
  assert (check 1 (abs one));
  assert (check 1 (abs minus_one));
  assert (check 32767 (abs max_int));
  ()

(* Asserting that succ and pred perform as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 1 (succ zero));
  assert (check (-1) (pred zero));
  assert (check (-32768) (succ max_int));
  assert (check 32767 (pred min_int));
  ()

(* Asserting that compare and equal perform as expected *)
let () =
  let open Signed.Int16 in
  assert (equal zero zero);
  assert (equal max_int max_int);
  assert (not (equal zero one));
  assert (compare zero one < 0);
  assert (compare one zero > 0);
  assert (compare min_int max_int < 0);
  assert (Stdlib.( = ) (max zero one) one);
  assert (Stdlib.( = ) (min zero one) zero);
  ()

(* Asserting that integer parsing performs as expected *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 1 (of_string "1"));
  assert (check 32767 (of_string "32767"));
  assert (check (-32768) (of_string "-32768"));
  assert (try (ignore (of_string "32768"); false) with Failure _ -> true);
  assert (try (ignore (of_string "-32769"); false) with Failure _ -> true);
  assert (check (-1) (of_string "-1"));
  assert (check 0b01 (of_string "0b01"));
  assert (check (-0b01) (of_string "-0b01"));
  assert (check 0xff (of_string "0xff"));
  assert (check (-0xff) (of_string "-0xff"));
  assert (check 0x7fff (of_string "0x7fff"));
  assert (check (-0x8000) (of_string "-0x8000"));
  assert (try (ignore (of_string "0x8000"); false) with Failure _ -> true);
  assert (try (ignore (of_string "-0x8001"); false) with Failure _ -> true);
  assert (Signed.Int16.of_string_opt "32767" <> None);
  assert (Signed.Int16.of_string_opt "bad" = None);
  ()

(* Asserting that integer printing performs as expected *)
let () =
  let open Signed.Int16 in
  assert (to_string one = "1");
  assert (to_string (of_int 32767) = "32767");
  (* of_int truncates: 32768 wraps to -32768 in 16-bit signed *)
  assert (to_string (of_int 32768) = "-32768");
  assert (to_string (of_int (-32768)) = "-32768");
  assert (to_string (of_int (-1)) = "-1");
  (* hexstring prints unsigned two's complement representation *)
  assert (to_hexstring (of_int 0xff) = "ff");
  assert (to_hexstring max_int = "7fff");
  assert (to_hexstring min_int = "8000");
  assert (to_hexstring (of_int (-1)) = "ffff");
  ()

(* Asserting that of_int64/to_int64 conversions work *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 (of_int64 0L));
  assert (check 1 (of_int64 1L));
  assert (check 32767 (of_int64 32767L));
  assert (check (-32768) (of_int64 32768L));
  assert (Int64.equal (to_int64 one) 1L);
  assert (Int64.equal (to_int64 minus_one) (-1L));
  assert (Int64.equal (to_int64 max_int) 32767L);
  assert (Int64.equal (to_int64 min_int) (-32768L));
  ()

(* Asserting that of_nativeint/to_nativeint conversions work *)
let () =
  let open Signed.Int16 in
  let check expected res =
    Stdlib.( = ) expected (to_int res) in
  assert (check 0 (of_nativeint 0n));
  assert (check 32767 (of_nativeint 32767n));
  assert (check (-32768) (of_nativeint 32768n));
  assert (Nativeint.equal (to_nativeint one) 1n);
  assert (Nativeint.equal (to_nativeint minus_one) (-1n));
  ()

let () = print_endline "Small signed int operations test: ✓"
