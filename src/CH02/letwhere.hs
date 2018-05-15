module FunctionWithWhere where 
    
printIncWhere n = print plusTwo
    where plusTwo = n + 2


printIncLet n = 
    let plusTwo = n + 2 
    in print plusTwo