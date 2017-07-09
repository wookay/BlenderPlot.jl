module BlenderPlot

using PyCall

if endswith(unsafe_string(Base.JLOptions().julia_bin), "julia")
    warn("Please run on the Blender Julia Console")
else
    export bpy, bpy_extras, bgl, mathutils
    @pyimport bpy
    @pyimport bpy_extras
    @pyimport bgl
    @pyimport mathutils
    include("pycall/plot.jl")
    include("pycall/util.jl")
end

end # module
