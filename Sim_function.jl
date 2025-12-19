function do_sim(W, states0, α, β, γ)
    #Define vector of states
    states = Vector{DataFrame}(undef, Tmax + 1)
    N = Vector{Float64}(undef, 5)
    Δ = zeros(Int, D, D, 4) 
    new_E = Vector{Float64}(undef, 5)
    new_I = Vector{Float64}(undef, 5)
    new_R = Vector{Float64}(undef, 5)

    #Initialize SEIR states
    states[1] = states0

    #Initialize time and set Tmax
    t = 1

    while t < Tmax
        #Set state for i = 1
        for i in 2:D
            N[i] = states[t].S[i] + states[t].E[i] + states[t].I[i] + states[t].R[i]
            new_E[i] = rand(Binomial(10,0.5))#α * states[t].S[i] * states[t].I[i] / N[i]
            new_I[i] = rand(Binomial(qq,qqq))#γ * states[t].E[i]
            new_R[i] = rand(Binomial(qq,qqq))#β * states[t].I[i]
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
        t += 1   
    end
end #End of do_sim function