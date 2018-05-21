module Write2 where

-- Pattern matching version
foldBool3 :: a -> a -> Bool -> a
foldBool3 x _ False = x
foldBool3 _ y True = y

-- Case version
foldBool' :: a -> a -> Bool -> a
foldBool' x y bool =
  case bool of
    True -> y
    False -> x

-- Guard version
foldBool'' :: a -> a -> Bool -> a
foldBool'' x y bool
  | bool     = y
  | not bool = x
