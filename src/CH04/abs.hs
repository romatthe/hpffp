module Absolute where

myAbs :: Int -> Int
myAbs x =
  if x < 0
     then x * (-1)
     else x
