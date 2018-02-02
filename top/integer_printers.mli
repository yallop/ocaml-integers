(*
 * Copyright (c) 2013 Jeremy Yallop.
 *
 * This file is distributed under the terms of the MIT License.
 * See the file LICENSE for details.
 *)

open Format

val format_sint : formatter -> Integers.Signed.SInt.t -> unit
val format_long : formatter -> Integers.Signed.Long.t -> unit
val format_llong : formatter -> Integers.Signed.LLong.t -> unit
val format_uchar : formatter -> Integers.Unsigned.UChar.t -> unit
val format_uint8 : formatter -> Integers.Unsigned.UInt8.t -> unit
val format_uint16 : formatter -> Integers.Unsigned.UInt16.t -> unit
val format_uint32 : formatter -> Integers.Unsigned.UInt32.t -> unit
val format_uint64 : formatter -> Integers.Unsigned.UInt64.t -> unit
val format_ushort : formatter -> Integers.Unsigned.UShort.t -> unit
val format_uint : formatter -> Integers.Unsigned.UInt.t -> unit
val format_ulong : formatter -> Integers.Unsigned.ULong.t -> unit
val format_ullong : formatter -> Integers.Unsigned.ULLong.t -> unit
