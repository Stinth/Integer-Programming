using JuMP
using GLPK

# First solve the model in Julia with all your variables being continous
model = Model(GLPK.Optimizer)

n = 6
volume = [500 500 300 300 200 100]
liquid = [350 300 200 150 100 100]


# continous decision variables for how full the containers are
@variable(model, x[1:n] >= 0)

# minimize the number of containers used
@objective(model, Min, sum(x[i] for i in 1:n))

# used volume must be equal to amount of liquid
@constraint(model, sum(x[i] for i in 1:n) == sum(liquid[i] for i in 1:n))

# a container can not contain more than its volume
for i in 1:n
    @constraint(model, x[i] <= volume[i])
end


JuMP.optimize!(model)
# print the solution
println("This solution does not satisfy the problem constraints")
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:n
    print(JuMP.value(x[i]), " ")
end
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

# used volume must be equal to amount of liquid
@constraint(model, sum(x[i,j]*liquid[j] for i in 1:n for j in 1:n) == sum(liquid[i] for i in 1:n))

# a container can not contain more than its volume
# and if a container is used at the end, the liquid that was originally in it, must remain in it
for i in 1:n
    @constraint(model, sum(x[i, j]*liquid[j] for j in 1:n) <= volume[i]*x[i,i])
end


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