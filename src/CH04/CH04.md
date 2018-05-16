
# Notes

## About Types

Expressions, when evaluated, reduce to values. Every one of such values has a type. Types are a way to group values that share common characteristics.

Let's have a look at the anatomy of a Haskell datatype:

```haskell
-- Below is the definition of the datatype Bool
data Bool = False | True
---  [1]     [2] [3] [4]
```

1.  Type constructor for the datatype Bool
2.  Data constructor for the value False
3.  This *pipe symbol* (`|`) indicates a **Sum type**, aka "Or". This means "a Bool value is `True` or `False`"
4.  Data constructor for the value True

This construct is called a data declaration

## Numeric Types:

Haskell offers different numeric types:

-   **`Int`:** Fixed-precision integer. Has a fixed min and max range.
-   **`Integer`:** Also an integer type, but this one supports arbitrarily large of small numbers
-   **`Float`:** Single precision floating point number. Arithmetic operations can behave unexpectedly. Do not use in business applications.
-   **`Double`:** Double-precision floating point number. Twice as many bits to describe numbers than `Float`
-   **`Rational`:** Represents a ratio of two numbers, e.g. `1 / 2`. It is arbitrarily precise but less efficient than Scientic.
-   **`Scientific`:** Space efficient and *almost* arbitrarily efficient. Uses scientific notation. The coefficient is an `Integer` and the exponent an `Int`.

All numbers have instances of **Typeclass** `Num`. Typeclasses will be discussed soon.

`Int` also has related types `Int8`, `Int16` and `Int32` and `Int64`, defined in `GHC.Int`. All these types have instances of `Bounded`, which means we can check their bounds.

```haskell
Prelude> import GHC.Int
Prelude> :t minBound
Prelude> minBound :: Bounded a => a
Prelude> :t maxBound
Prelude> maxBound :: Bounded a => a
```

```haskell
Prelude> minBound :: Int8
-128
Prelude> minBound :: Int16
-32768
Prelude> minBound :: Int32
-2147483648
Prelude> minBound :: Int64
-9223372036854775808
```

&#x2026; and so on.

Like the `Int` type, which you'll be using sparingly whenever you want an integer type, the `float` type is similarly almost never desirable over a `double`.

While we still don't know typeclass, we have encountered some along the way:

-   **`Num`:** All numeric types have an instance of this
-   **`Fractional`:** This one represents all fractional types and has `Num` as a superclass.
-   **`Eq`:** Includes everything that can be compared and determined to be equal of value
-   **`Ord`:** Includes all things that can be ordered

Let's have a look at what happens when we don't have an instance of these typeclasses. For examples, this works:

```haskell
Prelude> ['a', 'b'] > ['b', 'a']
Prelude> False
```

Becase if we inspect thes `[]` and `Char` types, we can see they both have instances of `Eq` and `Ord`:

```haskell
Prelude GHC.Int Data.Char> :info []
data [] a = [] | a : [a] 	-- Defined in ‘GHC.Types’
instance Eq a => Eq [a]   -- Defined in ‘GHC.Classes’
instance Ord a => Ord [a] -- Defined in ‘GHC.Classes’
```

```haskell
Prelude GHC.Int Data.Char> :info Char
data Char = GHC.Types.C# GHC.Prim.Char# 	-- Defined in ‘GHC.Types’
instance Eq Char                          -- Defined in ‘GHC.Classes’
instance Ord Char                         -- Defined in ‘GHC.Classes’
```

If we were to define our own datatype, we unfortunately can't start comparing. The following will yield and error:

```haskell
Prelude> data Mood = G | B deriving Show
Prelude> [G, B] > [B, G]
```

```
<interactive>:28:14:
    No instance for (Ord Mood) arising
        from a use of ‘>’
    In the expression: [G, B] > [B, G]
    In an equation for ‘it’:
        it = [G, B] > [B, G]
```

## Conditionals with if-then-else

While there are obviously no *if-statements* in Haskell, there are *if-expressions*! An example:

```haskell
Prelude> let t = "Truthin'"
Prelude> let f = "Falsin'"
Prelude> if True then t else f
"Truthin'"
```

## Tuples

Tuples allow us to pass around multiple values in a single value. The amount of value we put into a tuple is referred to as the **arity**. Let's look at the datatype declaration of a two-tuple (a tuple of arity 2):

```haskell
Prelude GHC.Int Data.Char> :info (,)
data (,) a b = (,) a b 	-- Defined in ‘GHC.Tuple’
```

Notice that this contains two type variables `a` and `b`. Interesting. Remember `Bool`? That was expressed as `data Bool = True | False`, meaning that is was a **sum-type**. This, however, is a **product-type**. A **product-type** represents a *conjunction*: we must supply *both* `a` and `b`. However, not that `a` and `b` don't have to be different.

```haskell
Prelude> (,) 8 10
(8,10)
Prelude> (,) 8 "Julie"
(8,"Julie")
Prelude> (,) True 'c'
(True,'c')
```

However, when we apply it to only one argument:

```haskell
Prelude> (,) 9
  <interactive>:34:1:
  No instance for (Show (b0 -> (a0, b0)))
    (maybe you haven't applied enough
      arguments to a function?)
    arising from a use of ‘print’
  In the first argument of ‘print’,
    namely ‘it’
  In a stmt of an interactive
    GHCi command: print it
```

Two-tuple comes with some handy built-in featues:

```haskell
fst :: (a, b) -> a
snd :: (a, b) -> b
swap :: (a, b) -> (b, a)
```

We can use the tuple syntax to perform pattern matching. For example: we can write the above functions ourselves like this:

```haskell
fst' :: (a, b) -> a
fst' (a, b) = a

snd' :: (a, b) -> b
snd' (a, b) = b

swap' :: (a, b) -> (b, a)
swap' (a, b) = (b, a)
```

A more complex example of pattern matching using tuples:

```haskell
tupFunc :: (Int, [a]) -> (Int, [a]) -> (Int, [a])
tupFunc (a, b) (c, d) = ((a + c), (b ++ d))
```

Protip: keep tuples to a reasonable size.

# Exercises

## Exercise 1: Mood Swings

1.  Type constructor: `Mood`
2.  Values: `Blah` or `Woot`
3.  This particular type signature only allows you to return the `Woot` value. It should be:
    
    ```haskell
    changeMood :: Mood -> Mood
    ```
4.  The function should be something along these lines:
    
    ```haskell
    changeMood :: Mood -> Mood
    changeMood Blah = Woot
    changeMood Woot = Blah
    ```
5.  Here is the complete solution:
    
    ```haskell
    module Mood where
    
    data Mood = Woot | Blah
      deriving Show
    
    changeMood :: Mood -> Mood
    changeMood Woot = Blah
    changeMood Blah = Woot
    ```

## Exercise 2: Find The Mistakes

1.  Should be:
    
    ```haskell
    not True && True
    ```
2.  Should be:
    
    ```haskell
    not (x == 6)
    ```
3.  This one's fine
4.  Should be:
    
    ```haskell
    ["Merry"] > ["Happy"]
    ```
5.  Should be (I think?)
    
    ```haskell
    ['1', '2', '3'] ++ "look at me!"
    ```

## Exercise 3: Chapter Summary

### Solve!

1.  `length` function type signature: `length :: [a] -> Int`
2.  Results:
    -   `length [1, 2, 3, 4, 5]` -> 5
    -   `length [(1, 2), (2, 3), (3, 4)]` -> 3
    -   `length allAwesome` -> 10
    -   `length (concat allAwesome)` -> 11
3.  Currently, we return an `Int` from the `length` functional, but `/` takes two `Fractional` values. So the second expression won't work.
4.  This should fix it: ``6 `div` length [1, 2, 3]`` or `div 6 (length [1, 2, 3])`
5.  The type of this expression is `Bool`, and the result is `True`.
6.  The type of this expression is `Bool`, and the result is `False`.
7.  Results:
    -   **`length allAwesome == 2`:** Works, result is `True`.
    -   **`length [1, 'a', 3, 'b']`:** Doesn't work, lists consist out of values of a single type.
    -   **`length allAwesome + length awesome`:** Works, result is `5`.
    -   **`(8 == 8) && ('b' < 'a')`:** Works, result is `False`.
    -   **`(8 == 8) && 9` :: Doesn't work, type signature of `&&` is ~(&&):** Bool -> Bool -> Bool~.
8.  Palindrome function:
    
    ```haskell
    isPalindrome :: (Eq a) => [a] -> Bool
    isPalindrome x = reverse x == x
    ```
9.  Absolute number function:
    
    ```haskell
    module Absolute where
    
    myAbs :: Int -> Int
    myAbs x =
      if x < 0
         then x * (-1)
         else x
    ```
10. Fill in the definition of the function:
    
    ```haskell
    module Tuples where
    
    tupe :: (a, b) -> (c, d) -> ((b, d), (a, c))
    tupe ab cd = ((snd ab, snd cd), (fst ab, fst cd))
    ```

### Correct the Syntax

1.  Add 1 to the length of a string argument and return the result: Problems:
    
    -   Infix syntax is wrong. You should use `` `x` `` instead of `'x'`
    -   Function name is wrong. It should start with a lowercase letter. So `f` instead of `F`. Otherwise the compiler looks for a data constructor `F`, which it can't find.
    
    Fix:
    
    ```haskell
    f xs = w `x` 1 
      where w = length xs
    ```
2.  The indentity function: Problems:
    
    -   Lambda syntax is wrong. `=` should be `->`.
    -   Once again the paramater of this ananymous function should be lowercased, otherwise we refer to data constructor `X`.
    
    Fix:
    
    ```haskell
    \x -> x
    ```
3.  Return values of tuple: Problems: Once again, a capitalisation problem: there is no paramater `A`. It should be `a`. Fix:
    
    ```haskell
    f (a, b) = a
    ```

### Match functions and types

1.  c
2.  b
3.  a
4.  d
