#__precompile__()

module BlenderPlot

using PyCall
using Colors

include("utils/blenders.jl")

include("utils/colors.jl")
include("utils/extensions.jl")
include("utils/pyload.jl")
include("utils/ui.jl")

include("plots/plot.jl")

end # module
