module SumAll where

sumAll :: (Eq a, Num a) => a -> a
sumAll x
       | x == 1    = x
       | otherwise = x + sumAll (x - 1)
