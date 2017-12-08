# Notes:

__Lambda structure__:

```
λ x . x 
  ^─┬─^
    └────── extent of the head of the lambda.
λ x . x
  ^────── the single parameter of the
          function. This binds any
          variables with the same name
          in the body of the function.
λ x . x
      ^── body, the expression the lambda
          returns when applied. This is a
          bound variable.
```

Everything is left-associative

__Lambda abstraction:__ A lambda abstraction is an anonymous function or lambda term.

__Application:__ Application is how one evaluates or reduces lambdas, this binds the argument to whatever the lambda was applied to.

__Normal form:__ A term that cannot be reduced further

__Free variables:__ variables that are not named in the head. For example: ``𝑦`` in ``𝜆𝑥.𝑥𝑦``

__Currying:__ ``𝜆𝑥𝑦.𝑥𝑦`` is actually shorthand for two nested lambas: ``𝜆𝑥.(𝜆𝑦.𝑥𝑦)``

__Combinator:__ A Lambda term with no free variables

Combinators: 
* ``𝜆𝑥.𝑥``
* ``𝜆𝑥𝑦.𝑥``
* ``𝜆𝑥𝑦𝑧.𝑥𝑧(𝑦𝑧)``

Not combinators
* ``𝜆𝑦.𝑥``
* ``𝜆𝑥.𝑥𝑧``

__Divergence:__ When the reduction of a lambda term never ends (it's never reduced to a normal form).

Example: ``(𝜆𝑥.𝑥𝑥)(𝜆𝑥.𝑥𝑥)``