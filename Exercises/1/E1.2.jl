using JuMP
using GLPK
# First part of the exercise:
model = Model(GLPK.Optimizer)

# Two decision variables binary
@variable(model, y[1:2], Bin)
x = [5,3]
@objective(model, Min, sum(x[i]*y[i] for i=1:2))

# Only one y can be chosen
@constraint(model, sum(y[i] for i=1:2) == 1)


JuMP.optimize!(model)

println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:2
    print(JuMP.value(y[i]), " ")
end
print("\n-----------------------------------------------------\n")

####################################################################
# Second part of the exercise:
model = Model(GLPK.Optimizer)

# Two decision variables binary
@variable(model, y[1:2], Bin)
x = [5,3]
@objective(model, Max, (x[1]-x[2])*y[1] + (x[2]-x[1])*(1- y[2]))


JuMP.optimize!(model)

println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:2
    print(JuMP.value(y[i]), " ")
end
print("\n-----------------------------------------------------\n")

####################################################################
# With x as a decision variable
model = Model(GLPK.Optimizer)

# One decision variables Integer
@variable(model, z, Int)
# Two decision variables Integer
@variable(model, x[1:2], Int)
C = 100
@objective(model, Max, z)

# z is less than both X
@constraint(model, z <= x[1])
@constraint(model, z <= x[2])
# z is greater than 0
@constraint(model, z >= 0)
# X variables are above 0 and below 100
for i=1:2
    @constraint(model, 0 <= x[i] <= C)
end



JuMP.optimize!(model)

println("Objective is: ", JuMP.objective_value(model))
println("Solution is x: ")
for i=1:2
    print(JuMP.value(x[i]), " ")
end
print("\n-----------------------------------------------------\n")

####################################################################
# Second part of the exercise:
model = Model(GLPK.Optimizer)

# One decision variables Integer
@variable(model, z, Int)
# Two decision variables Integer
@variable(model, x[1:2], Int)
C = 100
@objective(model, Min, z)
# X variables are above 0 and below 100
for i=1:2
    @constraint(model, 0 <= x[i] <= C)
end
# z is greater than x1 minus x2
@constraint(model, z >= x[1]-x[2])
# z is greater than x2 minus x1
@constraint(model, z >= x[2]-x[1])
# z is greater than 0
@constraint(model, z >= 0)


JuMP.optimize!(model)

println("Objective is: ", JuMP.objective_value(model))
println("Solution is x: ")
for i=1:2
    print(JuMP.value(x[i]), " ")
end
print("\n-----------------------------------------------------\n")