(*
 * copyright (c) 2006 Michael Niedermayer <michaelni@gmx.at>
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

(**
 * @file
 * memory handling functions
 *)

{$ifndef AVUTIL_MEM_H}
  {$define AVUTIL_MEM_H}


(**
 * Allocate a block of size bytes with alignment suitable for all
 * memory accesses (including vectors if available on the CPU).
 * @param size Size in bytes for the memory block to be allocated.
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_mallocz()
 *)
function av_malloc(size: cardinal): pointer;
  cdecl; external LIB_AVUTIL;

(**
 * Allocate a block of size * nmemb bytes with av_malloc().
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_malloc()
 *)

function av_malloc_array(nmemb: cardinal; size: cardinal): pointer; inline; // Note: see in avutil.pas

(**
 * Allocate or reallocate a block of memory.
 * If ptr is NULL and size > 0, allocate a new block. If
 * size is zero, free the memory block pointed to by ptr.
 * @param ptr Pointer to a memory block already allocated with
 * av_realloc() or NULL.
 * @param size Size in bytes of the memory block to be allocated or
 * reallocated.
 * @return Pointer to a newly-reallocated block or NULL if the block
 * cannot be reallocated or the function is used to free the memory block.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_realloc(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 * @see av_fast_realloc()
 *)
function av_realloc(ptr: pointer; size: cardinal): pointer;
  cdecl; external LIB_AVUTIL;

(**
 * Allocate or reallocate a block of memory.
 * This function does the same thing as av_realloc, except:
 * - It takes two arguments and checks the result of the multiplication for
 *   integer overflow.
 * - It frees the input block in case of failure, thus avoiding the memory
 *   leak with the classic "buf = realloc(buf); if (!buf) return -1;".
 *)
function av_realloc_f(ptr: pointer; nelem: cardinal; elsize: cardinal): pointer;
  cdecl; external LIB_AVUTIL;

(**
 * Allocate or reallocate a block of memory.
 * If *ptr is NULL and size > 0, allocate a new block. If
 * size is zero, free the memory block pointed to by ptr.
 * @param   ptr Pointer to a pointer to a memory block already allocated
 *          with av_realloc(), or pointer to a pointer to NULL.
 *          The pointer is updated on success, or freed on failure.
 * @param   size Size in bytes for the memory block to be allocated or
 *          reallocated
 * @return  Zero on success, an AVERROR error code on failure.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_reallocp(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 *)
function av_reallocp(ptr: pointer; elsize: cardinal): integer;
  cdecl; external LIB_AVUTIL;

(**
 * Allocate or reallocate an array.
 * If ptr is NULL and nmemb > 0, allocate a new block. If
 * nmemb is zero, free the memory block pointed to by ptr.
 * @param ptr Pointer to a memory block already allocated with
 * av_realloc() or NULL.
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to a newly-reallocated block or NULL if the block
 * cannot be reallocated or the function is used to free the memory block.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_realloc(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 *)
function av_realloc_array(ptr: pointer; nmemb, size: cardinal): pointer;
  cdecl; external LIB_AVUTIL;

(**
 * Allocate or reallocate an array through a pointer to a pointer.
 * If *ptr is NULL and nmemb > 0, allocate a new block. If
 * nmemb is zero, free the memory block pointed to by ptr.
 * @param ptr Pointer to a pointer to a memory block already allocated
 * with av_realloc(), or pointer to a pointer to NULL.
 * The pointer is updated on success, or freed on failure.
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Zero on success, an AVERROR error code on failure.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_realloc(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 *)
function av_reallocp_array(ptr: pointer; nmemb, size: cardinal): integer;
  cdecl; external LIB_AVUTIL;

(**
 * Free a memory block which has been allocated with av_malloc(z)() or
 * av_realloc().
 * @param ptr Pointer to the memory block which should be freed.
 * @note ptr = NULL is explicitly allowed.
 * @note It is recommended that you use av_freep() instead.
 * @see av_freep()
 *)
procedure av_free(ptr: pointer);
  cdecl; external LIB_AVUTIL;



(**
 * Allocate a block of size bytes with alignment suitable for all
 * memory accesses (including vectors if available on the CPU) and
 * zeroes all the bytes of the block.
 * @param size Size in bytes for the memory block to be allocated.
 * @return Pointer to the allocated block, NULL if it cannot be allocated.
 * @see av_malloc()
 *)
function av_mallocz(size: cardinal): pointer;
  cdecl; external LIB_AVUTIL;

(**
 * Allocate a block of nmemb * size bytes with alignment suitable for all
 * memory accesses (including vectors if available on the CPU) and
 * zero all the bytes of the block.
 * The allocation will fail if nmemb * size is greater than or equal
 * to INT_MAX.
 * @param nmemb
 * @param size
 * @return Pointer to the allocated block, NULL if it cannot be allocated.
 *)
function av_calloc(nmemb: cardinal; size: cardinal): pointer;
  cdecl; external LIB_AVUTIL; {av_malloc_attrib}

(**
 * Allocate a block of size * nmemb bytes with av_mallocz().
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_mallocz()
 * @see av_malloc_array()
 *)
function av_mallocz_array(nmemb: cardinal; size: cardinal): pointer; inline; // Note: see in avutil.pas

(**
 * Duplicate the string s.
 * @param s string to be duplicated.
 * @return Pointer to a newly-allocated string containing a
 * copy of s or NULL if the string cannot be allocated.
 *)
function av_strdup(s: PAnsiChar): PAnsiChar;
  cdecl; external LIB_AVUTIL;

(**
 * Duplicate the buffer p.
 * @param p buffer to be duplicated
 * @return Pointer to a newly allocated buffer containing a
 * copy of p or NULL if the buffer cannot be allocated.
 *)
function av_memdup(p: pointer; size: cardinal): pointer;
  cdecl; external LIB_AVUTIL;

(**
 * Free a memory block which has been allocated with av_malloc(z)() or
 * av_realloc() and set the pointer pointing to it to NULL.
 * @param ptr Pointer to the pointer to the memory block which should
 * be freed.
 * @see av_free()
 *)
procedure av_freep (ptr: pointer);
  cdecl; external LIB_AVUTIL;

(**
 * Add an element to a dynamic array.
 *
 * The array to grow is supposed to be an array of pointers to
 * structures, and the element to add must be a pointer to an already
 * allocated structure.
 *
 * The array is reallocated when its size reaches powers of 2.
 * Therefore, the amortized cost of adding an element is constant.
 *
 * In case of success, the pointer to the array is updated in order to
 * point to the new grown array, and the number pointed to by nb_ptr
 * is incremented.
 * In case of failure, the array is freed, *tab_ptr is set to NULL and
 * *nb_ptr is set to 0.
 *
 * @param tab_ptr pointer to the array to grow
 * @param nb_ptr  pointer to the number of elements in the array
 * @param elem    element to add
 * @see av_dynarray2_add()
 *)
procedure av_dynarray_add(tab_ptr: pointer; nb_ptr: PInteger; elem: pointer);
  cdecl; external LIB_AVUTIL;

(**
 * Add an element to a dynamic array.
 *
 * Function has the same functionality as av_dynarray_add(),
 * but it doesn't free memory on fails. It returns error code
 * instead and leave current buffer untouched.
 *
 * @param tab_ptr pointer to the array to grow
 * @param nb_ptr  pointer to the number of elements in the array
 * @param elem    element to add
 * @return >=0 on success, negative otherwise.
 * @see av_dynarray_add(), av_dynarray2_add()
 *)
function av_dynarray_add_nofree(tab_ptr: Pointer; nb_ptr: PInteger; elem: Pointer): integer;
  cdecl; external LIB_AVUTIL;

(**
 * Add an element of size elem_size to a dynamic array.
 *
 * The array is reallocated when its number of elements reaches powers of 2.
 * Therefore, the amortized cost of adding an element is constant.
 *
 * In case of success, the pointer to the array is updated in order to
 * point to the new grown array, and the number pointed to by nb_ptr
 * is incremented.
 * In case of failure, the array is freed, *tab_ptr is set to NULL and
 * *nb_ptr is set to 0.
 *
 * @param tab_ptr   pointer to the array to grow
 * @param nb_ptr    pointer to the number of elements in the array
 * @param elem_size size in bytes of the elements in the array
 * @param elem_data pointer to the data of the element to add. If NULL, the space of
 *                  the new added element is not filled.
 * @return          pointer to the data of the element to copy in the new allocated space.
 *                  If NULL, the new allocated space is left uninitialized."
 * @see av_dynarray_add()
 *)
function av_dynarray2_add(tab_ptr: Pointer; nb_ptr: PInteger; elem_size: cardinal;
                       elem_data: PByte): pointer;
  cdecl; external LIB_AVUTIL;

(**
 * Multiply two size_t values checking for overflow.
 * @return  0 if success, AVERROR(EINVAL) if overflow.
 *)
function av_size_mult(a: cardinal; b: cardinal; r: PCardinal): cardinal;
  cdecl; external LIB_AVUTIL;

(**
 * Set the maximum size that may me allocated in one block.
 *)
procedure av_max_alloc(max: cardinal);
  cdecl; external LIB_AVUTIL;

(**
 * deliberately overlapping memcpy implementation
 * @param dst destination buffer
 * @param back how many bytes back we start (the initial size of the overlapping window), must be > 0
 * @param cnt number of bytes to copy, must be >= 0
 *
 * cnt > back is valid, this will copy the bytes we just copied,
 * thus creating a repeating pattern with a period length of back.
 *)
procedure av_memcpy_backptr(dst: PByte; back: integer; cnt: integer);
  cdecl; external LIB_AVUTIL;

(**
 * Allocate a buffer, reusing the given one if large enough.
 *
 * Contrary to av_fast_realloc the current buffer contents might not be
 * preserved and on error the old buffer is freed, thus no special
 * handling to avoid memleaks is necessary.
 *
 * @param ptr pointer to pointer to already allocated buffer, overwritten with pointer to new buffer
 * @param size size of the buffer *ptr points to
 * @param min_size minimum size of *ptr buffer after returning, *ptr will be NULL and
 *                 *size 0 if an error occurred.
 *)
procedure av_fast_malloc(ptr: pointer; size: PCardinal; min_size: cardinal);
  cdecl; external LIB_AVUTIL;

{$endif} (* AVUTIL_MEM_H *)

