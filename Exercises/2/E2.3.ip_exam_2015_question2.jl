using JuMP
using GLPK
# termination_status(model)
model = Model(GLPK.Optimizer)

demand = [5 6 7 1 8;
          0 1 1 3 9]


demand = [1 6 10 15 9;
         0 3 1 7 9]

init_cost = [20 30]

prod_limit = [60 35]

storage_cost = [2 3 5 1 4;
                7 7 2 3 5]

# binary decision variable for which product is being produced per day
@variable(model, x[1:2,1:5], Bin)

# continuous decision variable for how much of the product is being produced
@variable(model, y[1:2,1:5] >=0, Int)

# continous decision variable for how many units there were stored from the previous day, day 1 is 0
@variable(model, z[1:2,1:6] >= 0, Int)

# minimize the total cost of producing the products
@objective(model, Min, sum(init_cost[i]*x[i,j] for i in 1:2 for j in 1:5) + sum((z[i,j] + y[i,j] - demand[i,j])*storage_cost[i,j] for i in 1:2 for j in 1:5))

# the amount of product produced must not exceed the production limit and only if machine is turned on
for i in 1:2
    for j in 1:5
        @constraint(model, y[i,j] <= prod_limit[i]*x[i,j])
    end
end

# the amount of product stored is the amount of product produced plus the amount of product stored from the previous day minus the amount of demand
# for day one storage is 0
for i in 1:2
    @constraint(model, z[i,1] == 0)
    @constraint(model, z[i,6] == 0)
end
for i in 1:2
    for j in 1:5
        @constraint(model, z[i,j+1] == z[i,j] + y[i,j] - demand[i,j])
    end
end

# demand must be met
for i in 1:2
    for j in 1:5
        @constraint(model, y[i,j] + z[i,j] >= demand[i,j])
    end
end

# it is only possible to produce one type of product per day
for j in 1:5
    @constraint(model, sum(x[i,j] for i in 1:2) <= 1)
end

JuMP.optimize!(model)
# print the solution
println("Objective is: ", JuMP.objective_value(model))
println("Products being produced is: ")
for i=1:2
    for j=1:5
        print(JuMP.value(x[i,j]), " ")
    end
    println()
end
println("Produced quantity of units: ")
for i=1:2
    for j=1:5
        print(JuMP.value(y[i,j]), " ")
    end
    println()
end
println("Stored units: ")
for i=1:2
    for j=1:6
        print(JuMP.value(z[i,j]), " ")
    end
    println()
end
println("Initial start-up costs :")
for i=1:2
    for j=1:5
        print(JuMP.value(x[i,j])*init_cost[i], " ")
    end
    println()
end
println("Storage cost :")
for i=1:2
    for j=1:5
        print((JuMP.value(z[i,j]) + JuMP.value(y[i,j]) - demand[i,j])*storage_cost[i,j], " ")
    end
    println()
end
println("\n-----------------------------------------------------\n")


# Quesiton 2.2 - The following code is the same as the previous code but with the addition that initial cost is only paid once
# This part is not working
model = Model(GLPK.Optimizer)

demand = [5 6 7 1 8;
          0 1 1 3 9]


demand = [1 6 10 15 9;
         0 3 1 7 9]

init_cost = [20 30]

prod_limit = [60 35]

storage_cost = [2 3 5 1 4;
                7 7 2 3 5]

# binary decision variable for which product is being produced per day
@variable(model, x[1:2,1:5], Bin)

# continuous decision variable for how much of the product is being produced
@variable(model, y[1:2,1:5] >=0, Int)

# continous decision variable for how many units there were stored from the previous day, day 1 is 0
@variable(model, z[1:2,1:6] >= 0, Int)

# binary decision variable for how many times the production switches from one product to another
@variable(model, a[1:2,1:5], Bin)

# minimize the total cost of producing the products
@objective(model, Min, sum(init_cost[i]*a[i,j] for i in 1:2 for j in 1:5) + sum((z[i,j] + y[i,j] - demand[i,j])*storage_cost[i,j] for i in 1:2 for j in 1:5))

# the amount of product produced must not exceed the production limit and only if machine is turned on
for i in 1:2
    for j in 1:5
        @constraint(model, y[i,j] <= prod_limit[i]*x[i,j])
    end
end

# the amount of product stored is the amount of product produced plus the amount of product stored from the previous day minus the amount of demand
# for day one storage is 0
for i in 1:2
    @constraint(model, z[i,1] == 0)
    @constraint(model, z[i,6] == 0)
end
for i in 1:2
    for j in 1:5
        @constraint(model, z[i,j+1] == z[i,j] + y[i,j] - demand[i,j])
    end
end

# demand must be met
for i in 1:2
    for j in 1:5
        @constraint(model, y[i,j] + z[i,j] >= demand[i,j])
    end
end

# it is only possible to produce one type of product per day
for j in 1:5
    @constraint(model, sum(x[i,j] for i in 1:2) <= 1)
end

# constraint if x is one and the previous x is not one for both products then a must be one
@constraint(model, [i = 1:2, j = 2:5], a[i,j] >= x[i,j] - x[i,j-1])

# copy first day machine activation
@constraint(model, [i = 1:2], a[i,1] == x[i,1])




JuMP.optimize!(model)
# print the solution
println("Objective is: ", JuMP.objective_value(model))
println("Products being produced is: ")
for i=1:2
    for j=1:5
        print(JuMP.value(x[i,j]), " ")
    end
    println()
end
println("Initial cost paid: ")
# for i=1:2
#     print(JuMP.value(a[i]), " ")
#     println()
# end
for i=1:2
    for j=1:5
        print(JuMP.value(a[i,j]), " ")
    end
    println()
end
println("Produced quantity of units: ")
for i=1:2
    for j=1:5
        print(JuMP.value(y[i,j]), " ")
    end
    println()
end
println("Stored units: ")
for i=1:2
    for j=1:6
        print(JuMP.value(z[i,j]), " ")
    end
    println()
end
println("Initial start-up costs :")
for i=1:2
    for j=1:5
        print(JuMP.value(x[i,j])*init_cost[i], " ")
    end
    println()
end
println("Storage cost :")
for i=1:2
    for j=1:5
        print((JuMP.value(z[i,j]) + JuMP.value(y[i,j]) - demand[i,j])*storage_cost[i,j], " ")
    end
    println()
end


