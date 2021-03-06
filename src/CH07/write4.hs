module Write4 where

roundTrip :: (Show a, Read a) => a -> a
roundTrip a = read (show a)

-- Pointfree defintion
roundTrip' :: (Show a, Read a) => a -> a
roundTrip' = read . show

-- New type signature
roundTrip'' :: (Show a, Read b) => a -> b
roundTrip'' = read . show

main = do
  --print (roundTrip 4)
  --print (roundTrip' 4)
  print (roundTrip'' 4 :: Integer)
  print (id 4)
