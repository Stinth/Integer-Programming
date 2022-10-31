using Random
# using Cairo
using Plots
using StatsBase
using Graphs
using GraphPlot
using SplitApplyCombine
using Cairo
using Compose
include("visualize_problem.jl")
# Produciton planning

# number of products n
n = 4

# number of machines m, m must be less than n
m = 3

# array of operations o_ik, there are n products and m jobs per product
o = transpose(reshape(repeat(collect(range(1, stop = m)), n), m, n))

# array of processing time p_ik for each operation 
# p = rand(1:10, n, m)

p = [3 7 9;
    7 10 2;
    3 4 4;
    5 5 6]

# array d_ij determining the machine for each operation per job
# d = transpose(reshape([shuffle(collect(range(1,5)));shuffle(collect(range(1,5)));shuffle(collect(range(1,5)));shuffle(collect(range(1,5)));shuffle(collect(range(1,5)));], m, n))
# (job, operation)
d = [1 2 3;
    2 1 3;
    3 2 1;
    1 3 2]

# (job, machine)




# array t_ij determining the start time of each operation o_ij

println("Question 8:")

# array y_ikjl determining if operation o_ik is performed before operation o_jl
# if and only if operation o_ik is performed before operation o_jl then y_ikjl = 1
# when it holds that d_ik = d_jl

# the constraints will look like this

println("t_ik + p_ik <= t_jl * y_ikjl")
println("and")
println("t_jl + p_jl <= t_ik * y_iljk")
# this will mean if y_ikjl then the start time of operation o_ik must be before the start time of operation o_jl
# and the start time of o_jl must be after the start time of o_ik + the processing time p_ik of o_ik


println("Question 9:")
println("File output.")
subscript(x,i,j) = x * Char(0x2080 + i) * Char(0x2080 + j)
# g = SimpleGraph(n*m + 2)
s = n*m + 1
t = n*m + 2

node_labels = []
for i in 1:n
    for j in 1:m
        push!(node_labels, subscript("o", i, j))
    end    
end
node_labels = [node_labels; "s"; "t"]
loc_x = Vector{Float64}([2,0,6, 2,4,8, 6,0,2, 4,8,2, -2,11])
loc_y = Vector{Float64}([0,4,3, 4,0,3, 5,6,2, 2,5,6, 2.5,2.5])
visualize_problem(d, n, m, loc_x, loc_y, node_labels, "Assignment/Question9_graph.png")

println("Question 10:")
function find_max_length(production_order, max_job = zeros(n), max_machine = zeros(m))
    if production_order == []
        return max_job, max_machine
    end
    current = popfirst!(production_order)
    # we sort it to ensure that earliest procedure of an order is produced first
    current = sort(current, by=current->current[2])
    for (job, procedure, machine) in current
        start_time = min(max_job[job], max_machine[machine])
        max_job[job] = start_time + p[job, procedure]
        max_machine[machine] = start_time + p[job, procedure]
    end
    println("Sorted current: ", current)
    println(max_job, max_machine)
    find_max_length(production_order, max_job, max_machine)
end

# product order for each machine
production_order = [[(1,1),(2,2),(3,3),(4,1)],
                    [(1,2),(2,1),(3,2),(4,3)],
                    [(1,3),(2,3),(3,1),(4,2)]]

# (job, procedure, machine)                    
production_order = [[(1,1,1), (2,1,2), (3,1,3)],
                    [(4,1,1), (1,2,2), (4,2,3)],
                    [(2,2,1), (3,2,2), (2,3,3)],
                    [(3,3,1), (4,3,2), (1,3,3)]]

# production_order = [[(1,1),(2,1),(3,1)],
#                     [(4,1),(1,2),(4,2)],
#                     [(2,2),(3,2),(2,3)],
#                     [(3,3),(4,3),(1,3)]]
println("Question 11:")
println("The maximum length of the production order is: ", find_max_length(copy(production_order)))



g = DiGraph(n*m + 2)
s = n*m + 1
t = n*m + 2

node_labels = []
colors = []
for i in 1:n
    for j in 1:m
        push!(node_labels, subscript("o", i, j))
        if j == 1
            add_edge!(g, s, (i-1)*m + j)
            push!(colors, colorant"limegreen")
        end
        if j == 3
            add_edge!(g, (i-1)*m + j, t)
            push!(colors, colorant"limegreen")
        end
        if j < m
            add_edge!(g, (i-1)*m + j, (i-1)*m + j + 1)
            push!(colors, colorant"red")
        end
    end    
end
node(i,j) = (i-1)*m + j
# machine 1
add_edge!(g, node(1,1), node(4,1))
add_edge!(g, node(4,1), node(2,2))
add_edge!(g, node(2,2), node(3,3))
# machine 2
add_edge!(g, node(2,1), node(1,2))
add_edge!(g, node(1,2), node(3,2))
add_edge!(g, node(3,2), node(4,3))
# machine 3
add_edge!(g, node(3,1), node(4,2))
add_edge!(g, node(4,2), node(2,3))
add_edge!(g, node(2,3), node(1,3))


node_labels = [node_labels; "s"; "t"]
loc_x = Vector{Float64}([2,0,6, 2,4,8, 6,0,2, 4,8,2, -2,11])
loc_y = Vector{Float64}([0,4,3, 4,0,3, 5,6,2, 2,5,6, 2.5,2.5])

s_t_edge_color = colorant"limegreen"
job_edge_color = colorant"orange"
machine_edge_color = colorant"red4"

colors = [job_edge_color for i in  1:ne(g)]
colors[end-4:end] = [s_t_edge_color for i in  1:5]
colors[end-5] = machine_edge_color
colors[end-7] = machine_edge_color
colors[end-9] = s_t_edge_color
colors[end-11] = machine_edge_color
colors[end-13] = machine_edge_color
colors[end-14] = s_t_edge_color
colors[end-17] = machine_edge_color
colors[end-18] = machine_edge_color
colors[end-20] = s_t_edge_color
colors[end-22] = machine_edge_color
colors[end-24] = machine_edge_color
# colors[end-25] = colorant"white"
gplot(g, loc_x, loc_y, nodelabel=node_labels, edgestrokec=colors)

# this one is honestly more clear
gplot(g, nodelabel=node_labels, edgestrokec=colors)
# draw(PNG("Assignment/Q11.png", 16cm, 16cm), gplot(g, nodelabel=node_labels, edgestrokec=colors))


println("Question 12:")
# un-ordered schedule for each machine
machine_schedule = [[(1,1,1), (2,2,1), (3,3,1), (4,1,1)],
                    [(1,2,2), (2,1,2), (3,2,2), (4,3,2)],
                    [(1,3,3), (2,3,3), (3,1,3), (4,2,3)]]

function greedy_heuristic(machine_schedule)
    for schedule in machine_schedule
        schedule = sort!(schedule, by=schedule->schedule[2])
    end
    return machine_schedule
end
# show input
println("Input:")
for schedule in machine_schedule
    println(schedule)
end
# show output
println("Output:")
greedy_schedule = greedy_heuristic(copy(machine_schedule))
for schedule in greedy_schedule
    println(schedule)
end
println("We simply sort the schedule for each machine by the procedure number.")
# the max length of this schedule is
greedy_schedule_T = invert(greedy_schedule)
println("The maximum length of this schedule is: ", find_max_length(greedy_schedule_T))

[[3,7,3],
[5,7,5],
[10,4,9],
[4,6,2]]