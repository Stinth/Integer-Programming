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

# K^C is a subset of K' given that the solution x = [1,0,1,0] is feasible in both
# but the solution x = [0.5,0.5,1,0] is not feasible in K^C.

# Subquestion 3.3

# I would say it is more cumbersome, but perhaps slightly faster?