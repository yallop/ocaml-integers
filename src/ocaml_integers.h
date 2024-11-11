/*
 * Copyright (c) 2013 Jeremy Yallop.
 *
 * This file is distributed under the terms of the MIT License.
 * See the file LICENSE for details.
 */

#ifndef INTEGERS_UNSIGNED_STUBS_H
#define INTEGERS_UNSIGNED_STUBS_H

#include <caml/mlvalues.h>

#include <stdint.h>

#ifndef OCAML_INTEGERS_INTERNAL
#ifdef __cplusplus
extern "C" {
#endif
CAMLextern value integers_copy_uint32(uint32_t u);
CAMLextern value integers_copy_uint64(uint64_t u);
#ifdef __cplusplus
}
#endif
#endif

#define Integers_val_uint8(t) ((Val_int((uint8_t)t)))
#define Integers_val_uint16(t) ((Val_int((uint16_t)t)))

#define Integers_val_int8(t) ((Val_int((int8_t)t)))
#define Integers_val_int16(t) ((Val_int((int16_t)t)))

#define Uint8_val(V) ((uint8_t)(Int_val(V)))
#define Uint16_val(V) ((uint16_t)(Int_val(V)))
#define Uint32_val(V) (*((uint32_t *) Data_custom_val(V)))
#define Uint64_val(V) (*((uint64_t *) Data_custom_val(V)))

#define Int8_val(V) ((int8_t)(Int_val(V)))
#define Int16_val(V) ((int16_t)(Int_val(V)))

static int parse_digit(char c)
{
  if (c >= '0' && c <= '9')
    return c - '0';
  else if (c >= 'A' && c <= 'F')
    return c - 'A' + 10;
  else if (c >= 'a' && c <= 'f')
    return c - 'a' + 10;
  else
    return -1;
}

#endif /* INTEGERS_UNSIGNED_STUBS_H */
