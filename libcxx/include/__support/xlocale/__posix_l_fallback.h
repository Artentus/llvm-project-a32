// -*- C++ -*-
//===-----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
// These are reimplementations of some extended locale functions ( *_l ) that
// are normally part of POSIX.  This shared implementation provides parts of the
// extended locale support for libc's that normally don't have any (like
// Android's bionic and Newlib).
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP_SUPPORT_XLOCALE_POSIX_L_FALLBACK_H
#define _LIBCPP_SUPPORT_XLOCALE_POSIX_L_FALLBACK_H

#ifdef __cplusplus
extern "C" {
#endif

inline _LIBCPP_INLINE_VISIBILITY int isalnum_l(int __c, locale_t) {
  return ::isalnum(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isalpha_l(int __c, locale_t) {
  return ::isalpha(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isblank_l(int __c, locale_t) {
  return ::isblank(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iscntrl_l(int __c, locale_t) {
  return ::iscntrl(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isdigit_l(int __c, locale_t) {
  return ::isdigit(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isgraph_l(int __c, locale_t) {
  return ::isgraph(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int islower_l(int __c, locale_t) {
  return ::islower(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isprint_l(int __c, locale_t) {
  return ::isprint(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int ispunct_l(int __c, locale_t) {
  return ::ispunct(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isspace_l(int __c, locale_t) {
  return ::isspace(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isupper_l(int __c, locale_t) {
  return ::isupper(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int isxdigit_l(int __c, locale_t) {
  return ::isxdigit(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswalnum_l(wint_t __c, locale_t) {
  return ::iswalnum(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswalpha_l(wint_t __c, locale_t) {
  return ::iswalpha(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswblank_l(wint_t __c, locale_t) {
  return ::iswblank(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswcntrl_l(wint_t __c, locale_t) {
  return ::iswcntrl(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswdigit_l(wint_t __c, locale_t) {
  return ::iswdigit(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswgraph_l(wint_t __c, locale_t) {
  return ::iswgraph(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswlower_l(wint_t __c, locale_t) {
  return ::iswlower(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswprint_l(wint_t __c, locale_t) {
  return ::iswprint(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswpunct_l(wint_t __c, locale_t) {
  return ::iswpunct(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswspace_l(wint_t __c, locale_t) {
  return ::iswspace(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswupper_l(wint_t __c, locale_t) {
  return ::iswupper(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int iswxdigit_l(wint_t __c, locale_t) {
  return ::iswxdigit(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int toupper_l(int __c, locale_t) {
  return ::toupper(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int tolower_l(int __c, locale_t) {
  return ::tolower(__c);
}

inline _LIBCPP_INLINE_VISIBILITY wint_t towupper_l(wint_t __c, locale_t) {
  return ::towupper(__c);
}

inline _LIBCPP_INLINE_VISIBILITY wint_t towlower_l(wint_t __c, locale_t) {
  return ::towlower(__c);
}

inline _LIBCPP_INLINE_VISIBILITY int strcoll_l(const char *__s1, const char *__s2,
                                               locale_t) {
  return ::strcoll(__s1, __s2);
}

inline _LIBCPP_INLINE_VISIBILITY size_t strxfrm_l(char *__dest, const char *__src,
                                                  size_t __n, locale_t) {
  return ::strxfrm(__dest, __src, __n);
}

inline _LIBCPP_INLINE_VISIBILITY size_t strftime_l(char *__s, size_t __max,
                                                   const char *__format,
                                                   const struct tm *__tm, locale_t) {
  return ::strftime(__s, __max, __format, __tm);
}

inline _LIBCPP_INLINE_VISIBILITY int wcscoll_l(const wchar_t *__ws1,
                                               const wchar_t *__ws2, locale_t) {
  return ::wcscoll(__ws1, __ws2);
}

inline _LIBCPP_INLINE_VISIBILITY size_t wcsxfrm_l(wchar_t *__dest, const wchar_t *__src,
                                                  size_t __n, locale_t) {
  return ::wcsxfrm(__dest, __src, __n);
}

#ifdef __cplusplus
}
#endif

#endif // _LIBCPP_SUPPORT_XLOCALE_POSIX_L_FALLBACK_H
