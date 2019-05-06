#include "Rts.h"
#include "custom.h"

// Super simple function for getting the size of an array.
int get_size
  ( StgMutArrPtrs *arr
  ) {
  int res = (int)(arr->ptrs);
  return res;
}

// Iterate over all the ByteArray# elements in an ArrayArray#, folding
// the first int in each ByteArray# into a sum. The elements
// inside the ArrayArray# must be ByteArray# or MutableByteArray#,
// both of which are represented by StgArrBytes.
int sum_first
  ( StgMutArrPtrs *arr
  ) {
  StgClosure **bufsTmp = arr->payload;
  // In app/Main.hs, the sumFirst wrapper uses the type system
  // to help ensure that this unsafe cast is actually safe. In
  // runtime terminology, we are going from StgClosure to StgArrBytes.
  // In source haskell terminology, we are roughly going from
  // GHC.Exts.Any to ByteArray.
  StgArrBytes **bufs = (StgArrBytes**)bufsTmp;
  StgWord res = 0;
  int ix = ((int)(arr->ptrs)) - 1;
  for(;ix >= 0;ix--){
    res = res + ((int*)(bufs[ix]->payload))[0];
  }
  return res;
}
