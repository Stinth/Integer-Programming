## Packages needed for solving MIPs

using JuMP
using GLPK

mo = Model(GLPK.Optimizer) #Setting up the model

#Solved as a binary problem
@variable(mo,y[1:6], Bin)
@variable(mo,x[1:6,1:6], Bin)


n = length(y)                       #Defining the number of variables

v = (500,500,300,300,200,100) # Size of the containers
a = (350,300,200,150,100,100) # Volume of the containers

# Defining the objective function
#∑yᵢ for i = 1:n
@objective(mo, Min, sum( y[i] for i=1:n))  #Setting up the objective function

# Defining the constraints

#∑aᵢ*xᵢⱼ for i = 1:n, i ≠ j + aⱼ*yⱼ  ≦ vⱼ*yⱼ, ∀j
@constraint(mo, [i = 1:n, j = 1:n; i != j], sum(a[i]*x[i,j]  for i = 1:n) + a[j]*y[j]<= v[j]*y[j])
##∑aᵢ*xᵢⱼ for i = 1:n, i ≠ j + yᵢ  = 1, ∀j
@constraint(mo, [i = 1:n], sum(x[i,j] for j = 1:n) + y[i]  == 1)

optimize!(mo)                   #Solving the model

println("Objective value = ", objective_value(mo)) ## Printing the solution


println("y = ", value.(y)) # Remember a dot for printing a vector

println("X = ")
for i in 1:n
    for j in 1:n
        print(value(x[i,j]) , " ")
    end
    println()
end

println("Solver status: ", termination_status(mo))
println("Solution status: ", primal_status(mo))
