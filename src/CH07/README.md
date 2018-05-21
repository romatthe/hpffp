
# Notes

## Shadowing

We can **shadow** arguments of a function like this:  

```haskell
bindExp :: Integer -> String
bindExp x =
  let x = 10; y = 5 in
    "the integer was: " ++ show x
    ++ " and y was: " ++ show y

Prelude> bindExp 9001
"the integer was: 10 and y was: 5"
```

The definition of x that is innermost in the code (where the function name at the left margin is the outside) takes precedence because Haskell is lexically scoped.  
Lexical scoping means that resolving the value for a named entity depends on the location in the code and tOld Newshe lexical context, for example in let and where clauses.  

```haskell
bindExp :: Integer -> String
bindExp x = let x = 10
--     [1]     [2]
                y = 5
            in "x: " ++ show x
--                          [3]
            ++ " y: " ++ show y
```

1.  The parameter x introduced in the definition of bindExp. This gets shadowed by the x in [2].
2.  This is a let-binding of x and shadows the definition of x introduced as an argument at [1].
3.  A use of the x bound by [2]. Given Haskell’s static (lexical) scoping it will always refer to the x defined as x = 10 in the let binding!

## Anonymous Functions:

Haskell allows for succint anonymous function syntax, e.g:  

```haskell
-- Traditional notation:
triple :: Integer -> Integer
triple x = x * 3

-- Anonymous function syntax:
(\x -> x * 3) :: Integer -> Integer
```

## Pattern Matching

Pattern matching is a way of matching values against patterns and, where appropriate, binding variables to successful matches.  
It is worth noting here that patterns can include things as diverse as undefined variables, numeric literals, and list syntax.  
As we will see, pattern matching matches on any and all data constructors.  

Example, pattern matching on numbers:  

```haskell
isItTwo :: Integer -> Bool
isItTwo 2 = True
isItTwo _ = False
```

Use of `_` here essentially means, "anything else".  

**Note**: Ordering of your patterns matters!  

```haskell
isItTwo :: Integer -> Bool
isItTwo _ = False
isItTwo 2 = True

<interactive>:9:33: Warning:
  Pattern match(es) are overlapped
  In an equation for ‘isItTwo’:
    isItTwo 2 = ...

Prelude> isItTwo 2
False
Prelude> isItTwo 3
False
```

Incomplete pattern matches applied to data they don’t handle will return bottom, a non-value used to denote that the program cannot return a value or result.  
This will throw an exception, which if unhandled, will make your program fail.  

More importantly, we can pattern match on data constructors. As an example:  

```haskell
newtype Username = Username String
newtype AccountNumber = AccountNumber Integer

data User = UnregisteredUser
          | RegisteredUser Username AccountNumber

printUser :: User -> IO()
printUser UnregisteredUser = putStrLn "UnregisteredUser"
printUser (RegisteredUser (Username name) (AccountNumber acctNum)) = putStrLn $ name ++ " " ++ show acctNum
```

Here's another example:  

```haskell
data WherePenguinsLive = Galapagos
                       | Antarctica
                       | Australia
                       | SouthAfrica
                       | SouthAmerica
                       deriving (Eq, Show)

data Penguin = Peng WherePenguinsLive deriving (Eq, Show)

isSouthAfrica :: WherePenguinsLive -> Bool
isSouthAfrica SouthAfrica = True
isSouthAfrica Galapagos = False
isSouthAfrica Antarctica = False
isSouthAfrica Australia = False
isSouthAfrica SouthAmerica = False

galapagosPenguin :: Penguin -> Bool
galapagosPenguin (Peng Galapagos) = True
galapagosPenguin _                = False

antarcticPenguin :: Penguin -> Bool
antarcticPenguin (Peng Antarctica) = True
antarcticPenguin _                 = False

antarcticOrGalapagosPenguin :: Penguin -> Bool
antarcticOrGalapagosPenguin p = (galapagosPenguin p) || (antarcticPenguin p)
```

You can also pattern match tuples, like this:  

```haskell
f :: (a, b) -> (c, d) -> ((b, d), (a, c))
f (a, b) (c, d) = ((b, d), (a, c))
```

## Case Expressions

```haskell
data Bool = False | True
--   [1]     [2]    [3]
```

1.  Type constructor, we only use this in type signatures, not in term-level code like case expressions.
2.  Data constructor for the value of Bool named False — we can match on this.
3.  Data constructor for the value of Bool named True — we can match on this as well.

This:  

```haskell
if x + 1 == 1 then "AWESOME" else "wut"
```

Can be written as:  

```haskell
func x =
  case x + 1 == 1 of
    True -> "AWESOME"
    False -> "wut" 
```

Here's an example with a `where` clause:  

```haskell
pal x =
  case y of
    True -> "yes"
    False -> "no"
  where y = xs == reverse xs
```

## Guards

Guard syntax allows us to write compact functions that allow for two or more possible outcomes depending on the truth of the conditions.  
For example, we can write the following functions:  

```haskell
myAbs :: Integer -> Integer
myAbs x = if x < 0 then (-x) else x
```

as:  

```haskell
myAbs :: Integer -> Integer
myAbs x
  | x < 0     = (-x)
  | otherwise = x
```

Let's look at the structure of this piece of code:  

```haskell
  myAbs :: Integer -> Integer
  myAbs x
-- [1] [2]
    | x < 0     = (-x)
-- [3] [4]     [5] [6]
    | otherwise = x
-- [7]   [8]  [9][10]
```

1.  The name of our function, myAbs still comes first.
2.  There is one parameter named x.
3.  Here’s where it gets different. Rather than an = immediately after the introduction of any parameter(s), we’re starting a new line and using the pipe | to begin a guard case.
4.  This is the expression we’re using to test to see if this branch should be evaluated or not. The guard case expression between the | and = must evaluate to Bool.
5.  The = denotes that we’re declaring what expression to return should our x < 0 be True.
6.  Then after the = we have the expression (-x) which will be returned if x < 0.
7.  Another new line and a | to begin a new guard case.
8.  otherwise is another name for True, used here as a fallback case in case x < 0 was False.
9.  Another = to begin declaring the expression to return if we hit the otherwise case.
10. We kick x back out if it wasn’t less than 0.

Another example:  

```haskell
bloodNa :: Integer -> String
bloodNa x
  | x < 135   = "too low"
  | x > 145   = "too high"
  | otherwise = "just right"
```

We can use different kinds of expressions in the guard blocks, as long as they evaluate to a `Bool` value.  
Remember, `otherwise` is just an alias for `True`.  

We can also include `where` clauses here:  

```haskell
avgGrade :: (Fractional a, Ord a) => a -> Char
avgGrade x
  | y >= 0.9  = 'A'
  | y >= 0.8  = 'B'
  | y >= 0.7  = 'C'
  | y >= 0.59 = 'D'
  | y <  0.59 = 'F'
where y = x / 100
```

## Function Composition

Let's look at the type signature of the composition operator `(.)`:  

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
--       [1]         [2]      [3]  [4]
```

1.  is a function from b to c, passed as an argument (thus the parentheses).
2.  is a function from a to b.
3.  is a value of type a, the same as [2] expects as an argument.
4.  is a value of type c, the same as [1] returns as a result.

Then with the addition of one set of parentheses:  

```haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
--       [1]         [2]         [3]
```

In English:  

1.  given a function b to c
2.  given a function a to b
3.  return a function a to c.

Plainly, functional composition looks like this: `(f . g) x = f (g x)`  

Some examples:  

```haskell
Prelude> negate . sum $ [1, 2, 3, 4, 5]
-15
```

Which is the same as  

```haskell
Prelude> (negate . sum) [1, 2, 3, 4, 5]
```

## Pointfree Style:

Pointfree refers to a style of composing functions without specifying their arguments.  
The “point” in “pointfree” refers to the arguments, not (as it may seem) to the function composition operator.  

Here's an example:  

```haskell
-- Pointful notation
f x = negate . sum $ x

-- Pointfree notation
f = negate . sum
```

Another one, slightly trickier:  

```haskell
f = length . filter (== 'a')
```

Here's some more:  

```haskell
-- Pointful
add :: Int -> Int -> Int
add x y = x + y
-- Pointfree
addPF :: Int -> Int -> Int
addPF = (+)

-- Pointful
addOne :: Int -> Int
addOne = \x -> x + 1
-- Pointfree
addOnePF :: Int -> Int
addOnePF = (+1)
```

# Exercises

## Exercise 1: Grab Bag

1.  Which of these are equivalent?  
    a) `mTh x y z = x * y * z`  
    b) `mTh x y = \z -> x * y * z`  
    c) `mTh x = \y -> \z -> x * y * z`  
    d) `mTh = \x -> \y -> \z -> x * y * z`  
    -> `a`, `b`, `c` and `d` are equivalent

2.  The type of `mTh` (above) is `Num a => a -> a -> a -> a`. Which is the type of `mTh 3`?  
    -> `d`, `Num a => a -> a -> a`

3.  Anonymous syntax rewrite:  
    a) `where f = \n -> n + 1`  
    b) `addFive = \x y -> (if x > y then y else x) + 5`  
    c) `mflip f x y = f y x`

## Exercise 2: Variety Pack

1.  Given the following declaration:  
    
    ```haskell
    k (x, y) = x
    k1 = k ((4-1), 10)
    k2 = k ("three", (1 + 2))
    k3 = k (3, True)
    ```
    
    a) Type of `k` is `k :: (a, b) -> a`  
    b) Type of `k2` is `k2 => [Char]`, and is not the same as the other. `k1` and `k3` are of type `(Num a) => a`  
    c) `k1` and `k3`

2.  Fill in the definition:  
    
    ```haskell
    f :: (a, b, c) -> (d, e, f) -> ((a, d), (c, f))
    f (a, _, c) (d, _, f) = ((a, d), (c, f))  
    ```

## Exercise 3: Case Practice

```haskell
module CasePractice where

-- Exercise 1
functionC x y = if (x > y) then x else y

functionC' x y =
  case greater x y of
    True -> x
    False -> y
  where greater x y = x > y

-- Exercise 2
ifEvenAdd2 n = if even n then (n + 2) else n

ifEvenAdd2' n =
  case even n of
    True -> n + 2
    False -> n

-- Exercise 3
nums x =
  case compare x 0 of
    LT -> -1
    GT -> 1
    EQ -> 0
```

## Exercise 4: Artful Dodgy

Given the following:  

```haskell
dodgy x y = x + y * 10
oneIsOne = dodgy 1
oneIsTwo = (flip dodgy) 2
```

What is the result of the following?  

1.  `dodgy 1 0`  
    Result: `1`

2.  `dodgy 1 1`  
    Result: `11`

3.  `dodgy 2 2`  
    Result: `22`

4.  `dodgy 1 2`  
    Result: `21`

5.  `dodgy 2 1`  
    Result: `12`

6.  `oneIsOne 1`  
    Result: `11`

7.  `oneIsOne 2`  
    Result: `21`

8.  `oneIsTwo 1`  
    Result: `21`

9.  `oneIsTwo 2`  
    Result: `22`

10. `oneIsOne 3`  
    Result: `31`

11. `oneIsTwo 3`  
    Result: `23`

## Exercise 5: Guard Duty

1.  Putting `otherwise` as the top-most guard makes the function evaluate to `'F'` every time.

2.  This will, of course, typecheck, but the results will be different. The first guard to be evaluated to `True` will continue, so order obviously matters.

3.  The following function:  
    
    ```haskell
    pal xs
        | xs == reverse xs = True
        | otherwise        = False
    ```
    
    => b) returns `True` when `xs` is a palindrome.

4.  The argument `xs` needs to be able to be applied to the `reverse` function. This requires the argument to be of type `xs :: Eq a => [a]`.

5.  The type of the function is `pal :: Eq a => [a] -> Bool`.

6.  The following functions:  
    
    ```haskell
    numbers x
      | x < 0  = -1
      | x == 0 = 0
      | x > 0  = 1
    ```
    
    => c) returns an indication of whether its argument is a positive or negative number or zero

7.  The type of argument `x` is `(Num a, Ord a) => a`

8.  The type of the function `numbers` is `numbers :: (Num a, Ord a, Num b) => a -> b`

## Exercise 6: Chapter Summary

### Multiple Choices

1.  A polymorphic function:  
    => d) may resolve to values of different types, depending on the inputs

2.  Two functions named `f` and `g` have types `Char -> String` and `String -> [String]` respectively. The composed function `g . f` has the type:  
    => b) `Char -> [String]`

3.  A function `f` has the type `Ord a => a -> a -> Bool` and we apply it to one numeric value. What is the type now?  
    => d) `(Ord a, Num a) => a -> Bool`

4.  `A function with the type (a -> b) -> c`  
    => b) is a higher-order function

5.  Given the following definition of `f`, what is the type of `f True`?  
    => a) `f True :: Bool`

### Let's Write Code

1.  Exercise 1:  
    
    ```haskell
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
    ```

2.  Exercise 2:  
    
    ```haskell
    module Write2 where
    
    -- Pattern matching version
    foldBool3 :: a -> a -> Bool -> a
    foldBool3 x _ False = x
    foldBool3 _ y True = y
    
    -- Case version
    foldBool' :: a -> a -> Bool -> a
    foldBool' x y bool =
      case bool of
        True -> y
        False -> x
    
    -- Guard version
    foldBool'' :: a -> a -> Bool -> a
    foldBool'' x y bool
      | bool     = y
      | not bool = x
    ```

3.  Exercise 3:  
    
    ```haskell
    module Write3 where
    
    g :: (a -> b) -> (a, c) -> (b, c)
    g f (a, c) = (f a, c)
    ```

4.  Exercise 4:  
    
    ```haskell
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
    ```
