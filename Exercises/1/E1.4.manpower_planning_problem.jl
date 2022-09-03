using JuMP
using GLPK

# First part of the exercie:
model = Model(GLPK.Optimizer)
# employees needed per day for 7 days
b = [10,5,10,5,10,5,10]



# decision variable for how many employees starts work each day
@variable(model, x[1:7], Int)

# objective function minimize the total number of employees
@objective(model, Min, sum(x[i] for i=1:7))
# objective function minimize the total number of employees, but saturday and sunday cost more
# @objective(model, Min, sum(x[i] for i=1:7) + sum(x[i] for i=2:7) + sum(x[i] for i=3:7))

# constraint for each day, the number of employees needed is less than or equal to the number of employees available
# each employee must work 5 consecutive days, so sum the previous 5 days
for i=1:7
    @constraint(model, sum(x[j > 0 ? j : 7+j] for j = (i-4):(i)) >= b[i])
    # number of employees can not be negative
    @constraint(model, x[i] >= 0)
end

JuMP.optimize!(model)

println("Required employees: ", b)
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:7
    print(JuMP.value(x[i]), " ")
end
# count the number of employees working each day
println("\nEmployees working each day: ")
for i=1:7
    print(sum(JuMP.value(x[j > 0 ? j : 7+j]) for j = (i-4):(i)), " ")
end
# show unused employee working days
println("\nUnused employees: ")
for i=1:7
    print(sum(JuMP.value(x[j > 0 ? j : 7+j]) for j = (i-4):(i)) - JuMP.value(b[i]), " ")
end
# total unused employee working days
println("\nTotal unused employees: ", sum(sum(JuMP.value(x[j > 0 ? j : 7+j]) for j = (i-4):(i)) - JuMP.value(b[i]) for i=1:7))
print("\n-----------------------------------------------------\n")

# First part of the exercie:
model = Model(GLPK.Optimizer)
# employees needed per day for 7 days
b = [8,8,8,8,8,8,7]



# decision variable for how many employees starts work each day
@variable(model, x[1:7], Int)

# objective function minimize the total number of employees
@objective(model, Min, sum(x[i] for i=1:7))
# objective function minimize the total number of employees, but saturday and sunday cost double
# @objective(model, Min, sum(x[i] for i=1:7) + sum(x[i] for i=2:7) + sum(x[i] for i=3:7))

# constraint for each day, the number of employees needed is less than or equal to the number of employees available
# each employee must work 5 consecutive days, so sum the previous 5 days
for i=1:7
    @constraint(model, sum(x[j > 0 ? j : 7+j] for j = (i-4):(i)) >= b[i])
    # number of employees can not be negative
    @constraint(model, x[i] >= 0)
end

JuMP.optimize!(model)

println("Required employees: ", b)
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i=1:7
    print(JuMP.value(x[i]), " ")
end

println("\nEmployees working each day: ")
for i=1:7
    print(sum(JuMP.value(x[j > 0 ? j : 7+j]) for j = (i-4):(i)), " ")
end
# show unused employee working days
println("\nUnused employees: ")
for i=1:7
    print(sum(JuMP.value(x[j > 0 ? j : 7+j]) for j = (i-4):(i)) - JuMP.value(b[i]), " ")
end
# total unused employee working days
println("\nTotal unused employees: ", sum(sum(JuMP.value(x[j > 0 ? j : 7+j]) for j = (i-4):(i)) - JuMP.value(b[i]) for i=1:7))
