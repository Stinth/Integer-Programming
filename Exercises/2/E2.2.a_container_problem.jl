using JuMP
using GLPK

# First solve the model in Julia with all your variables being continous
# model = Model(GLPK.Optimizer)

# n = 6
# volume = [500 500 300 300 200 100]
# liquid = [350 300 200 150 100 100]


# # binary decision variables for where the liquid in a container ends up being stored
# @variable(model, x[1:n,1:n], Bin)

# # minimize the number of containers used
# @objective(model, Min, sum(x[i,i] for i in 1:n))

# # used liquid must be less than volume
# @constraint(model, [j = 1:n], sum(x[i,j]*liquid[i] for i in 1:n) <= volume[j]*x[j,j])

# # the liquid in a container can only be used once
# @constraint(model, [i = 1:n], sum(x[i,j] for j in 1:n) == 1)

# JuMP.optimize!(model)
# # print the solution
# println("This solution does not satisfy the problem constraints")
# println("Objective is: ", JuMP.objective_value(model))
# println("Solution is: ")
# for i in 1:n
#     for j in 1:n
#         print(JuMP.value(x[i,j]), " ")
#     end
#     println()
# end
println("\n-----------------------------------------------------\n")


# Secondly solve the model in Julia with appropriate variable definitions
model = Model(GLPK.Optimizer)

n = 6
volume = [500 500 300 300 200 100]
liquid = [350 300 200 150 100 100]


# binary decision variables for where the liquid in a container ends up being stored
@variable(model, x[1:n,1:n], Bin)

# minimize the number of containers used
@objective(model, Min, sum(x[i,i] for i in 1:n))

# used liquid must be less than volume
@constraint(model, [j = 1:n], sum(x[i,j]*liquid[i] for i in 1:n) <= volume[j]*x[j,j])

# the liquid in a container can only be used once
@constraint(model, [i = 1:n], sum(x[i,j] for j in 1:n) == 1)

JuMP.optimize!(model)
# print the solution
println("This solution does not satisfy the problem constraints")
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i in 1:n
    for j in 1:n
        print(JuMP.value(x[i,j]), " ")
    end
    println()
end