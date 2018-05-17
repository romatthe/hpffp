module Arith3Broken where

main :: IO()
main = do
  print (1 + 2)         -- Should be enclosed in brackets or use `$`
  print 10              -- Should use `print` or `putStrLn $ show 10`
  print (negate (-1))   -- Should enclose `-1` in brackets
  print ((+) 0 blah)
  where blah = negate 1
