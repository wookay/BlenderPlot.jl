export pyload

@pyimport imp

struct PyImp
    name
    file
    filename
    data
end

function pyload(name::String, path=pwd())
    (file, filename, data) = imp.find_module(name, [path])
    i = PyImp(name, file, filename, data)
    pyload(i)
end

function pyload(i::PyImp)
    imp.load_module(i.name, i.file, i.filename, i.data)
end

function Base.getproperty(o::PyObject, name::Symbol)
    (:o == name ? getfield : getindex)(o, name)
end

function Base.setproperty!(o::PyObject, name::Symbol, x)
    :o == name ? setfield!(o, name, x) : setindex!(o, x, name)
end
