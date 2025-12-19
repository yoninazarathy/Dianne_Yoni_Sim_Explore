
using DataFrames
using StatsBase
using Distributions
using Random
include("Sim_function.jl")
Random.seed!(1)

#Set transmission parameters
α = 0.28
β = 0.0625
γ = 0.167

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

states0 = DataFrame(
        S = [990.0, 985.0, 980.0, 975.0, 970.0],
        E = [5.0,   7.0,   9.0,   11.0,  13.0],
        I = [3.0,   4.0,   5.0,   6.0,   7.0],
        R = [2.0,   4.0,   6.0,   8.0,   10.0]
    )


