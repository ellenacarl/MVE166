module FuelModel

using JuMP, Gurobi
import ..Data

function build_model(; A_val=Data.A, W_val=Data.W, P_val=Data.P)
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "OutputFlag", 0)

    # Decision variables
    @variable(model, vol[Data.BLEND_I] >= 0)
    @variable(model, ha[Data.CROP_J] >= 0)

    # Objective: Maximize profit
    @objective(model, Max, sum(
        vol[i] * (
            Data.cost[i] - (1 - Data.prop[i]) * Data.cp - (0.2 / 0.9) * Data.prop[i] * Data.cm
        ) for i in Data.BLEND_I)
    )

    # Constraints
    @constraint(model, sum(vol[i] for i in Data.BLEND_I) >= Data.V)  # Total volume
    @constraint(model, c3, sum((1 - Data.prop[i]) * vol[i] for i in Data.BLEND_I) <= P_val)  # Petrol max
    @constraint(model, 
        1000 * sum(Data.yield[j] * Data.oil[j] * ha[j] for j in Data.CROP_J) 
        == (1 / 0.9) * sum(Data.prop[i] * vol[i] for i in Data.BLEND_I)
    )  # Oil requirement
    @constraint(model, c1 ,sum(ha[j] for j in Data.CROP_J) <= A_val)  # Land area
    @constraint(model, c2 ,sum(Data.water[j] * ha[j] for j in Data.CROP_J) <= W_val)  # Water limit

    return model, vol, ha
end

end
