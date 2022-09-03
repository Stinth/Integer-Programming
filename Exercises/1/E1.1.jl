using JuMP
using GLPK

model = Model(GLPK.Optimizer)

# {1...7} binary variables
@variable(model, x[1:7], Bin)


# Invest in as many as possible
@objective(model, Max, sum(x[i] for i=1:7))

# Investment 1 cannot be choses if investment 3 is chosen
@constraint(model, x[1]+x[3] <= 1)

# Investment 4 can be chosen only if investment 2 is also chosen
@constraint(model, x[4] <= x[2])

# You must either choose both investment 1 and 5 or choose neither
@constraint(model, x[1] == x[5])

# You must choose either at least one of the investments 1, 2 and 3
# or at least two investments from 2, 4, 5 and 6
# @variable(model, y[1:2], Bin)
# @constraint(model, sum(x[i] for i=1:3) >= y[1])
# @constraint(model, sum(x[i] for i in [2,4,5,6]) >= 2*y[2])
# @constraint(model, sum(y[i] for i=1:2) == 1)
# Better version:
@constraint(model, 2*sum(x[i] for i in [1,2,3]) + sum(x[i] for i in [2,4,5,6]) >= 2)

JuMP.optimize!(model)

println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:7
    print(JuMP.value(x[i]), " ")
end