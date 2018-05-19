module TypeKwonDo where

chk :: Eq b => (a -> b) -> a -> b -> Bool
chk func x y = func x == y

arith :: Num b => (a -> b) -> Integer -> a -> b
arith func x y = func y
