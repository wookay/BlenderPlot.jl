export linedraw, vectordraw

function linedraw(v::Vector{Tuple{T,T,T}}; color::ColorT=nothing) where {T <: Real, ColorT <: Union{Void, RGB, RGBA}}
    if color isa Void
        color = color_palettes[1]
    end
    points = plot_base(length(v), color, true)
    for (point, co) in zip(points, v)
        point[:co] = co
    end
end

function vectordraw(origin::AbstractVector, point::AbstractVector; color::ColorT=nothing) where {ColorT <: Union{Void, RGB, RGBA}}
    points = plot_base(2, color, true)
    points[1][:co] = origin
    points[2][:co] = point
end
