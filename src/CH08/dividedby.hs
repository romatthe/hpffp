module DividedBy where

data DividedResult = Result Integer
                   | DividedByZero
                   deriving (Show)

dividedBy :: Integral a => a -> a -> DividedResult
dividedBy num denom
  | num == 0                   = DividedByZero
  | signum denom == signum num = Result r
  | otherwise                  = Result (negate r)
  where
    r = go (abs num) (abs denom) 0
    go n d count
         | abs n < d = count
         | otherwise = go (n - d) d (count + 1)
