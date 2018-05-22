module DividedBy where

data DividedResult = Result Integer
                   | DividedByZero

dividedBy :: Integral a => a -> a -> DividedResult
dividedBy numbr denom
  | numbr == 0           = DividedByZero
  | sigdenom == signumbr = Result r
  | otherwise            = Result (negate r)
  where
    sigdenom = signum denom
    signumbr = signum numbr
    r = go (abs numbr) (abs denom) 0
    go n d count
         | abs n < d = count
         | otherwise = go (n - d) d (count + 1)
