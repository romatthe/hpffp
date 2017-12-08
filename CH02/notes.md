# Notes

## Definitions

__Prelude:__ Prelude is a library of standard functions that are loaded by default. Prelude is included in the `base` package.

__Expressions:__ Expressions may be values, combinations of values, and/or functions applied to values. Expressions evaluate to a result.

__Declarations:__ Top-level bindings which allows us to name expressions, allowing us to refer to them.

__Currying:__ As in the lambda calculus, all functions in Haskell take one argument and return one result. The way to think of this is that, in Haskell, when it seems we are passing multiple arguments to a function, we are actually applying a series of nested functions, each to one argument. This is called currying.

## Anatomy of a function

```haskell
    triple x = x * 3
    --[1] [2] [3] [4]
```
1. This is the name of the function we are defining; it is a function declaration. Note that it begins with a lowercase letter.
2. This is the parameter of the function. The parameters of our function correspond to the head of a lambda and bind variables that appear in the body expression.
3. The = is used to define (or declare) values and functions. This is not how we test for equality between two values in Haskell.
4. This is the body of the function, an expression that could be evaluated if the function is applied to a value. If triple is applied, the argument it’s applied to will be the value to which the 𝑥 is bound. Here the expression x * 3 constitutes the body of the function. So, if you have an expression like triple 6, 𝑥 is bound to 6. Since you’ve applied the function, you can also replace the fully applied function with its body and bound arguments.

## Infix vs Prefix

Prefix:

```haskell
div 10 4    -- Regular prefix
10 `div` 4  -- Prefix function in infix style
```

Infix
```haskell
10 + 4      -- Regular infix
(+) 10 4    -- Infix function in prefix style
```

## GHCi commands

1. `:load` : Loads a specific Haskell file, e.g. `:load test.hs`
2. `:m` or `:module` : Unloads a module from the REPL.
3. `:info` : Type signature, module defined and left/right associativity, precedence and infix or prefix

## Difference in division arithmetic:

Operator|Name|Purpose
---|---|---
/|slash|fractional division
div|divide|integral division, round down
mod|modulo|like ‘rem’, but a er modular division
quot|quotient|integral division, round towards zero
rem|remainder|remainder a er division

## The $ operator

```
Prelude> :info ($)
($) :: (a -> b) -> a -> b
infixr 0 $
```

The `$` operator is defined as such
`f $ a = f a`

As seen by using the `:info`, the precedence of `$` is 0. This means that we can use `$` to write fewer paretheses.

Example

```haskell
Prelude> (2^) (2 + 2)
16

-- Or

Prelude> (2^) $ 2 + 2
16
```

In this example, because `$` takes lower precedence, `2 + 2` (aka, everything on the right of `$`) is evaluated first.