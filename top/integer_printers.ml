(*
 * Copyright (c) 2013 Jeremy Yallop.
 *
 * This file is distributed under the terms of the MIT License.
 * See the file LICENSE for details.
 *)

let format_sint fmt v =
  Format.fprintf fmt "<sint %s>" (Integers.Signed.SInt.to_string v)
let format_long fmt v =
  Format.fprintf fmt "<long %s>" (Integers.Signed.Long.to_string v)
let format_llong fmt v =
  Format.fprintf fmt "<llong %s>" (Integers.Signed.LLong.to_string v)
let format_uchar fmt v =
  Format.fprintf fmt "<uchar %s>" (Integers.Unsigned.UChar.to_string v)
let format_uint8 fmt v =
  Format.fprintf fmt "<uint8 %s>" (Integers.Unsigned.UInt8.to_string v)
let format_uint16 fmt v =
  Format.fprintf fmt "<uint16 %s>" (Integers.Unsigned.UInt16.to_string v)
let format_uint32 fmt v =
  Format.fprintf fmt "<uint32 %s>" (Integers.Unsigned.UInt32.to_string v)
let format_uint64 fmt v =
  Format.fprintf fmt "<uint64 %s>" (Integers.Unsigned.UInt64.to_string v)
let format_ushort fmt v =
  Format.fprintf fmt "<ushort %s>" (Integers.Unsigned.UShort.to_string v)
let format_uint fmt v =
  Format.fprintf fmt "<uint %s>" (Integers.Unsigned.UInt.to_string v)
let format_ulong fmt v =
  Format.fprintf fmt "<ulong %s>" (Integers.Unsigned.ULong.to_string v)
let format_ullong fmt v =
  Format.fprintf fmt "<ullong %s>" (Integers.Unsigned.ULLong.to_string v)
