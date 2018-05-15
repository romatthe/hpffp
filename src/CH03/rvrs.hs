module Rvrs where


rvrs :: String -> String
rvrs x = awesome ++ " " ++ is ++ " " ++ curry
    where
      awesome = drop 9 x
      is = take 2 $ drop 6 x
      curry = take 5 x
