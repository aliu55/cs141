%DERIV 
?- deriv(x^2, Y).  
Y = 2*x.
?- deriv((x*2*x)/x, Y). 
Y = 2.
?- deriv(x^4+2*x^3-x^2+5*x-1/x, Y).
Y = 4*x^3+6*x^2-2*x+5+1/x^2.
?- deriv(4*x^3+6*x^2-2*x+5+1/x^2, Y).
Y = 12*x^2+12*x-2-2/x^3.
?- deriv(12*x^2+12*x-2-2/x^3, Y).
Y = 24*x+12+6/x^4.


x^4+2*x^3-x^2+5*x subtract 1/x
x^4+2*x^3-x^2 add 5*x
x^4+2*x^3 subtract x^2
x^4 add 2*x^3
2 multiply x^3
x exponent 3
x exponent 4

power rule -1/X = -1x^-1 = 1x^-2 = 1/x^2
power rule 1/x = 1x^-1 = -1x^-2
quotient rule (x*2*x)/x

