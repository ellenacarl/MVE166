include("../data.jl") 
include("../model.jl")

using Plots
using .Data
using .FuelModel
using JuMP

 
# 3(b)
function sensitivity_test(param; start_val, end_val, step=1)
    profits = Float64[]  # profits
    values = Float64[]   # parameter values

    for val in start_val:step:end_val
        model, _, _ = FuelModel.build_model(
            A_val = param == :A ? val : Data.A,
            W_val = param == :W ? val : Data.W,
            P_val = param == :P ? val : Data.P,
        )
        optimize!(model)
        
        push!(profits, objective_value(model))
        push!(values, val) 
    end

    gain = (profits[2] - profits[1])/(values[2]-values[1])
    println("marginal gain of $param: $gain")

    # Plotting
    # p = plot(values, profits, xlabel="$param", ylabel="Profit", label="Profit vs $param", lw=2, title="Sensitivity of Profit to $param")
    # display(p)
    # readline()
    return values, profits
end

values_A, profits_A = sensitivity_test(:A; start_val=Data.A, end_val=Data.A + 10)
#values_W, profits_W = sensitivity_test(:W; start_val=Data.W, end_val=Data.W + 10)
#values_P, profits_P = sensitivity_test(:P; start_val=Data.P, end_val=Data.P + 10)


#Dual variables
model, _, _ = FuelModel.build_model()
optimize!(model)

# Get duals for the limiting constraints
dual_A = shadow_price(model[:c1])
dual_W = shadow_price(model[:c2])
dual_P = shadow_price(model[:c3])

println("Shadow price - area = $dual_A")
println("Shadow price - water = $dual_W")
println("Shadow price - petrol = $dual_P")
