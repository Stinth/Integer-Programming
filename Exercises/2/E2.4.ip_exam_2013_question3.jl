using JuMP
using GLPK
# termination_status(model)
model = Model(GLPK.Optimizer)

weight = [6 6 6 5]
capacity = 16

# binary decision variable choosing which item to put in the bag
@variable(model, x[1:4], Bin)

# @objective


# Subquestion 3.2

# by adding the constraints in K^C we get 3x1 + 3x2 + 3x3 + 3x4 <= 8
# multiplying this by 2 we get: 6x1 + 6x2 + 6x3 + 6x4 <= 16

# That is very similar to K'. Since the coefficients are equal or higher in K^C
# than in K', any feasible solution of K^C is also a feasible solution of K'.
# Hence K^C is a subset of K'.

# (K') 6x1 + 6x2 + 6x3 + 5x4 <= (K^C) 6x1 + 6x2 + 6x3 + 6x4 <= 16
# Which means the constraints in K' is also obeyed if the constraints of K^C is


# Subquestion 3.3

# K^C is a subset of K' given that the solution x = [1,0,1,0] is feasible in both
# but the solution x = [0.5,0.5,1,0] is not feasible in K^C.