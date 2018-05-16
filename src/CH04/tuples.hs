module Tuples where

tupe :: (a, b) -> (c, d) -> ((b, d), (a, c))
tupe ab cd = ((snd ab, snd cd), (fst ab, fst cd))
