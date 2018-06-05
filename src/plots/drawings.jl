export linedraw, vectordraw

function linedraw(verts::Vector{Any}; kwargs...)
    linedraw(map(x->tuple(x...), verts); kwargs...)
end

function linedraw(v::Vector{Tuple{T,T,T}}; color::ColorT=nothing) where {T <: Real, ColorT <: Union{Nothing, RGB, RGBA}}
    if color isa Nothing
        color = color_palettes[1]
    end
    points = plot_base(length(v), color, true)
    for (point, co) in zip(points, v)
        point.co = co
    end
end

function vectordraw(origin::AbstractVector, point::AbstractVector; color::ColorT=nothing) where {ColorT <: Union{Nothing, RGB, RGBA}}
    points = plot_base(2, color, true)
    points[1].co = origin
    points[2].co = point
end
