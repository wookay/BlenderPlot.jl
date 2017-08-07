export plot, lineplot, scatterplot, spy

function get_color_in_palette(c, palette)
    # TODO
    nothing
end

yellow = RGB(1,1,0)
green = RGB(0,1,0)
magenta = RGB(1,0,1)
cyan = RGB(0,1,1)
red = RGB(1,0,0)
blue = RGB(0,0,1)
const color_palettes = [yellow, green, magenta, cyan, red, blue]

function plot_base(strokeLength, color, show_points::Bool)
    # code from https://blender.stackexchange.com/a/49013
    scene = bpy.context[:scene]

    if scene[:grease_pencil] isa Void
        areas = bpy.context[:screen][:areas]
        threedviews = [a for a in areas if a[:type] == "VIEW_3D" ]
        if isempty(threedviews)
            area = last(areas)
            area[:type] = "VIEW_3D"
        else
            area = first(threedviews)
        end
        override = Dict(
            "scene"         => scene,
            "screen"        => bpy.context[:screen],
            "object"        => bpy.context[:object],
            "area"          => area,
            "region"        => area[:regions][1],
            "window"        => bpy.context[:window],
            "active_object" => bpy.context[:object]
        )
        bpy.ops[:gpencil][:data_add](override)
    end

    gp = scene[:grease_pencil]
    gpl = gp[:layers][:new]("gpl", set_active=true)
    gpl[:show_points] = show_points
    if color isa Void
        color = distinguishable_colors(length(gp[:layers]), color_palettes)[end]
    end

    if isempty(gpl[:frames])
        fr = gpl[:frames][:new](1)
    else
        fr = gpl[:frames][end]
    end

    if isempty(gp[:palettes])
        palette = gp[:palettes][:new]("Palette")
    else
        palette = gp[:palettes][1]
    end

    c = RGBA(color)
    pal_color = get_color_in_palette(c, palette)
    if pal_color isa Void
        pal_color = palette[:colors][:new]()
        pal_color[:color] = (c.r, c.g, c.b)
        pal_color[:alpha] = c.alpha
    end

    str = fr[:strokes][:new](colorname = pal_color[:name])
    str[:draw_mode] = "3DSPACE"
    str[:points][:add](count = strokeLength)
    points = str[:points]
end

function plot(ys; kwargs...)
    lineplot(ys; kwargs...)
end

function plot(xs, ys; kwargs...)
    lineplot(xs, ys; kwargs...)
end

function plot(xs, ys, zs; kwargs...)
    lineplot(xs, ys, zs; kwargs...)
end

function plot(f::F, start, stop; kwargs...) where {F <: Function}
    lineplot(f, start, stop; kwargs...)
end

function plot(fs::Vector{F}, start, stop; kwargs...) where {F <: Function}
    lineplot(fs, start, stop; kwargs...)
end

function lineplot(ys::AbstractVector; kwargs...)
    lineplot(1:length(ys), ys; kwargs...)
end

function lineplot(xs::AbstractVector, ys::AbstractVector; kwargs...)
    lineplot(xs, ys, zeros(length(xs)); kwargs...)
end

function lineplot(xs::AbstractVector, ys::AbstractVector, zs::AbstractVector; color::ColorT=nothing) where {ColorT <: Union{Void, RGB, RGBA}}
    points = plot_base(length(xs), color, true)
    for (point, x, y, z) in zip(points, xs, ys, zs)
        point[:co] = (x, y, z)
    end
end

function lineplot(f::F, start, stop; color::ColorT=nothing) where {F <: Function, ColorT <: Union{Void, RGB, RGBA}}
    strokeLength = 500
    points = plot_base(strokeLength, color, false)
    lin = linspace(start, stop, strokeLength)
    for (idx, point) in enumerate(points)
        point[:co] = (lin[idx], f(lin[idx]), 0)
    end
end

function lineplot(fs::Vector{F}, start, stop) where {F <: Function}
    colors = distinguishable_colors(length(fs), color_palettes)
    for (f, color) in zip(fs, colors)
        lineplot(f, start, stop; color=color)
    end
end

function scatterplot(xs, ys; kwargs...)
    scatterplot(xs, ys, zeros(length(xs)); kwargs...)
end

function scatterplot(xs, ys, zs; kwargs...)
    verts = collect(zip(xs, ys, zs))
    scatterplot(verts; kwargs...)
end

function scatterplot(verts::Vector{Tuple{T,T,T}}; color::ColorT=nothing) where {T <: Real, ColorT <: Union{Void, RGB, RGBA}}
    if color isa Void
        color = color_palettes[2]
    end
    mat = bpy.data[:materials][:new]("Color")
    mat[:diffuse_color] = (color.r, color.g, color.b)
    for vert in verts
        bpy.ops[:mesh][:primitive_circle_add](vertices=6, radius=0.05, fill_type="NGON", location=vert)
        bpy.context[:object][:data][:materials][:append](mat)
    end
end

function spy(sp::SparseMatrixCSC)
    cobaltblue = RGB(0, 71/255, 171/255)
    turkeyred = RGB(169/255, 17/255, 1/255)
    positive = bpy.data[:materials][:new]("Positive")
    positive[:diffuse_color] = (turkeyred.r, turkeyred.g, turkeyred.b)
    negative = bpy.data[:materials][:new]("Negative")
    negative[:diffuse_color] = (cobaltblue.r, cobaltblue.g, cobaltblue.b)
    scale = 0.1
    rows, cols, vals = findnz(sp)
    for (row, col, val) in zip(rows, cols, vals)
        vert = scale .* (row, col, 0)
        bpy.ops[:mesh][:primitive_circle_add](vertices=6, radius=0.05, fill_type="NGON", location=vert)
        bpy.context[:object][:data][:materials][:append](val > 0 ? positive : negative)
    end
end
