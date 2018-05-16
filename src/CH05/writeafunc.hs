module WriteAFunc where

i :: a -> a
i x = x

c :: a -> b -> a
c x y = x

c'' :: b -> a -> b
c'' x y = x         -- c and c'' are the same

c' :: a -> b -> b
c' x y = y

r :: [a] -> [a]
r xs = xs

r' :: [a] -> [a] -- Another example of the above
r' = reverse

co :: (b -> c) -> (a -> b) -> a -> c
co x y z = (x . y) z

a :: (a -> c) -> a -> a
a _ y = y

a' :: (a -> b) -> a -> b
a' x y = x y
