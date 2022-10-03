using JuMP
using GLPK

model = Model(GLPK.Optimizer)

# n = 4 periods
n = 4
# p = [1,1,1,2] production cost
p = [1,1,1,2]
# h = [1,1,1,1] unit storage cost
h = [1,1,1,1]
# f = [20,10,45,15] set-up costs
f = [20,10,45,15]
# d = [8,5,13,4] demand
d = [8,5,13,4]

# positive integer variables for how much is produced in each period
@variable(model, x[1:n] >= 0, Int)

# positive integer variables for how much is stored after time period n
@variable(model, s[1:n] >= 0, Int)

# binary decision variables for whether a facility is open in each period
@variable(model, y[1:n], Bin)

# objective function
@objective(model, Min, sum(p[i]*x[i] + h[i]*s[i] + f[i]*y[i] for i in 1:n))

# constraints
# production + storage = demand + storage from next period
@constraint(model, [i in 1:n-1], x[i] + s[i] == d[i] + s[i+1])
# last period production + storage = demand
@constraint(model, x[n] + s[n] == d[n])
# if a facility is open, then it must produce something
@constraint(model, [i in 1:n], x[i] <= sum(d)*y[i])
# storage from period one is zero
@constraint(model, s[1] == 0)

# solve the problem
optimize!(model)

# print the solution
println("The optimal value is: ", objective_value(model))
println("The optimal solution is: x=", value.(x))
println("The optimal solution is: s=", value.(s))
println("The optimal solution is: y=", value.(y))



# Solving using recursion
using LinearAlgebra
sum_demand = zeros(length(d), length(d))
for i in 1:n
    for j in 1:n
        if i == j
            sum_demand[i,j] = d[i]
        elseif i < j
            sum_demand[i,j] = sum(d[i:j])
        end
    end
end


