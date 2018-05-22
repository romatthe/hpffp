module Mult where

mult :: (Integral a) => a -> a -> a
mult num mul = go num mul 0
  where go numbr mul count
         | count == (mul - 1) = numbr
         | otherwise          = go (numbr + num) mul (count + 1)
