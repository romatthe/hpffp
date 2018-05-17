module Sing where                   -- `sing` should be `Sing`

fstString :: String -> String       -- `++` should be `->`
fstString x = x ++ " in the rain"

sndString :: String -> String       -- `Char` should be `[Char]`
sndString x = x ++ " over the rainbow"

sing =
  if x < y
    then fstString x
    else sndString y                -- `or` should be `else`
  where
    x = "Singin'"
    y = "Somwhere"                  -- `x` should be `y`
