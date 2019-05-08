# unlifted-array-ffi

This repository is a demonstration of how to use the `UnliftedFFITypes`
extension to pass `ArrayArray#` to the FFI. This only works with the
`unsafe` FFI because the `unsafe` FFI provides the guarantee that the
garbage collector cannot run during the call. (If the garbage collector
ran, it could relocate something that the `UnliftedArray#` pointed to,
which would lead to corruption).

This repository showcases two C functions: `get_size` and `sum_first`.
They are written in `cbits/custom.c`. In `app/Main.hs`, there are
FFI calls and additional wrappers that marshal from the unlifted
`ArrayArray#` to the lifted `UnliftedArray`. The module includes
a main function that can be used to verify that the functions
actually behave as expected.

Keep in mind that although a foreign function can inspect the
elements of an `ArrayArray#`, it cannot inspect the elements of
an `Array#`. Functions written in C have no way of dealing
with thunks, and values in `Array#` can be thunks. Crucially,
the values in `ArrayArray#` cannot be thunks since types of
kind `TYPE 'UnliftedRep` are never thunks. A foreign function
working on an `Array#` could perform operations like permutation
that do not require dereferencing the pointers in its payload.

Additional Reading:

* [Reddit disucssion of this repository](https://www.reddit.com/r/haskell/comments/bld8kx/demonstration_of_how_to_use_unliftedarray_with/).
* [Merge request to document `UnliftedFFITypes`](https://gitlab.haskell.org/ghc/ghc/merge_requests/900).
  This has some insightful thoughts from David Feuer on using
  arrays in foreign functions.
* [Andras Kovacs's `array-primops` library](https://github.com/AndrasKovacs/array-primops).
