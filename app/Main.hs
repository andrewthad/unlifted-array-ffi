{-# language UnliftedFFITypes #-}
{-# language MagicHash #-}

module Main where

import Data.Primitive
import Foreign.C.Types
import Control.Monad (when)
import GHC.Exts (ArrayArray#)

main :: IO ()
main = do
  marr <- unsafeNewUnliftedArray 3
  writeUnliftedArray marr 0 =<< newFilledPrimArray 4 23
  writeUnliftedArray marr 1 =<< newFilledPrimArray 5 19
  writeUnliftedArray marr 2 =<< newFilledPrimArray 6 44
  arr <- unsafeFreezeUnliftedArray marr
  sz <- getSize arr
  when (sz /= 3) (fail ("bad size " ++ show sz))
  n <- sumFirst arr
  when (n /= 23 + 19 + 44) (fail ("Failure (" ++ show n ++ ")"))
  putStrLn "Success"

foreign import ccall unsafe "custom.h sum_first"
  c_sum_first :: ArrayArray# -> IO CInt

foreign import ccall unsafe "custom.h get_size"
  c_get_size :: ArrayArray# -> IO CInt

getSize :: UnliftedArray (PrimArray CInt) -> IO CInt
getSize (UnliftedArray arr) = c_get_size arr

sumFirst :: UnliftedArray (PrimArray CInt) -> IO CInt
sumFirst (UnliftedArray arr) = c_sum_first arr

-- All elements in the tail of the array are assigned to be
-- the maximum value of CInt. 
newFilledPrimArray ::
     Int -- number of elements
  -> CInt -- value of head element
  -> IO (PrimArray CInt)
newFilledPrimArray n h = do
  m <- newPrimArray n
  setPrimArray m 0 n (maxBound :: CInt)
  writePrimArray m 0 h
  unsafeFreezePrimArray m
