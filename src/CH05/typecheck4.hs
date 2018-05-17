module TypeCheck4 where

munge :: (x -> y) -> (y -> (w, z)) -> x -> w
munge fx fy x = fst $ (fy . fx) x
