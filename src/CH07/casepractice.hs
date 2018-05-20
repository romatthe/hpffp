module CasePractice where

-- Exercise 1
functionC x y = if (x > y) then x else y

functionC' x y =
  case greater x y of
    True -> x
    False -> y
  where greater x y = x > y

-- Exercise 2
ifEvenAdd2 n = if even n then (n + 2) else n

ifEvenAdd2' n =
  case even n of
    True -> n + 2
    False -> n

-- Exercise 3
nums x =
  case compare x 0 of
    LT -> -1
    GT -> 1
    EQ -> 0
