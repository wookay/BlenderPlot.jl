module BlenderPlot

using PyCall
@pyimport bpy

include("pycall/util.jl")
include("pycall/plot.jl")

end # module
