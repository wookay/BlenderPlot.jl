export plot

function plot(f::F, start, stop) where {F <: Function}
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
        fr = gpl[:active_frame]
    end
    
    strokeLength = 500
    str = fr[:strokes][:new]()
    str[:draw_mode] = "3DSPACE"
    str[:points][:add](count = strokeLength)
    #str[:color][:color]
    points = str[:points]

    lin = linspace(start, stop, strokeLength)
    for (idx, point) in enumerate(points)
        point[:co] = (lin[idx], f(lin[idx]), 0)
    end
end
