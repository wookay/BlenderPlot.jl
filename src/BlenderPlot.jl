module BlenderPlot

using PyCall

if endswith(unsafe_string(Base.JLOptions().julia_bin), "julia")
    warn("Please run on the Blender Python Console")
else
    include("pycall/util.jl")
    export bpy
    @pyimport bpy
    include("pycall/plot.jl")
end

end # module
