include("data.jl")
include("model.jl")

using .Data
using .FuelModel
using JuMP

model, vol, ha = FuelModel.build_model()
optimize!(model)

println()
println("Termination status: ", termination_status(model))
println("Objective value: ", objective_value(model))
println("Optimal vol: ", value.(vol))
println("Optimal ha: ", value.(ha))