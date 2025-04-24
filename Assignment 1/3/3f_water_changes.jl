include("../data.jl") 
include("../model.jl")

using Plots
using .Data
using .FuelModel
using JuMP


# 3 (f) water req changes

function tweak_water(; frac = 0.5)
    original_value = copy(Data.water) 
    Data.water .= Data.water .* frac   
    model, vol, ha = FuelModel.build_model()
    optimize!(model)

    # println("Termination status: ", termination_status(model))
    println("Objective value: ", objective_value(model))
    #println("Optimal vol: ", value.(vol))
    println("Optimal ha: ", value.(ha))
    println("original water req $original_value")
    println(Data.water)

    Data.water .= original_value # restore original value

    return objective_value(model), value.(ha)
end

water_levels = 0.2:0.05:2.0
profits = Float64[]
hectares = [] 

for w in water_levels
    profit, ha = tweak_water(; frac = w)
    push!(profits, profit)
    push!(hectares, ha)
end


# Plot profits
p = plot(water_levels, profits,
    xlabel = "fraction of original water requirements",
    ylabel = "Profit",
    title = "Profit vs Water Levels",
    legend = false)

display(p)
#readline()
 

# Plot hectares
soy_ha = [h[1] for h in hectares]  
sun_ha = [h[2] for h in hectares]  
cotton_ha = [h[3] for h in hectares] 

plt = plot(water_levels, soy_ha, label="soy seeds", lw=2, xticks=0.2:0.1:2.0)
plot!(water_levels, sun_ha, label="sunflower seeds", lw=2)
plot!(water_levels, cotton_ha, label="cotton flowers", lw=2,
    xlabel = "fraction of original water requirements",
    ylabel = "Hectares",
    title = "Crop hectares vs Water requirements")

display(plt)
readline()