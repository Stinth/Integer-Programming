using JuMP
using GLPK

# First part of the exercie:
model = Model(GLPK.Optimizer)
# there are 9 courses per day for 5 days, this is the preference per courses
preference = [5 6 1 4 8;
              3 7 1 6 4;
              2 8 5 1 7;
              1 3 4 2 6;
              4 5 2 3 1;
              6 1 3 5 2;
              7 2 6 3 5;
              8 4 7 5 1;
              1 2 3 4 5;]

# binary decision variable for which courses are taken
@variable(model, x[1:9,1:5], Bin)

# maximize the preferable courses taken
@objective(model, Max, sum(preference[i,j]*x[i,j] for i in 1:9 for j in 1:5))

# four courses must be taken per day
for i in 1:5
    @constraint(model, sum(x[j,i] for j in 1:9) == 4)
end

JuMP.optimize!(model)
# print the solution
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i in 1:9
    for j in 1:5
        print(JuMP.value(x[i,j]), " ")
    end
    println()
end
print("\n-----------------------------------------------------\n")

# Second part of the exercie:
model = Model(GLPK.Optimizer)
# there are 9 courses per day for 5 days, this is the preference per courses
preference = [5 6 1 4 8;
              3 7 1 6 4;
              2 8 5 1 7;
              1 3 4 2 6;
              4 5 2 3 1;
              6 1 3 5 2;
              7 2 6 3 5;
              8 4 7 5 1;
              1 2 3 4 5;]


# binary decision variable for which courses are taken
@variable(model, x[1:9,1:5], Bin)

# maximize the preferable courses taken
@objective(model, Max, sum(preference[i,j]*x[i,j] for i in 1:9 for j in 1:5))

# four courses must be taken per day
for i in 1:5
    @constraint(model, sum(x[j,i] for j in 1:9) == 4)
end

# for each day there can a maximum of 2 consecutive courses taken in a row
for i in 1:5
    for j in 1:9
        @constraint(model, sum(x[j,i] for j in j:min(j+2,9)) <= 2)
    end
end



JuMP.optimize!(model)
# print the solution
println("Without more than 2 consecutive courses:")
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i in 1:9
    for j in 1:5
        print(JuMP.value(x[i,j]), " ")
    end
    println()
end
println("\n-----------------------------------------------------\n")

# Second part of the exercie:
model = Model(GLPK.Optimizer)
# there are 9 courses per day for 5 days, this is the preference per courses
preference = [5 6 1 4 8;
              3 7 1 6 4;
              2 8 5 1 7;
              1 3 4 2 6;
              4 5 2 3 1;
              6 1 3 5 2;
              7 2 6 3 5;
              8 4 7 5 1;
              1 2 3 4 5;]

penalty = [9,8,7,6,5,4,3,2,1]

# binary decision variable for which courses are taken
@variable(model, x[1:9,1:5], Bin)

# maximize the preferable courses taken
@objective(model, Max, sum(preference[i,j]*x[i,j] - penalty[i]*x[i,j] for i in 1:9 for j in 1:5))

# four courses must be taken per day
for i in 1:5
    @constraint(model, sum(x[j,i] for j in 1:9) == 4)
end

# for each day there can a maximum of 2 consecutive courses taken in a row
for i in 1:5
    for j in 1:9
        @constraint(model, sum(x[j,i] for j in j:min(j+2,9)) <= 2)
    end
end



JuMP.optimize!(model)
# print the solution
println("Without more than 2 consecutive courses and early start penalty:")
println("The penalty scales from first hour till last hour:")
for i in 1:9
    print(penalty[i], " ")
end
println("\nObjective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i in 1:9
    for j in 1:5
        print(JuMP.value(x[i,j]), " ")
    end
    println()
end
println("\n-----------------------------------------------------\n")

