__precompile__(false)

module BlenderPlot

using PyCall
using Colors
using SparseArrays

include("utils/blenders.jl")

include("utils/colors.jl")
include("utils/extensions.jl")
include("utils/pyload.jl")
include("utils/ui.jl")

include("plots/plots.jl")
include("plots/drawings.jl")

end # module
