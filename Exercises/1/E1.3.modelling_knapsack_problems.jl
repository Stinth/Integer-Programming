using JuMP
using GLPK

# The Subset Sum Problem
model = Model(GLPK.Optimizer)

# random weights
weight = [3,4,6,7,1]
capacity = 12


# binary decision variables
@variable(model, x[1:5], Bin)

# maximize weight
@objective(model, Max, sum(weight[i]*x[i] for i=1:5))

# weight cannot excede capacity
@constraint(model, sum(x[i]*weight[i] for i=1:5) <= capacity)

JuMP.optimize!(model)
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:5
    print(JuMP.value(x[i]), " ")
end
print("\n-----------------------------------------------------\n")

# Precedence Constrained Knapsack Problems
model = Model(GLPK.Optimizer)

# random weights
weight = [3,4,6,7,1]
capacity = 12
# Set of pairs 
A = [(1,4),(2,3)]


# binary decision variables
@variable(model, x[1:5], Bin)

# maximize weight
@objective(model, Max, sum(weight[i]*x[i] for i=1:5))

# weight cannot excede capacity
@constraint(model, sum(x[i]*weight[i] for i=1:5) <= capacity)
# precedence constraints
for i in 1:2
    @constraint(model, x[A[i][1]] >= x[A[i][2]])
end

JuMP.optimize!(model)
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:5
    print(JuMP.value(x[i]), " ")
end
print("\n-----------------------------------------------------\n")

# Multiple Knapsack Problem
model = Model(GLPK.Optimizer)

# random weights
weight = [3,4,6,7,1,2,5,8,9,10]
profit = [7,3,2,9,10,5,4,1,6,8]
capacity = [1,12,1]


# binary decision variables
@variable(model, x[1:10], Bin)
# individual knapsack decision variable
@variable(model, y[1:3,1:10], Bin)

# maximize weight
@objective(model, Max, sum(profit[i]*x[i] for i=1:10))

# weight cannot excede capacity
for i=1:3
    @constraint(model, sum(y[i,j]*weight[j] for j=1:10) <= capacity[i])
end

# item can only be put into one knapsack
for i=1:10
    @constraint(model, sum(y[j,i] for j in 1:3) == x[i])
end


JuMP.optimize!(model)
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:10
    print(JuMP.value(x[i]), " ")
end
for i=1:3
    print("\nKnapsack", i, ": ")
    for j=1:10
        print(JuMP.value(y[i,j]), " ")
    end
end
print("\n-----------------------------------------------------\n")

# Multiple Choice Knapsack Problem
model = Model(GLPK.Optimizer)

# random weights
weight = [3 4 6; 7 2 5; 1 8 9; 10 4 1]
profit = [7 3 2; 9 10 5; 1 6 8; 4 2 9]
capacity = 12

# binary decision variables
@variable(model, x[1:12], Bin)
# individual knapsack decision variable

# maximize weight
@objective(model, Max, sum(profit[i]*x[i] for i=1:12))

# weight cannot excede capacity
@constraint(model, sum(x[i]*weight[i] for i=1:12) <= capacity)

# only chose one item per row
for i=1:4
    @constraint(model, sum(x[j] for j in (i-1)*3+1:i*3) == 1)
end


JuMP.optimize!(model)
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:12
    print(JuMP.value(x[i]), " ")
end