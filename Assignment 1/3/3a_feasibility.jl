include("../data.jl") 
include("../model.jl")

using .Data
using .FuelModel
using JuMP


# 3(a)
function min_feasible_limit(param, start_val; step=50)
    val = start_val
    while val > 0
        model, _, _ = FuelModel.build_model(;
            A_val = param == :A ? val : Data.A,
            W_val = param == :W ? val : Data.W,
            P_val = param == :P ? val : Data.P
        )
        optimize!(model)
        if termination_status(model) != MOI.OPTIMAL
            println("Infeasible at $param = $val")
            return val + step
        end
        val -= step
    end
    return 0.0
end

min_A = min_feasible_limit(:A, Data.A)
#min_W = min_feasible_limit(:W, Data.W)
#min_P = min_feasible_limit(:P, Data.P; step = 1000)
