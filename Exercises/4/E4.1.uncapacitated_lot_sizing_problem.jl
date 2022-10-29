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
c = zeros(n)
for i in 1:n
    c[i] = p[i] + sum(h[i:n])
end

H = zeros(n+1)
# should be H[0], but can't do that in julia
H[1] = 0
H[2] = min(H[1] + f[1] + c[1]*sum_demand[1,1])
H[3] = min(H[2] + f[2] + c[2]*sum_demand[2,2], H[1] + f[1] + c[1]*sum_demand[1,2])
H[4] = min(H[3] + f[3] + c[3]*sum_demand[3,3], H[2] + f[2] + c[2]*sum_demand[2,3], H[1] + f[1] + c[1]*sum_demand[1,3])
H[5] = min(H[4] + f[4] + c[4]*sum_demand[4,4], H[3] + f[3] + c[3]*sum_demand[3,4], H[2] + f[2] + c[2]*sum_demand[2,4], H[1] + f[1] + c[1]*sum_demand[1,4])
# then go back and check which one is the minimum


# lecture method
v = zeros(n, n)
for i in 1:n
    for j in 1:n
        if i == j
            v[i,j] = 0
        elseif i < j
            for k in i+1:j
                v[i,j] += d[k] * (k-i)
            end
        end
    end
end
H = zeros(n+1)
# should be H[0], but can't do that in julia
H[1] = 0
H[2] = min(H[1] + f[1] + h[1]*v[1,1] + p[1]*sum_demand[1,1])
H[3] = min(H[2] + f[2] + h[2]*v[2,2] + p[2]*sum_demand[2,2], H[1] + f[1] + h[1]*v[1,2] + p[1]*sum_demand[1,2])
H[4] = min(H[3] + f[3] + h[3]*v[3,3] + p[3]*sum_demand[3,3], H[2] + f[2] + h[2]*v[2,3] + p[2]*sum_demand[2,3], H[1] + f[1] + h[1]*v[1,3] + p[1]*sum_demand[1,3])
H[5] = min(H[4] + f[4] + h[4]*v[4,4] + p[4]*sum_demand[4,4], H[3] + f[3] + h[3]*v[3,4] + p[3]*sum_demand[3,4], H[2] + f[2] + h[2]*v[2,4] + p[2]*sum_demand[2,4], H[1] + f[1] + h[1]*v[1,4] + p[1]*sum_demand[1,4])
# then go back and check which one is the minimum
