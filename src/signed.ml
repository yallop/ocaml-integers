(*
 * Copyright (c) 2013 Jeremy Yallop.
 * Copyright (c) 2021 Nomadic Labs
 *
 * This file is distributed under the terms of the MIT License.
 * See the file LICENSE for details.
 *)

external int_size' : unit -> int = "integers_int_size"
let int_size = int_size' ()

module type Infix = sig
  type t
  include Unsigned.Infix with type t := t
  val (asr) : t -> int -> t
end

module type S = sig
  type t

  module Infix : Infix with type t := t

  include Unsigned.S with type t := t
                     with module Infix := Infix

  val neg : t -> t
  val abs : t -> t
  val minus_one : t
  val min_int : t
  val shift_right_logical : t -> int -> t
  val of_nativeint : nativeint -> t
  val to_nativeint : t -> nativeint
  val of_int64 : int64 -> t
  val to_int64 : t -> int64
end

module type Basics = sig
  type t
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val div : t -> t -> t
  val rem : t -> t -> t
  val logand : t -> t -> t
  val logor : t -> t -> t
  val logxor : t -> t -> t
  val shift_left : t -> int -> t
  val shift_right : t -> int -> t
  val shift_right_logical : t -> int -> t
end

module MakeInfix(S : Basics) =
struct
  open S
  let (+) = add
  let (-) = sub
  let ( * ) = mul
  let (/) = div
  let (mod) = rem
  let (land) = logand
  let (lor) = logor
  let (lxor) = logxor
  let (lsl) = shift_left
  let (lsr) = shift_right_logical
  let (asr) = shift_right
end

module type Small = sig
  val bits : int

  val min : unit -> int
  val max : unit -> int
  val of_string : string -> int
  val to_string : int -> string
  val to_hexstring : int -> string
end

module MakeSmall(S : Small) =
struct
  open S

  let fix i = (i lsl (int_size - bits)) asr (int_size - bits)

  module Basics =
  struct
    type t = int
    external to_int : t -> int = "%identity"
    let min_int = S.min ()
    let max_int = S.max ()
    let of_string = of_string
    let to_string = to_string
    let to_hexstring = to_hexstring

    let add : t -> t -> t = fun x y -> fix (x + y)
    let sub : t -> t -> t = fun x y -> fix (x - y)
    let mul : t -> t -> t = fun x y -> fix (x * y)
    let div : t -> t -> t = ( / )
    let rem : t -> t -> t = ( mod )
    let logand : t -> t -> t = ( land )
    let logor : t -> t -> t = ( lor )
    let logxor : t -> t -> t = ( lxor )
    let shift_left : t -> int -> t = fun x y -> fix (x lsl y)
    let shift_right : t -> int -> t = ( asr )
    let shift_right_logical : t -> int -> t = fun x y ->
      ((x lsl (int_size - bits)) lsr y) asr (int_size - bits)
    let of_int : int -> t = fix
    let of_string_opt s = try Some (of_string s) with Failure _ -> None
    let zero = 0
    let one = 1
    let minus_one = -1
    let lognot = lnot
    let succ : t -> t = fun x -> fix (Stdlib.succ x)
    let pred : t -> t = fun x -> fix (Stdlib.pred x)
    let compare : t -> t -> int = Stdlib.compare
    let equal : t -> t -> bool = Stdlib.( = )
    let min : t -> t -> t = Stdlib.min
    let max : t -> t -> t = Stdlib.max
  end
  include Basics
  module Infix = MakeInfix(Basics)
  let pp fmt x = Format.fprintf fmt "%s" (to_string x)
  let pp_hex fmt x = Format.fprintf fmt "%s" (to_hexstring x)
  let neg = fun x -> fix (- x)
  let abs = fun x -> fix (abs x)
  let of_int64 = fun x -> fix (Int64.to_int x)
  let to_int64 = Int64.of_int
  let of_nativeint = fun x -> fix (Nativeint.to_int x)
  let to_nativeint = Nativeint.of_int
end

external format_int : string -> int -> string = "caml_format_int"

module Int8 = MakeSmall(
struct
  let bits = 8

  external of_string : string -> int = "integers_int8_of_string"
  external to_string : int -> string = "integers_int8_to_string"
  external to_hexstring : int -> string = "integers_int8_to_hexstring"
  external max : unit -> int = "integers_int8_max"
  external min : unit -> int = "integers_int8_min"
end)

module Int16 = MakeSmall(
struct
  let bits = 16

  external of_string : string -> int = "integers_int16_of_string"
  external to_string : int -> string = "integers_int16_to_string"
  external to_hexstring : int -> string = "integers_int16_to_hexstring"
  external max : unit -> int = "integers_int16_max"
  external min : unit -> int = "integers_int16_min"
end)

module Int =
struct
  module Basics =
  struct
    type t = int
    let add = ( + )
    let sub = ( - )
    let mul = ( * )
    let div = ( / )
    let rem = ( mod )
    let max_int = Stdlib.max_int
    let min_int = Stdlib.min_int
    let logand = ( land )
    let logor = ( lor )
    let logxor = ( lxor )
    let shift_left = ( lsl )
    let shift_right = ( asr )
    let shift_right_logical = ( lsr )
    let of_int x = x
    let to_int x = x
    let of_string = int_of_string
    let of_string_opt s = try Some (of_string s) with Failure _ -> None
    let to_string = string_of_int
    let to_hexstring = format_int "%x"
    let zero = 0
    let one = 1
    let minus_one = -1
    let lognot = lnot
    let succ = Stdlib.succ
    let pred = Stdlib.pred
    let compare = Stdlib.compare
    let equal = Stdlib.(=)
    let max = Stdlib.max
    let min = Stdlib.min
  end
  include Basics
  module Infix = MakeInfix(Basics)
  let to_int64 = Int64.of_int
  let of_int64 = Int64.to_int
  let to_nativeint = Nativeint.of_int
  let of_nativeint = Nativeint.to_int
  let abs = Stdlib.abs
  let neg x = -x
  let pp fmt n = Format.fprintf fmt "%d" n
  let pp_hex fmt n = Format.fprintf fmt "%x" n
end

module Int32 = 
struct
  [@@@ocaml.warning "-32"]
  (* Int32.equal was introduced in OCaml 4.03.0 *)
  let equal  (x:int32) (y:int32) = x = y
  (* Int32.of_string_opt was introduced in OCaml 4.5b0.0 *)
  let of_string_opt s = try Some (Int32.of_string s) with Failure _ -> None
  include Int32
  module Infix = MakeInfix(Int32)
  let of_nativeint = Nativeint.to_int32
  let to_nativeint = Nativeint.of_int32
  let of_int64 = Int64.to_int32
  let to_int64 = Int64.of_int32
  let max = Stdlib.max
  let min = Stdlib.min
  let pp fmt n = Format.fprintf fmt "%ld" n
  let pp_hex fmt n = Format.fprintf fmt "%lx" n
  let to_hexstring n = Format.asprintf "%lx" n
end

module Int64 = 
struct
  [@@@ocaml.warning "-32"]
  (* Int64.equal was introduced in OCaml 4.03.0 *)
  let equal (x:int64) (y:int64) = x = y
  (* Int32.of_string_opt was introduced in OCaml 4.5b0.0 *)
  let of_string_opt s = try Some (Int64.of_string s) with Failure _ -> None
  include Int64
  module Infix = MakeInfix(Int64)
  let of_int64 x = x
  let to_int64 x = x
  let max = Stdlib.max
  let min = Stdlib.min
  let pp fmt n = Format.fprintf fmt "%Ld" n
  let pp_hex fmt n = Format.fprintf fmt "%Lx" n
  let to_hexstring n = Format.asprintf "%Lx" n
end

(* C guarantees that sizeof(t) == sizeof(unsigned t) *)
external int_size : unit -> int = "integers_uint_size"
external long_size : unit -> int = "integers_ulong_size"
external llong_size : unit -> int = "integers_ulonglong_size"

let of_byte_size : int -> (module S) = function
  | 4 -> (module Int32)
  | 8 -> (module Int64)
  | _ -> invalid_arg "Signed.of_byte_size"

module SInt = (val of_byte_size (int_size ()))
module Long = (val of_byte_size (long_size ()))
module LLong = (val of_byte_size (llong_size ()))

type sint = SInt.t
type long = Long.t
type llong = LLong.t
