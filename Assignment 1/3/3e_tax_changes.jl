include("../data.jl") 
include("../model.jl")

using Plots
using .Data
using .FuelModel
using JuMP


# 3 (e) tax-changes

function tweak_tax(blend_idx; new_val = 0.5)
    original_value = copy(Data.cost)  # save original values
    Data.cost[blend_idx] = Data.cost_ex_tax[blend_idx] * new_val
   
    model, vol, ha = FuelModel.build_model()
    optimize!(model)

    # println("Termination status: ", termination_status(model))
    println("Objective value: ", objective_value(model))
    println("Optimal vol: ", value.(vol))
    # println("Optimal ha: ", value.(ha))
    println("original costs $original_value")

    Data.cost = original_value # restore original value

    return objective_value(model), value.(vol)
end

tax_levels = 0.0:0.05:1.0
profits = Float64[]
volumes = []
blend_idx = 1

for v in tax_levels
    profit, vol = tweak_tax(blend_idx; new_val = v)
    push!(profits, profit)
    push!(volumes, vol)
end


# Plot profits
p = plot(tax_levels, profits,
    xlabel = "Tax multiplier for blend $blend_idx",
    ylabel = "Profit",
    title = "Profit vs Tax Level for Blend $blend_idx",
    legend = false)

display(p)
#readline()


# Plot volumes
b1_vol = [v[1] for v in volumes]  # Blend 1
b2_vol = [v[2] for v in volumes]  # Blend 2
b3_vol = [v[3] for v in volumes]  # Blend 3

plt = plot(tax_levels, b1_vol, label="B5", lw=2, xticks=0.0:0.1:1.0)
plot!(tax_levels, b2_vol, label="B30", lw=2)
plot!(tax_levels, b3_vol, label="B100", lw=2,
    xlabel = "Tax multiplier for blend $blend_idx",
    ylabel = "Volume",
    title = "Blend Volumes vs Tax Level")

display(plt)
readline()