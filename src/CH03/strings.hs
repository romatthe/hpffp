module Strings where

addBang :: String -> String
addBang x = x ++ "!"

takeFourth :: String -> String
takeFourth x = [x !! 4]

lastWord :: String -> String
lastWord x = last $ words x
