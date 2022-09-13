
"""
1)
P2 is a relaxation of P1 given that 
(i) the feasible solutions of P1 are a subset of the feasible solutions in P2,
    due to the fact that x1, x2 and x3 are strictly integer variables in P1 and continuous variables in P2
    and the constraints remain the same
(ii) the objective function P1 is less than or equal to the objective function of P2
    due to the fact that the objective functions are identical in P1 and P2

The relaxation of P1 is P2, which is a linear program and therefore a linear relaxation of P1.
"""

""""
2)
P3 is a relaxation of P1 given that
(i) the feasible solutions of P1 are a subset of the feasible solutions in P3,
    due to the fact that the only difference between the problems is that P1 has an additional constraint, that we removed in P3
(ii) the objective function P1 is less than or equal to the objective function of P3
    due to the fact that the objective functions are identical in P1 and P3

The relaxation of P1 is P3, which is an integer program with the same objective function as P1, but fewer constraints
It might be a lagrangian relaxation of P1, since we have removed a constraint from P1
but we did not add the constraint as a "punishment" in the objective function, so perhaps not
"""


"""
3)
P4 is a relaxation of P1 given that
(i) the feasible solutions of P1 are a subset of the feasible solutions in P4,
    due to the fact that x1, x2 and x3 are strictly integer variables in P1 and continuous variables in P4
    and the constraints remain the same
(ii) the objective function P1 is less than or equal to the objective function of P4
    due to the fact that the objective function for P4 has strictly larger or equal coefficients than the objective function for P1
"""

"""
4)
P4 is a relaxation of both P2 but not P3 given that
(i) the feasible solutions of P2 are a subset of the feasible solutions in P4,
    due to the fact that the constraints in both problems are identical
    this is not the case for P3, which has fewer constraints than P4
(ii) the objective function P2 is less than or equal to the objective function of P4
    due to the fact that the objective function for P4 has strictly larger or equal coefficients than the objective function for P2    
"""
