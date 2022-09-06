using JuMP
using GLPK

model = Model(GLPK.Optimizer)

# Nasa capital budget model table
missions = [6 0 0 0 0 200;
            2 3 0 0 0 3;
            3 5 0 0 0 20;
            0 0 0 0 10 50;
            0 5 8 0 0 70;
            0 0 1 8 4 20;
            1 8 0 0 0 5;
            0 0 0 5 0 10;
            4 5 0 0 0 200;
            0 8 4 0 0 150;
            0 0 2 7 0 18;
            5 7 0 0 0 8;
            0 1 4 1 1 300;
            0 4 5 3 3 185;]

budget = [10 12 14 14 14]

# binary decision variable for which mission is chosen
@variable(model, x[1:14], Bin)

# maximize the value of missions chosen
@objective(model, Max, sum(missions[i,6]*x[i] for i in 1:14))

# for each 1 of 5 years mission yearly spend can not exceed budget
for i in 1:5
    @constraint(model, sum(missions[j,i]*x[j] for j in 1:14) <= budget[i])
end

# missions 4 and 5 are incompatible
@constraint(model, x[4] + x[5] <= 1)

# missions 8 and 9 are incompatible
@constraint(model, x[8] + x[9] <= 1)

# missions 11 and 14 are incompatible
@constraint(model, x[11] + x[14] <= 1)

# mission 4 to 7 are dependent on mission 3
@constraint(model, x[4] + x[5] + x[6] + x[7] <= 5*x[3])

# mission 11 is dependent on mission 2
@constraint(model, x[11] <= 2*x[2])

JuMP.optimize!(model)
# print the solution
println("Objective is: ", JuMP.objective_value(model))
println("Solution is: ")
for i in 1:14
    println("Mission ", i, " ", JuMP.value(x[i]))
end