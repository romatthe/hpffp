module DividedBy where

data DividedResult = Result Integer
                   | DividedByZero
                   deriving (Show)

dividedBy :: Integral a => a -> a -> DividedResult
dividedBy numbr denom
  | numbr == 0                   = DividedByZero
  | signum denom == signum numbr = Result r
  | otherwise                    = Result (negate r)
  where
    r = go (abs numbr) (abs denom) 0
    go n d count
         | abs n < d = count
         | otherwise = go (n - d) d (count + 1)
