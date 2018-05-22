module WordNumber where

import Data.List (intercalate)

digitToWord :: Int -> String
digitToWord 0 = "zero"
digitToWord 1 = "one"
digitToWord 2 = "two"
digitToWord 3 = "three"
digitToWord 4 = "four"
digitToWord 5 = "five"
digitToWord 6 = "six"
digitToWord 7 = "seven"
digitToWord 8 = "eight"
digitToWord 9 = "nine"
digitToWord _ = error "This function only takes a single digit `Int`"

digits :: Int -> [Int]
digits n = map (read . (:[])) (show n) -- `:[]` is of type a -> [a], here it does Char -> [Char]

wordNumber :: Int -> String
wordNumber n = intercalate "-" $ map digitToWord  $ digits n
