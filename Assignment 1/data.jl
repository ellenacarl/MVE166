module Data

# Sets
const BLEND_I = 1:3
const CROP_J = 1:3

# Labels
const BLEND = ["B5", "B30", "B100"]
const CROP = ["Soy", "Sunflower", "Cotton"]

# Parameters
const cost_ex_tax = [1.43, 1.29, 1.16]
const tax = [0.8, 0.95, 1]
const cost = cost_ex_tax .* tax
const prop = [0.05, 0.3, 1.0]

const yield = [2.6, 1.4, 0.9]
const oil = [0.178,0.216, 0.433]
const water = [5.0, 4.2, 1.0]

const cp = 1.0  
const cm = 1.5
const A = 1600
const W = 5000
const V = 280000
const P = 150000

end
