export clear
export GPencil

import Base: select

function select(name::String)
    obj = get(bpy.data[:objects], name)
    obj[:select] = true
    bpy.context[:scene][:objects][:active] = obj
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
