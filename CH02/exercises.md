# Exercise 1

**REPL forms**:

1. 
```haskell
--- Non-REPL
half x = x / 2
--- REPL
let half x = x / 2
```

2. 
```haskell
--- Non-REPL
square x = x * x
--- REPL
let square x = x * x
```

**Write a function**

```haskell
func :: Integer -> Number
func x = 3.14 * (x * x) 
```

**Function using `pi`**

```haskell
func :: Integer -> Number
func x = pi * (x * x) 
```

# Exercise 2

1. Result is changed
2. Result is not changed
3. Result is changed

# Exercise 3

Heal the sick!

1.
```haskell
let area x = 3. 14 * (x * x)
-- Should be:
let area x = 3.14 * (x * x)
```

2.
```haskell
let double x = b * 2
-- Should be
let double x = x * 2
-- Or
let double b = b * 2
```

3.
```haskell
 x = 7
y = 10
f=x+y
-- Should be
x = 7
y = 10
f = x + y -- Whitespace here not significant, but looks nicer :)
```

# Exercise 4

```haskell
let x = 5 in x
-- Or
x = a
    where a = 5
``` 
```haskell
let x = 5 in x * x
-- Or
x = a * a
    where a = 5
```
```haskell
let x = 5
    y = 6 
in x * y
-- Or
x = a * b
    where a = 5
          b = 6
```
```haskell
let x = 3
    y = 1000 
in x + 3
-- Or
x = a + 3
    where
        a = 3
        b = 1000
```

# Exercise 5

**Parenthesization:**

```haskell
2 + 2 * 3 - 1
-- Or
(2 + (2 * 3)) - 1
```
```haskell
(^) 10 $ 1 + 1
-- Or
10 ^ (1 + 1)
```
```haskell
2 ^ 2 * 4 ^ 5 + 1
-- Or
((2 ^ 2) * (4 ^ 5)) + 1
```

**Equivalent expressions:**

```haskell
1 + 1
2
-- Yes
```
```haskell
10 ^ 2
10 + 9 * 10
-- Yes
```
```haskell
400 - 37 
(-) 37 400
-- No (363 vs -363)
```
```haskell
100 `div` 3
100 / 3
-- No (3 vs 3.3333...)
```
```haskell
2 * 5 + 18
2 * (5 + 18)
-- No (28 vs 46)
```

**More fun:**

```haskell
z = 7
x = y ^ 2
waxOn = x * 5
y = z + 8
```

Should be the following on the REPL

```haskell
z = 7
y = z + 8
x = y ^ 2
let waxOn = x * 5
```