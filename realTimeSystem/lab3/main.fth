variable n
variable x

: sqrt ( n -- sqrt )
    dup 0< if drop -1 exit then
    dup 0= if drop 0 exit then
    dup n ! dup x !
    begin
         x @ n @ x @ / + 1 rshift
         dup x @ >= if
             drop x @ exit
         then
         x !
    again ;
25 sqrt .
