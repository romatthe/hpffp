module Write1 where

-- Original
tensDigit :: Integral a => a -> a
tensDigit x = d
  where
    xLast = x `div` 10
    d = xLast `mod` 10

-- Rewrite
tensDigit' :: Integral a => a -> a
tensDigit' = snd . (`divMod` 10)

-- Hundreds digit
hundredsDigit :: Integral a => a -> a
hundredsDigit = divTen . (`div` 10)
  where divTen = snd . (`divMod` 10)

-- Or, making use of the previously defined `tensDigit`
hundredsDigit' :: Integral a => a -> a
hundredsDigit' = tensDigit . (`div` 10)
