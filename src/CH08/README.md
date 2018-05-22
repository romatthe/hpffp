
# Notes

## Recursion

Recursion is defining a function in terms of itself via self-referential expressions.  

Classic example - factorial:  

```haskell
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

Another classic example - fibonacci numbers:  

```haskell
fibonacci :: Integral a => a -> a
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci x =
  fibonacci (x - 1) + fibonacci (x - 2)  
```

## Bottom

⊥ or bottom is a term used in Haskell to refer to computations that do not successfully result in a value.  
The two main varieties of bottom are computations that failed with an error or those that failed to terminate.  
In logic, ⊥ corresponds to false.  

For example:  

```haskell
Prelude> let x = x in x
  Exception: <<loop>>
```

# Exercises

## Exercise 1: Intermissions

```haskell
applyTimes 5 (+1) 5
(+1) $ applyTimes 4 (+1) 5
(+1) $ (+1) $ applyTimes 3 (+1) 5
(+1) $ (+1) $ (+1) $ applyTimes 2 (+1) 5
(+1) $ (+1) $ (+1) $ (+1) $ applyTimes 1 (+1) 5
(+1) $ (+1) $ (+1) $ (+1) $ (+1) $ 5
(+1) . (+1) . (+1) . (+1) . (+1) $ 5
```

## Exercise 2: Chapter Summary

### Review of Types

1.  What is the type of `[[True, False], [True, True], [False, True]]`?  
    Answer: d) `[[Bool]]`

2.  Which of the following has the same type as `[[True, False], [True, True], [False, True]]`?  
    Answer: b) `[[3 == 3], [6 > 5], [3 < 4]]`

3.  For following function, what is true?  
    
    ```haskell
    func :: [a] -> [a] -> [a]
    func x y = x ++ y
    ```
    
    Answer: d) All of the above

4.  Answer: b) `func "Hello" "World"`

### Reviewing Currying

1.  "woops mrow woohoo!"

2.  "1 mrow haha"

3.  "woops mrow 2 haha"

4.  "woops mrow blue mrow haha"

5.  "pink mrow haha mrow green mrow woops mrow blue"

6.  "are mrow Pugs mrow awesome"

### Recursion

1.  dividedBy 15 2  
    
    ```haskell
    = go 15 2 0
    = go 13 2 1
    = go 11 2 2
    = go  9 2 3
    = go  7 2 4
    = go  5 2 5
    = go  3 2 6
    = go  1 2 7
    = (7, 1)
    ```

2.  `sumAll` function:  
    
    ```haskell
    module SumAll where
    
    sumAll :: (Eq a, Num a) => a -> a
    sumAll x
           | x == 1    = x
           | otherwise = x + sumAll (x - 1)
    ```

3.  Recursive Sum:  
    
    ```haskell
    module Mult where
    
    mult :: (Integral a) => a -> a -> a
    mult num mul = go num mul 0
      where go numbr mul count
             | count == (mul - 1) = numbr
             | otherwise          = go (numbr + num) mul (count + 1)
    ```

### Fixing DividedBy

```haskell
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
```

### McCarthy 91 Function

```haskell
module McCarthy where

mac :: Integral a => a -> a
mac n
    | n > 100   = n - 10
    | otherwise = mac . mac $ n + 11
```

### Numbers Into Words

```haskel
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
```
