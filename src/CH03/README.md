
# Notes

## GHCi commands:

`:type` or `:t` can be used to get a type of a value, expression, or function. For example:

```
Prelude> :t 35
35 :: Num p => p
Prelude> :t "Hello World!"
"Hello World!" :: [Char]
Prelude> :t words
words :: String -> [String]
```

## Strings vs Text

`String` is a very simple type. It is merely an alias for a linked list of `Char`, i.e. `[Char]`

Strings can easily be linked to each other. This is called **concatenation**. This is very simple.

```haskell
hello :: String
hello = "Hello" ++ " " ++ "world!"
```

Alternatively, we can also call `concat` and pass it a list of Strings to be concatenated. This example below yields the same result as the one above:

```haskell
helloAgain :: String
hello = concat ["Hello", " ", "world!"]
```

## A note about `IO`

The `IO` type is a very special type implemented in Haskell for the specific purpose of describing I/O "effects", i.e. something that affects, or is affected by, the state of the outside world. For example, when we want to print something to the screen using `putStrLn`, our function signature would look like this:

```haskell
main :: IO()
main = putStrLn "Hello World!"
```

When we use functions of type `... -> IO` in GHCi, the system takes care of wrapping everything in the necessary types for us.

You'll often see the special **do-syntax** used alongside the IO type. This special syntax allows us to sequence effectful actions our program, resulting in a style that may resemble imperative programming. Here's an example:

```haskell
main :: IO ()
main = do
  putStrLn "Count to four for me:"
  putStr "one, two"
  putStr ", three, and"
  putStrLn " four!"
```

## Top-level declarations vs local definitions

Simply put, when we define something in a Haskell file that is not nested within any other anything else, it is considered a **top-level** definition. Here is an example of a top-level definition:

```haskell
module TopOrLocal where

topFunction :: Integer -> Integer           -- Defined at the top level 
topFunction x = x + 12 

topValue :: String                          -- Defined at the top level
topValue = "Hi guys!"
```

Both the function `topFunction` and value `topValue` we defined here are defined at the **top level** because there aren't nested in any other construct. If we expend our example a little bit though, we can have a look at what a it means to be defined locally.

```haskell
module TopOrLocal where

topFunction :: Integer -> Integer
topFunction x = x + aNumber + anotherNumber
  where aNumber = 1                        -- Defined at the local level
        anotherNumber = 10                 -- Defined at the local level
```

## Concat functions

Let's have a quick look at the types of `++` and `concat`

```
Prelude> :t (++)
(++) :: [a] -> [a] -> [a]
Prelude> :t concat
concat :: Foldable t => t [a] -> [a]
```

The type of `++` makes sense: we take a list and another list as input, and the function will return another list. But what exactly is the meaning of `a` in this context? `a` serves as a type variable. In this type signature, `a` represents a type that we don't know yet. There are no restrictions on that type in this signature. This means that this function takes list of any type. The only restriction is that the arguments and return value are all of type `a`. The type of a will be inferred and known at some point.

Remember that String is of type `[Char]`? This is why we can apply `"Hello" ++ " world"`. In that case, we can imagine the function signature of `concat` to be like `[Char] -> [Char] -> [Char]`. Similarly, we can do something like `[1, 2, 3] ++ [4, 5, 6]`, which would be something like `[Integral] -> [Integral] -> [Integral]` (This is not correct, but let's just roll with that for now).

Of course, we cannot do something like `[1, 2, 3] ++ "I am a String!"` because that would violate that both arguments have to be of type `a`.

The type signature of `concat` may seems a little bit different. It takes something which is a `Foldable`. We currently don't know about this concept yet, but for now it should suffice to say that `Foldable` respresents data structures that can be folded to a single value. Folding is another term for reducing.

## List functions

1.  `:`, aka `cons`
    
    ```haskell
    :t (:) => (:) :: a -> [a] -> [a]
    ```
    
    ```haskell
    'C' : "hris" => "Chris"
    ```
    
    ```haskell
    'P' : "" => "P" 
    ```
2.  `tail`
    
    ```haskell
    :t tail => tail :: [a] -> [a]
    ```
    
    ```haskell
    tail "Joe" => "oe"
    ```
    
    ```haskell
    tail "" => Exception: Prelude.tail: empty list
    ```
3.  `take`
    
    ```haskell
    :t take => take :: Int -> [a] -> [a]
    ```
    
    ```haskell
    take 1 "Joe" => "J"
    ```
    
    ```haskell
    take 0 "Joe" => ""
    ```
    
    ```haskell
    take 2 "Joe" => "Jo"
    ```
4.  `drop`
    
    ```haskell
    :t drop => drop :: Int -> [a] -> [a]
    ```
    
    ```haskell
    drop 5 "Haskell" => "ll"
    ```
    
    ```haskell
    drop 100 "Haskell" => ""
    ```
    
    ```haskell
    drop 1 "Haskell" => "askell"
    ```
5.  `(!!)`
    
    ```haskell
    :t (!!) :: [a] -> Int -> a
    ```
    
    ```haskell
    "Haskell" !! 0 => 'H' 
    ```
    
    ```haskell
    "Haskell" !! 1 => 'a'
    ```
    
    ```haskell
    "Haskell" !! 6 => 'l'
    ```
    
    ```haskell
    "Haskell" !! 7 => Exception: Prelude.!!: index too large
    ```

As you can see, some of these functions return exceptions whenever we pass them certain arguments. Despite the fact that these are part of the Prelude, many of them are considered **unsafe**! We should always be careful when using them.

# Exercises

## Exercise 1: Scope

1.  Is it in scope? Yes, all values are defined at the top level, thus are accesible for everything in this REPL session.
2.  Is it in scope? II No, `h` was not previously defined anywhere in the REPL session.
3.  Is everything we need in scope? Nope: when evaluating `area d = pi * (r * r)`, r would not be in scope. When evaluating `r = d / 2`, d would not be in scope.
    
    There is a simple solution to this one, we learned it in the previous chapter:
    
    ```haskell
    area d = pi * (r * r)
      where r = d / 2
    ```
4.  Is everything we need in scope? II Yes, see above.

## Exercise 2: Syntax errors

1.  Won't compile: `++` is not a prefix operator, but an infix one. There are two ways to solve this:
    
    ```haskell
    (++) [1, 2, 3] [4, 5, 6]
    ```
    
    or
    
    ```haskell
    [1, 2, 3] ++ [4, 5, 6]
    ```
2.  Won't compile: The single-quote syntax is not valid for declaring Strings in Haskell. Single-quotes are used for Chars. To fix it we need to do:
    
    ```haskell
    "<3" ++ " Haskell"
    ```
3.  Will compile just fine

## Exercise 3: Chapter summary

### Are they written correctly?

a. Yes b. No, `++` is an **infix** operator. This should be:

```haskell
(++) [1, 2, 3] [4, 5, 6]y
```

or

```haskell
[1, 2, 3] ++ [4, 5, 6]y
```

c. Yes d. No, this should probably be written as:

```haskell
"hello" ++ " world"
```

or

```haskell
concat ["hello", " world"]
```

e. No, `(!!)` takes a `[a]` as its first argument, and an `Int` as its second one. So:

```haskell
"hello" !! 4
```

f. Yes (see above) g. No, should obviously be:

```haskell
take 4 "lovely"
```

h. Yes

### Matching results and expressions

-   a -> d
-   b -> c
-   c -> e
-   d -> a
-   e -> b

### Write functions to match input/output

1.  "Curry is awesome" -> "Curry is awesome!"
    
    ```haskell
    func :: [Char] -> [Char]
    func x = x ++ !
    ```
2.  "Curry is awesome!" -> "y"
    
    ```haskell
    func :: [Char] -> [Char]
    func x = [x !! 4]
    ```
3.  "Curry is awesome!" -> "awesome!"
    
    ```haskell
    func :: [Char] -> [Char]
    func x = last $ words x
    ```

### Write a function that does the same as above

We alread did this more or less in the previous exercise, but just for completions sake:

```haskell
module Strings where

addBang :: String -> String
addBang x = x ++ "!"

takeFourth :: String -> String
takeFourth x = [x !! 4]

lastWord :: String -> String
lastWord x = last $ words x
```

### Write a functions

```haskell
thirdLetter :: String -> Char
thirdLetter x = x !! 2
```

### Letter indexing function

```haskell
letterIndex :: Int -> Char
letterIndex x = "Curry is awesome!" !! x
```

### Reverse function

```haskell
module Reverse where

main :: IO()
main = print $ rvrs "Curry is awesome"

rvrs :: String -> String
rvrs x = awesome ++ " " ++ is ++ " " ++ curry
    where
      awesome = drop 9 x
      is = take 2 $ drop 6 x
      curry = take 5 x
```

### Reverse function as module

```haskell
module Rvrs where

rvrs :: String -> String
rvrs x = awesome ++ " " ++ is ++ " " ++ curry
    where
      awesome = drop 9 x
      is = take 2 $ drop 6 x
      curry = take 5 x
```
