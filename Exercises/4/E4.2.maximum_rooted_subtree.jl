H = zeros(12)
H[4] = max(0,4)
H[9] = max(0,2)
H[10] = max(0,3)
H[6] = max(0,-1)
H[7] = max(0,-1)
H[11] = max(0,-2)
H[12] = max(0,3)

H[5] = max(0,-6+H[9]+H[10])
H[8] = max(0,1+H[11]+H[12])

H[2] = max(0,-1+H[4]+H[5]+H[6])
H[3] = max(0,-1+H[7]+H[8])

H[1] = max(0,-2+H[2]+H[3])

# print largest value along with index in H
println("The largest value is: ", maximum(H))
println("The index of the largest value is: ", findmax(H))
# maximum weighted rooted subtree must include the root node 1
# and can branch down to any of the other nodes that increase its value
# so the maximum weighted subtree contains the nodes
# 1, 2, 3, 4, 8, 12
