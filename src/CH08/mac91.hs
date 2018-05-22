module McCarthy where

mac :: Integral a => a -> a
mac n
    | n > 100   = n - 10
    | otherwise = mac . mac $ n + 11
