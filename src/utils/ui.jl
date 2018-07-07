export selected_objects, active_object
export select_by_name, select_by_type

export clear
export GPencil

export make_edge, make_face

function selected_objects()
    bpy.context.selected_objects
end

function active_object()
    bpy.context.active_object
end

function select_by_name(name::String)
    obj = get(bpy.data.objects, name)
    obj.select = true
    bpy.context.scene.objects.active = obj
end

function select_by_type(typ::String)
    bpy.ops.object.select_by_type(; :type=>typ)
    selected_objects()
end

struct BlenderObject
    name::String
end

const GPencil = BlenderObject("GPencil")

function clear(obj::BlenderObject)
    if "GPencil" == obj.name
	    for gp in bpy.data.grease_pencil, l in gp.layers
		    gp.layers.remove(l)
	    end
	end
end

function clear()
    clear(GPencil)
    candidate_list = [item.name for item in bpy.data.objects if item[:type] == "MESH"]
    for object_name in candidate_list
        get(bpy.data.objects, object_name).select = true
    end
    bpy.ops.object.delete()
    for item in bpy.data.meshes
        bpy.data.meshes.remove(item)
    end
end

function make_edge(ob, a, b)
    bpy.ops.object.mode_set(mode="EDIT", toggle=false)
    bm = bmesh.from_edit_mesh(ob.data)
    if any(edge -> ([a, b] .- 1) == map(v -> v.index, edge.verts), bm.edges)
    else
        edge = bm.edges.new(getindex.(bm.verts, (a, b)))
        ob.data.update()
    end
end

function make_face(ob, a, b, c)
    bpy.ops.object.mode_set(mode="EDIT", toggle=false)
    bm = bmesh.from_edit_mesh(ob.data)
    if any(face -> ([a, b, c] .- 1) == map(v -> v.index, face.verts), bm.faces)
    else
        face = bm.faces.new(getindex.(bm.verts, (a, b, c)))
        ob.data.update()
    end
end
