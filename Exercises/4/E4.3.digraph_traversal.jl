using JuMP
using GLPK

model = Model(GLPK.Optimizer)
n = 10

r = [3,4,5,1,2,3,0,1,3,5]
# 10x10 matrix of random values between 1 and 15 rand(1:15, n, n)
c = [3   3  11  11  11   8   7  12   2  12;
    3  15  12   7  15   4   2  12   2   3;
    5   6  11   3   1   6   9   9   3  14;
    8   9  13  10   6  11  10  13   1   5;
    13   2   2   2  15  14   3  14   1  13;
    4   1  14  14  14  15   6   2  10   4;
    15  12  10  10   2  15   2  10   6  14;
    15   4   3   2  11   4  14   8  12  14;
    3   5   7   4   2  13  15   6   4  12;
    14   1  13   6   7   7  10   7  13  11]
M = 100

# decision variables continous defining what time a node is visited
@variable(model, t[1:n] >= 0)

# decision variable binary defining if an edge is used
@variable(model, x[1:n, 1:n], Bin)

# minimize t10
@objective(model, Min, t[n])

# only one edge can leave node 1
@constraint(model, sum(x[1, i] for i in 2:n) == 1)

# only one edge can enter node n
@constraint(model, sum(x[i, n] for i in 1:n-1) == 1)

# either no arc enters or leaves a node, or exactly one arc enters and one arc leaves
for i in 2:n-1
    @constraint(model, sum(x[i, j] for j in 1:n) - sum(x[j, i] for j in 1:n) == 0)
end

# a node j can only be visited after time rj
for j in 1:n
    @constraint(model, t[j] >= r[j])
end

# the time a node is visited is the time the previous node is visited plus the cost of the arc
for i in 1:n
    for j in 1:n
        @constraint(model, t[j] >= t[i] + c[i, j] * x[i, j] - (1 - x[i, j]) * M)
    end
end

# optimize!(model)
# # print the optimal value
# println("The optimal value is: ", objective_value(model))
# # print the optimal solution
# println("The optimal solution is: ", value.(t))
# # print the path
# println("The path is: ")
# for i in 1:n
#     for j in 1:n
#         if value.(x[i, j]) == 1
#             println(i, " -> ", j)
#         end
#     end
# end