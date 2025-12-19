
using DataFrames
using StatsBase

#Set parameters
D = 5 #Number of locations
Tmax = 10

# Set Travel Network, TN
W = zeros(D, D) #Assume five locations for simplicity

values = Dict(
    (1,2) => 2,
    (2,4) => 7,
    (3,4) => 8,
    (4,5) => 9
)

for ((i, j), v) in values
    W[i, j] = v
    W[j, i] = v
end

#Define vector of states
states = Vector{DataFrame}(undef, Tmax + 1)
N = Vector{Float64}(undef, 5)
Δ = zeros(Int, D, D, 4) 
new_E = Vector{Float64}(undef, 5)
new_I = Vector{Float64}(undef, 5)
new_R = Vector{Float64}(undef, 5)

#Initialize SEIR states
states[1] = DataFrame(
    S = [990.0, 985.0, 980.0, 975.0, 970.0],
    E = [5.0,   7.0,   9.0,   11.0,  13.0],
    I = [3.0,   4.0,   5.0,   6.0,   7.0],
    R = [2.0,   4.0,   6.0,   8.0,   10.0]
)

#Set transmission parameters
α = 0.28
β = 0.0625
γ = 0.167

#Initialize time and set Tmax
t = 1

while t < Tmax
    #Set state for i = 1
    for i in 2:D
        N[i] = states[t].S[i] + states[t].E[i] + states[t].I[i] + states[t].R[i]
        new_E[i] = α * states[t].S[i] * states[t].I[i] / N[i]
        new_I[i] = γ * states[t].E[i]
        new_R[i] = β * states[t].I[i]
        states[t+1].S[i] = states[t].S[i] - new_E[i]
        states[t+1].E[i] = states[t].E[i] + new_E[i] - new_I[i]
        states[t+1].I[i] = states[t].I[i] + new_I[i] - new_R[i]
        states[t+1].R[i] = states[t].R[i] + new_R[i]
    end

    for i in 2:D
        #Temporary vector X
        X = vcat(
            fill(:S, round(Int, states[t].S[i])),
            fill(:E, round(Int, states[t].E[i])),
            fill(:I, round(Int, states[t].I[i])),
            fill(:R, round(Int, states[t].R[i]))
        )
        for j in 2:D
            if W[i, j] != 0
                #Sample without replacement
                idx = sample(1:length(X), W[i, j]; replace=false)
                x = X[idx]
                deleteat!(X, sort(idx; rev=true))

                #Count SEIR symbols
                for xi in x
                    if xi === :S
                        Δ[i, j, 1] += 1
                    elseif xi === :E
                        Δ[i, j, 2] += 1
                    elseif xi === :I
                        Δ[i, j, 3] += 1
                    elseif xi === :R
                        Δ[i, j, 4] += 1
                    end
                end
            end
        end
    end
    for i in 2:D
        for j in 2:D
            #
        end
    end
    t += 1   
end

