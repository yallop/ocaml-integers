#if !__USE_MINGW_ANSI_STDIO && (defined(__MINGW32__) || defined(__MINGW64__))
#define __USE_MINGW_ANSI_STDIO 1
#endif

#include <caml/mlvalues.h>
#include <caml/custom.h>
#include <caml/alloc.h>
#include <caml/intext.h>
#include <caml/fail.h>

#include <inttypes.h>
#include <stdint.h>
#include <limits.h>
#include <stdio.h>

#define OCAML_INTEGERS_INTERNAL 1
#include "ocaml_integers.h"

CAMLprim value integers_int_size(value unit)
{
  return Val_long(8 * sizeof(value) - 1) ;
}

#define INT_SMALL_DECLS(BITS)                                               \
  /* of_string : string -> t */                                             \
  extern value integers_int ## BITS ## _of_string(value a);                 \
  /* to_string : t -> string */                                             \
  extern value integers_int ## BITS ## _to_string(value a);                 \
  /* max : unit -> t */                                                     \
  extern value integers_int ## BITS ## _max(value a);

INT_SMALL_DECLS(8)
INT_SMALL_DECLS(16)

#define TYPE(SIZE) int ## SIZE ## _t
#define UTYPE(SIZE) uint ## SIZE ## _t
#define BUF_SIZE(TYPE) ((sizeof(TYPE) * CHAR_BIT + 2) / 3 + 2)

#define INT_OF_STRING(BITS, COPY)                                            \
  value integers_int ## BITS ## _of_string(value a)                          \
  {                                                                          \
    TYPE(BITS) i, max_prefix;                                                \
    const char *pos = String_val(a);                                         \
    int base = 10, d, sign = 1, signedness = 1;                              \
                                                                             \
    /* Detect sign, if given */                                              \
    if (*pos == '-') {                                                       \
       sign = -1;                                                            \
      pos++;                                                                 \
    } else if (*pos == '+') {                                                \
      pos++;                                                                 \
    }                                                                        \
    if (*pos == '0') {                                                       \
      switch (pos[1]) {                                                      \
        case 'x': case 'X':                                                  \
          base = 16; pos += 2; break;                                        \
        case 'o': case 'O':                                                  \
          base = 8; pos += 2; break;                                         \
        case 'b': case 'B':                                                  \
          base = 2; pos += 2; break;                                         \
        case 'u': case 'U': /* Unsigned prefix. No-op for unsigned types */  \
          signedness = 0; pos += 2; break;                                   \
      }                                                                      \
    }                                                                        \
                                                                             \
    max_prefix = ((UTYPE(BITS)) -1) / base;                                  \
                                                                             \
    d = parse_digit(*pos);                                                   \
    if (d < 0 || d >= base) {                                                \
      caml_failwith("Int"#BITS".of_string");                                 \
    }                                                                        \
    i = sign < 0 ? (TYPE(BITS)) (- d) : (TYPE(BITS)) d;                      \
    pos++;                                                                   \
                                                                             \
    for (;; pos++) {                                                         \
      if (*pos == '_') continue;                                             \
      d = parse_digit(*pos);                                                 \
      /* Halt if the digit isn't valid (or this is the string terminator) */ \
      if (d < 0 || d >= base) break;                                         \
      /* Check that we can add another digit */                              \
      if (i > max_prefix) break;                                             \
      i = (sign < 0 ? (- d) : d) + i * base;                                 \
      /* Check for overflow */                                               \
      if (sign < 0) {                                                        \
        if (i > ((TYPE(BITS)) (- d))) break;                                 \
      } else {                                                               \
        if (i < (TYPE(BITS)) d) break;                                       \
      }                                                                      \
    }                                                                        \
                                                                             \
    if (pos != String_val(a) + caml_string_length(a)){                       \
      caml_failwith("Int"#BITS".of_string");                                 \
    }                                                                        \
                                                                             \
    return COPY(i);                                                          \
  }                                                                          \

#define INT_SMALL_DEFS(BITS)                                                 \
  /* of_string : string -> t */                                              \
  INT_OF_STRING(BITS, Integers_val_int ## BITS)                              \
                                                                             \
  /* to_string : t -> string */                                              \
  value integers_int ## BITS ## _to_string(value a)                          \
  {                                                                          \
    char buf[BUF_SIZE(TYPE(BITS))];                                          \
    if (sprintf(buf, "%" PRId ## BITS , Int ## BITS ##_val(a)) < 0)          \
      caml_failwith("Int ## BITS ## .to_string");                            \
    else                                                                     \
      return caml_copy_string(buf);                                          \
  }                                                                          \
                                                                             \
  /* to_hexstring : t -> string */                                           \
  value integers_int ## BITS ## _to_hexstring(value a)                       \
  {                                                                          \
    char buf[BUF_SIZE(TYPE(BITS))];                                          \
    char* c = buf;                                                           \
    /* Use intnat in case d is MIN_INT(BITS) */                              \
    intnat d = Int_val(a);                                                   \
    if (d < 0) {                                                             \
      *c = '-';                                                              \
      c++;                                                                   \
      d = (- d);                                                             \
    }                                                                        \
    if (sprintf(c, "%" PRIx ## BITS , (TYPE(BITS)) d) < 0)                   \
      caml_failwith("Int ## BITS ## .to_hexstring");                         \
    else                                                                     \
      return caml_copy_string(buf);                                          \
  }                                                                          \
                                                                             \
  /* max : unit -> t */                                                      \
  value integers_int ## BITS ## _max(value unit)                             \
  {                                                                          \
    return Integers_val_int ## BITS(~(1 << (BITS - 1)));                     \
  }                                                                          \
                                                                             \
  /* min : unit -> t */                                                      \
  value integers_int ## BITS ## _min(value unit)                             \
  {                                                                          \
    return Integers_val_int ## BITS((- 1) << (BITS - 1));                    \
  }

INT_SMALL_DEFS(8)
INT_SMALL_DEFS(16)
