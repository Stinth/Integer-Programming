# Consider the instance of the Uncapacitated Facility Location Problem with 𝑚 = 6 clients, 𝑛 = 4 depots and costs:
m = 6
n = 4
c = [6 2 3 4;
     1 9 4 11;
     15 2 6 3;
     9 11 4 8;
     7 23 2 9;
     4 3 1 5]
f = [21 16 11 24]
# Apply a greedy heuristic to the given instance
# Add the cost of opening a depot to the cost of serving a client
c.+f = [27 18 14 28;
        22 25 15 35;
        36 18 17 27;
        33 35 15 32;
        31 44 13 33;
        25 18 12 29]
# Now pick the cheapest depot for each client
# The cheapest depot for client 1 is depot 3
# The cheapest depot for client 2 is depot 3
# The cheapest depot for client 3 is depot 3
# The cheapest depot for client 4 is depot 3
# The cheapest depot for client 5 is depot 3
# The cheapest depot for client 6 is depot 3
# So the total cost is 14 + 15 + 17 + 15 + 13 + 12 = 86
# But we would only need to open a depot once
# So the total cost is 3 + 4 + 6 + 4 + 2 + 1 + 11 = 31
# All clients are served by depot 3 using this greedy heuristic
# This greedy heuristic is a way to find out if a opening a depot just to serve a single client would ever be a good idea