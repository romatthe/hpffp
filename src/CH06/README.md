
# Notes

Typeclasses allow us to generalize over a set of types in order to define and execute a standard set of features for those types.  

Some example typeclasses that we will encounter often:  

-   `Bounded`: Types that have an upper and lower bound.
-   `Enum`: Types that can be enumerated (?).
-   `Eq`: Types that can be tested for equality.
-   `Ord`: Types that can be put into sequential order.
-   `Read`: Types that can be parsed from Strings.
-   `Show`: Types that can be rendered into Strings.

We can easily get some info on typeclasses in the REPL:  

```haskell
Prelude> :info Eq
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
```

When we have a look at the hackage docs on the Eq typeclass, we notice something interesting:  

> Minimal complete definition: either `= or /`.  

This means we only have to implement either (`=) or (/`) for our type to have a complete instance of `Eq`. This is because either one can be negated to obtain the desired functionality of the other one.  
You're obviously free to implement both if you feel this is required.  

Let's see how we can implement this stuff on our own. First, a simple datatype:  

```haskell
data Trivial = Trivial
```

We can't check for equality yet:  

```haskell
Prelude> Trivial == Trivial

<interactive>:3:1: error:
    • No instance for (Eq Trivial) arising from a use of ‘==’
    • In the expression: Trivial == Trivial
      In an equation for ‘it’: it = Trivial == Trivial
```

Let's write an instance for the `Eq` typeclass:  

```haskell
data Trivial = Trivial'      -- Notice the ' mark to show the difference between type constructor
                             -- and data constructor
instance Eq Trivial where
  Trivial' == Trivial' = True 
```

The above can look a bit confusing so we could also write it like the example below. This makes it a little clearer what we're implementing.  

```haskell
instance Eq Trivial where
  (==) Trivial' Trivial' = True
```

Another example, using a different datatype:  

```haskell
data DaysOfWeek =
  Mon | Tue | Wed | Thu | Fri | Sat | Sun

data Date =
  Date DaysOfWeek Int

instance Eq DaysOfWeek where
  (==) Mon Mon = True
  (==) Tue Tue = True
  (==) Wed Wed = True
  (==) Thu Thu = True
  (==) Fri Fri = True
  (==) Sat Sat = True
  (==) Sun Sun = True
  (==) _ _     = False

instance Eq Date where
  (==) (Date weekDay dayOfMonth)
       (Date weekDay' dayOfMonth') =
    weekday == weekday' && dayOfMonth == dayOfMonth'
```

If we were to leave out the last line of the `Eq` instance for `DaysOfWeek` (this one `(==) _ _     = False`), we'd be writing a **partial function**.  
In other words: a function that doesn't handle all cases. It would blow up if were te do something along the lines of `Sun == Tue`, because that final clause handles that.  

We can let GHC know us about this by using the `-Wall` flag (which gives us all the warnings). We can do this in a GHCi REPL by doing `Prelude> :set -Wall`. You could use a linter like Hlint, etc. as well.  
This also happens in non-typeclass istances. For example:  

```haskell
f :: Int -> Bool
f 2 = True
```

This one would also throw a warning.  

If we're writing typeclass instances for datatypes with polymorphic type parameters, we sometimes need to constrain those type variables:  

```haskell
data Identity a = Identity a

instance Eq (Identity a) where
  (==) (Identity x) (Identity x') = x == x'
```

The above won't fly though:  

```
No instance for (Eq a) arising from a use of ‘==’
Possible fix: add (Eq a) to the
context of the instance declaration
In the expression: x == x'
In an equation for ‘==’:
  (==) (Identity x) (Identity x') = x == x'
In the instance declaration for ‘Eq (Identity a)’
```

This makes sense. After all, how do we know if `a` has an `Eq` instance? Right now, we can't just assume this. Here's the fix:  

```haskell
instance Eq a => Eq (Identity a) where
  (==) (Identity x) (Identity x') = x' == x
```

This yields an interesting property:  

```haskell
Prelude> data Identity a = Identity a
Prelude> data Junk = Junk'
Prelude> instance Eq a => Eq (Identity a) where (==) (Identity x) (Identity x') = x == x'
Prelude> (Identity 1) == (Identity 1)
True
Prelude> (Identity Junk') == (Identity Junk')

<interactive>:7:1: error:
    • No instance for (Eq Junk) arising from a use of ‘==’
    • In the expression: (Identity Junk') == (Identity Junk')
      In an equation for ‘it’: it = (Identity Junk') == (Identity Junk')
```

So our equality function is implemented, but only for types `Eq a => a`  

# Exercises

## Exercise 1: Eq Instances

```haskell
module EqInstances where


-- Solution 1
data TisAnInteger = TisAn Integer

instance Eq TisAnInteger where
  (==) (TisAn x) (TisAn x') = x == x'

-- Solution 2
data TwoIntegers = Two Integer Integer

instance Eq TwoIntegers where
  (==) (Two x y) (Two x' y') = x == y && x' == y'

-- Solution 3
data StringOrInt = TisAnInt Int | TisAString String

instance Eq StringOrInt where
  (==) (TisAnInt x) (TisAnInt x') = x == x'
  (==) (TisAString x) (TisAString x') = x == x'
  (==) _ _ = False

-- Solution 4
data Pair a = Pair a a

instance Eq a => Eq (Pair a) where
  (==) (Pair x y) (Pair x' y') = x == x' && y == y'

-- Solution 5
data Tuple a b = Tuple a b

instance (Eq a, Eq b) => Eq (Tuple a b) where
  (==) (Tuple a b) (Tuple a' b') = a == a' && b' == b'

-- Solution 6
data Which a = ThisOne a | ThatOne a

instance Eq a => Eq (Which a) where
  (==) (ThisOne a) (ThisOne a') = a == a'
  (==) (ThatOne a) (ThatOne a') = a == a'
  (==) _ _ = False

-- Solution 7
data EitherOr a b = Hello a | Goodbye b

instance (Eq a, Eq b) => Eq (EitherOr a b) where
  (==) (Hello a) (Hello a') = a == a'
  (==) (Goodbye b) (Goodbye b') = b == b'
  (==) _ _ = False
```

## Exercise 2: Will They Work?

1.  Will it work?  
    
    ```haskell
    max (length [1, 2, 3])
        (length [8, 9, 10, 11, 12])
    ```
    
    => Yes, length returns type `Int`, and it implements `Ord`

2.  Will it work?  
    
    ```haskell
    compare (3 * 4) (3 * 5)
    ```
    
    => Yes, all instances of `Num` implement `Ord`

3.  Will it work?  
    
    ```haskell
    compare "Julie" True
    ```
    
    => No, the type signature of `compare` is `Ord a => a -> a -> Ordering`

4.  Will it work?  
    
    ```haskell
    (5 + 3) > (3 + 6)
    ```
    
    => Yes

## Exercise 3: Chapter Summary

### Multiple Choice:

1.  The `Eq` class:  
    c) Makes equality tests possible

2.  The typeclass `Ord`  
    b) Is a subclass of `Eq`

3.  Suppose the typeclass `Ord` has an operator `>`. What is the type of `>`.  
    a) `Ord a => a -> a -> Bool`

4.  In `x = divMod 16 12`  
    c) The type of `x` is a tuple

5.  The typeclass `Integral` includes  
    a) `Int` and `Integral` numbers

### Does It Typecheck?

1.  Typecheck or not?  
    
    ```haskell
    data Person = Person Bool
    printPerson :: Person -> IO ()
    printPerson person = putStrLn (show person)
    ```
    
    => No, because there is no instance of `Show` for type `Person`

2.  Typecheck or not?  
    
    ```haskell
    data Mood = Blah
              | Woot deriving Show
    
    settleDown x = if x == Woot then Blah else x
    ```
    
    => No, because there is no instance of `Eq` for type `Mood`

3.  If we were able to get `settleDown` to typecheck  
    a) Acceptable values would be `Blah` and `Woot`, because type of `==` is `Eq a => a -> a -> Bool`  
    b) The compiler won't accept `settleDown 9` because we can't do `9 == Woot` since 9 isn't of type `Mood`  
    c) We currently can't compile `Blah > Woot` because there is no instance of `Ord` for type `Mood`

4.  Typcheck or not?  
    
    ```haskell
    type Subject = String
    type Verb = String
    type Object = String
    
    data Sentence = Sentence Subject Verb Object
      deriving (Eq, Show)
    
    s1 = Sentence "dogs" "drool"
    s2 = Sentence "Julie" "loves" "dogs"
    ```
    
    => Yes, typechecks just fine. `s2` is of type `Sentence` and `s2` is of type `Object -> Sentence`

### Given the Datatype, What Can We Do?

Given is the following:  

```haskell
data Rocks = Rocks String deriving (Eq, Show)
data Yeah = Yeah Bool deriving (Eq, Show)
data Papu = Papu Rocks Yeah deriving (Eq, Show)
```

What will typecheck?  

1.  `phew = Papu "chases" True`  
    => No, the data constructors have been omitted here. Fix: `phew = Papu (Rocks "chases") (Yeah True)`

2.  `truth = Papu (Rocks "chomskydoz") (Yeah True)`  
    => Yes, see the question above

3.  `equalityForall :: Papu -> Papu -> Bool`  
    `equalityForall p p' = p == p'`  
    => Yes, `Papa` derives `Eq`

4.  `comparePapus :: Papu -> Papu -> Bool`  
    `comparePapus p p' = p > p'`  
    => No, There is no instance of `Ord` for type `Papu`

### Match the Types

1.  For the following definition:  
    
    ```haskell
    i :: Num a => a
    i = 1
    ```
    
    => Cannot be replaced by `i :: a` because `i = 1` causes GHC to infer that `i` is of type `Num a => a`

2.  For the following definition:  
    
    ```haskell
    f :: Float
    f = 1.0
    ```
    
    => Cannot be replaced by `f :: Num a => a`, because `f = 1.0` causes GHC to infer that `f` is of type `Fractional a => a`

3.  For the following definition:  
    
    ```haskell
    f :: Float
    f = 1.0
    ```
    
    => This can be replaced with `f :: Fractional a => a`, and is in line with what GHC infers from `f = 1.0`

4.  For the following definition:  
    
    ```haskell
    f :: Float
    f = 1.0
    ```
    
    => This can be replaced with `f :: RealFrac a => a`. `RealFrac` is a subclass of `Float`.

5.  For the following definition:  
    
    ```haskell
    freud :: a -> a
    freud x = x
    ```
    
    => This can be replaced with `freud :: Ord a => a -> a`

6.  For the following definition:  
    
    ```haskell
    freud' :: a -> a
    freud' x = x
    ```
    
    => This can be replaced with `freud' :: Int -> Int`

7.  For the following definition:  
    
    ```haskell
    myX = 1 :: Int
    sigmund :: Int -> Int
    sigmund x = myX
    ```
    
    => This cannot be replaced with `sigmund :: a -> a` because `myX` implies `Int`

8.  For the following definition:  
    
    ```haskell
    myX = 1 :: Int
    sigmund' :: Int -> Int
    sigmund' x = myX
    ```
    
    => This cannot be replaced with `sigmund' :: Num a => a -> a`

9.  For the following definition:  
    
    ```haskell
    jung :: Ord a => [a] -> a
    jung xs = head (sort xs)
    ```
    
    => This can be replaced with `jung :: [Int] -> Int`

10. For the following defintion:  
    
    ```haskell
    young :: [Char] -> Char
    young xs = head (sort xs)
    ```
    
    => This can be replaced with `young :: Ord a => [a] -> a`

11. For the following defintion:  
    
    ```haskell
    mySort :: [Char] -> [Char]
    mySort = sort
    signifier :: [Char] -> Char
    signifier xs = head (mySort xs)
    ```
    
    => This cannot be replaced with `signifier :: Ord a => [a] -> a` because the `mySort` has already narrowed the types down.

### Type Kwon-Do:

```haskell
module TypeKwonDo where

chk :: Eq b => (a -> b) -> a -> b -> Bool
chk func x y = func x == y

arith :: Num b => (a -> b) -> Integer -> a -> b
arith func x y = func y
```
