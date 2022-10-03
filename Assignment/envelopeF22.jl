using JuMP
using GLPK

mo = Model(GLPK.Optimizer)

# Model for the envelope problem / Project assignment 2022

# N is equal to the number of items and the array size contains
# the size of each of the items
N = 10
size = [156 168 178 180 185 203 207 261 277 290]

# Max number of different envelopes is given by S
S = 3

# Set A for "big M" notation as s^2 where s is the largest size
A = 290*290

mo = Model(GLPK.Optimizer)

# Define the variables of the model
@variable(mo, x[1:N,1:S], Bin)
@variable(mo, a[1:S]>=0)

# Assignment constraint
@constraint(mo, [i=1:N], sum(x[i,j] for j=1:S) == 1)


JuMP.optimize!(mo)

if (JuMP.termination_status(mo)==MOI.OPTIMAL)
    # print out the values of the optimal solution
    for i=1:N
        for j=1:S
            println("x(", i, ",", j, ") is ", JuMP.value(x[i,j]), " and y(", i, ",", j, ") is ", JuMP.value(y[i,j]))
        end
    end

    println("Målfunktion ", JuMP.objective_value(mo))
else
    println("Optimize was not succesful. Return code", JuMP.termination_status(mo))
end
