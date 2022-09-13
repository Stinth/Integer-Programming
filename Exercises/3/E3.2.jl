"""
Problem: E3.2
max 42x1 + 26x2 + 35x3 + 71x4 + 54x5
s.t
    14x1 + 10x2 + 12x3 + 25x4 + 20x5 <= 69
    x1,x2,x3,x4,x5 is integer greater than 0
    (the + lower right of the Z means that it is positive)

Find primal and dual bounds for the integer knapsack problem
    Primal bounds: (lower bound for a max problem). Every feasible
    solution x ∈ X is a lower bound.

    Dual bounds: (upper bound for a max problem). Most important
    approach is by relaxation, that is, replace the original problem by a
    simpler optimization problem whose value is at least as large as z.

Primal bound:
    x1 = 1, x2 = 1, x3 = 1, x4 = 1, x5 = 0
    42 + 26 + 35 + 71 = 174
    14 + 10 + 12 + 25 = 61
    69 - 61 = 8 so constraint is satisfied

Dual bound:
    We chose the dual of the problem, which is a linear program
    (The following is taken from the output of the code below)
    The optimal value is: 207.0
    The optimal solution is: [4.928571428571429, 0.0, 0.0, 0.0, 0.0]

This means that the dual bound is 207, which is greater than the primal bound of 174
For our problem, the dual bound is the upper bound, and the primal bound is the lower bound
"""

using JuMP
using GLPK

model = Model(GLPK.Optimizer)

# Relaxation of the problem
@variable(model, 0 <= x[1:5])

# objective function same as in the original problem
@objective(model, Max, 42*x[1] + 26*x[2] + 35*x[3] + 71*x[4] + 54*x[5])

# constraint same as in the original problem
@constraint(model, 14*x[1] + 10*x[2] + 12*x[3] + 25*x[4] + 20*x[5] <= 69)

# solve the problem
optimize!(model)

# print the solution
println("The optimal value is: ", objective_value(model))
println("The optimal solution is: ", value.(x))
