export clear
export GPencil

import Base: select
export selected_objects
export active_object

function select(name::String)
    obj = get(bpy.data[:objects], name)
    obj[:select] = true
    bpy.context[:scene][:objects][:active] = obj
end

function selected_objects()
    bpy.context[:selected_objects]
end

function active_object()
    bpy.context[:active_object]
end


struct BlenderObject
    name::String
end

const GPencil = BlenderObject("GPencil")

function clear(obj::BlenderObject)
    if "GPencil" == obj.name
	    for gp in bpy.data[:grease_pencil], l in gp[:layers]
		    gp[:layers][:remove](l)
	    end
	end
end
