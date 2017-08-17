# code from http://blenderscripting.blogspot.kr/2011/06/randomly-placing-vertices-around.html

# include(Pkg.dir("BlenderPlot","examples","sphere.jl"))

using Rotations
using Distances

SPHERE_RADIUS = 1
MIN_DISTANCE = 0.2

sphere = [SPHERE_RADIUS, 0, 0]

cart() = RotXYZ(deg2rad(rand(0:360)),
                deg2rad(rand(0:360)),
                deg2rad(rand(0:360)))

verts = []
for x in 1:300
    outVec = cart() * sphere
    !any(B -> norm(outVec - B) < MIN_DISTANCE, verts) && push!(verts, outVec)
end

scatterplot(verts)
