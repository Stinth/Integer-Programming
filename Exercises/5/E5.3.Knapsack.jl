# it means that all items up to and including r-1 fits in the knapsack
# and that the proportion of the r-th item that fits in the knapsack items
# the remaining capacity of the knapsack divided by the weight of the r-th item


# solve the instance
# max 17𝑥1 + 10𝑥2 + 25𝑥3 + 17𝑥4
# s.t. 5𝑥1 + 3𝑥2 + 8𝑥3 + 7𝑥4 ≤ 12
# 𝑥 ∈{0,1}^4

# x1 + x3 ≤ 1
# x3 + x4 ≤ 1
# x1 + x2 + x3 + x4 ≤ 2
# x1 = 0, x2 = 1, x3 = 1, x4 = 0
# value = 10 + 25 = 35
# capacity = 3 + 8 = 11

# with LP relaxation
# x1 = 1/5, x2 = 1, x3 = 1, x4 = 0
# value = 17/5 + 10 + 25 = 38.4
# capacity = 5/5 + 3 + 8 = 12


