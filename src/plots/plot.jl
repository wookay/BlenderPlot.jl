export plot, lineplot

function get_color_in_palette(c, palette)
    # TODO
    nothing
end

function plot_base(strokeLength, color)
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
    if isempty(gp[:layers])
        gpl = gp[:layers][:new]("gpl", set_active=true)
    else
        gpl = gp[:layers][1]
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

function plot(xs, ys; kwargs...)
    lineplot(xs, ys; kwargs...)
end

function plot(f::F, start, stop; kwargs...) where {F <: Function}
    lineplot(f, start, stop; kwargs...)
end

function plot(fs::Vector{F}, start, stop; kwargs...) where {F <: Function}
    lineplot(fs, start, stop; kwargs...)
end

function lineplot(xs, ys; color::ColorT=RGB(1,1,0)) where {ColorT <: Union{RGB, RGBA}}
    points = plot_base(length(xs), color)
    for (point, x, y) in zip(points, xs, ys)
        point[:co] = (x, y, 0)
    end
end

function lineplot(f::F, start, stop; color::ColorT=RGB(1,1,0)) where {F <: Function, ColorT <: Union{RGB, RGBA}}
    strokeLength = 500
    points = plot_base(strokeLength, color)
    lin = linspace(start, stop, strokeLength)
    for (idx, point) in enumerate(points)
        point[:co] = (lin[idx], f(lin[idx]), 0)
    end
end

function lineplot(fs::Vector{F}, start, stop) where {F <: Function}
    skyblue = RGB(135/255, 206/255, 235/255)
    red = RGB(1,0,0)
    yellow = RGB(1,1,0)
    magenta = RGB(1,0,1)
    green = RGB(0,1,0)
    cyan = RGB(0,1,1)
    colors = distinguishable_colors(length(fs), [skyblue, red, yellow, magenta, green, cyan])
    for (f, color) in zip(fs, colors)
        lineplot(f, start, stop; color=color)
    end
end
