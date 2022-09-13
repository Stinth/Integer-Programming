"""
1)
P8 is a relaxation of P7 given that 
(i) the feasible solutions of P7 are a subset of the feasible solutions in P8,
    the constraints of the two problems are identical with the exception of the first constraint
    this constraint is = 3 in P7 and >= 3 in P8, meaning that P7 is stricter than P8
(ii) the objective function P7 is less than or equal to the objective function of P8
    the objective function of P8 reduces the coefficients for all variables by 4 and adds 12 as a constant
    looking at the first constraint in P7 it is at most possible for 3 variables to be 1
    this means that at most 3*4 = 12 would be lost in the objective function of P8
    therefore the objective function of P8 is greater than or equal to the objective function of P7
    

P8 is a relaxation of P7.
"""