function arrow0!(x, y, u, v; as=0.07, width=3, lc=:red, la=5)  # by @rafael.guerra
    if as < 0
        quiver!([x],[y],quiver=([u],[v]), lc=lc, la=la)  # NB: better use quiver directly in vectorial mode
    else
        nuv = sqrt(u^2 + v^2)
        v1, v2 = [u;v] / nuv,  [-v;u] / nuv
        v4 = (3*v1 + v2)/3.1623  # sqrt(10) to get unit vector
        v5 = v4 - 2*(v4'*v2)*v2
        v4, v5 = as*nuv*v4, as*nuv*v5
        # plot outline
        real_u, real_v = copy(u), copy(v)
        u,v = u*0.7, v*0.7
        # plot!([x,x+real_u], [y,y+real_v], lc=:black,la=la, width=width+2)
        # plot!([x+u,x+u-v5[1]], [y+v,y+v-v5[2]], lc=:black, la=la, width=width+2)
        # plot!([x+u,x+u-v4[1]], [y+v,y+v-v4[2]], lc=:black, la=la, width=width+2)
        # plot arrow
        plot!([x,x+real_u], [y,y+real_v], lc=lc,la=la, width=width, primary=false)
        plot!([x+u,x+u-v5[1]], [y+v,y+v-v5[2]], lc=lc, la=la, width=width, primary=false)
        plot!([x+u,x+u-v4[1]], [y+v,y+v-v4[2]], lc=lc, la=la, width=width, primary=false)
    end
end

function visualize_problem(d, n, m, loc_x, loc_y, node_labels, filename)
    # plot undirected lines for each machine
    plot()
    # undirected edges between operations on the same machine
    for i in 1:m
        index = [d[1,i], 3 + d[2,i], 6 + d[3,i], 9 + d[4,i], d[1,i], 6 + d[3,i], 3 + d[2,i], 9 + d[4,i]]
        plot!(loc_x[index], loc_y[index], lc=:orange, la=5, width=3)
    end

    # directed edge from s to each jobs first operation and from each jobs last operation to t
    for i in 1:n
        start_x = loc_x[13]
        start_y = loc_y[13]
        end_x = loc_x[(i-1)*3+1]
        end_y = loc_y[(i-1)*3+1]
        arrow0!(start_x, start_y, end_x - start_x, end_y - start_y, lc=:limegreen, la=5, width=3)
    end
    for i in 1:n
        start_x = loc_x[(i-1)*3+3]
        start_y = loc_y[(i-1)*3+3]
        end_x = loc_x[14]
        end_y = loc_y[14]
        arrow0!(start_x, start_y, end_x - start_x, end_y - start_y, lc=:limegreen, la=5, width=3)
    end

    # directed arrows defining each job order
    for i in 1:n
        base = (i-1)*3+1
        xs = loc_x[base:base+2]
        ys = loc_y[base:base+2]
        for j in 1:m-1
            arrow0!(xs[j], ys[j], xs[j+1]-xs[j], ys[j+1]-ys[j], as=0.08, lc=:red4, la=5, width=3)
        end
    end



    plot!(loc_x, loc_y, seriestype=:scatter, legend=false, mc=:deepskyblue3, markersize=25,
            xlims=(-3,12), ylims=(-1,7), grid=false, size=(800,800), axis=false, ticks=nothing)

    for (x,y,label) in zip(loc_x, loc_y, node_labels)
        annotate!(x, y, text(label, :black, 15))
    end

    plot!()
    savefig(filename)
end
