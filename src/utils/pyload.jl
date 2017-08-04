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
