include("../data.jl") 
include("../model.jl")

using .Data
using .FuelModel
using JuMP

model, _, ha = FuelModel.build_model()
optimize!(model)

println("Reduced cost for sunflower seed:", JuMP.reduced_cost(ha[2]))

# 3(c)

function tweak_sunflower(data_cat; factor=1.0)
    
    data_vec = getproperty(Data, data_cat)
    original_value = copy(data_vec[2]) # backup the original data

    data_vec[2] *= factor

    model, _, ha = FuelModel.build_model()
    optimize!(model)
    planted = value(ha[2])

    data_vec[2] = original_value # restore original value

    return planted
end

for f in 1.45:0.005:1.5
    planted = tweak_sunflower(:yield; factor=f)
    if planted > 1e-6  
        println("Sunflower is planted when yield is scaled by factor = $f. Then $planted ha is planted")
        break
    end
end

# for f in 1.45:0.005:1.5
#     planted = tweak_sunflower(:oil; factor=f)
#     if planted > 1e-6  
#         println("Sunflower is planted when oil is scaled by factor = $f. Then $planted ha is planted")
#         break
#     end
# end

# for f in 1.0:-0.05:0.0
#     planted = tweak_sunflower(:water; factor=f)
#     if planted > 1e-6  
#         println("Sunflower is planted when water is scaled by factor = $f. Then $planted ha is planted")
#         break
#     end
# end