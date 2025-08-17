local args = {...}

local long = false

if args[1] == "-l" then long = true; table.remove(args, 1) end

local cwd = shell.getCWD()

local path = kernel.fs.sanitizePath(cwd.."/"..(args[1] or ""))

local files = {}
local dirs = {}

for _, v in ipairs(kernel.fs.getChildren(path)) do
	if kernel.fs.isFile(path.."/"..v) then
        table.insert(files, v)
    else
        table.insert(dirs, v)
    end
end

kernel.term.setForegroundColor(28, 51, 255)

for _, v in ipairs(dirs) do
	kernel.term.print(v)
end

for _, v in ipairs(files) do
	if v:sub(-4) == ".lua" then
        kernel.term.setForegroundColor(67, 255, 67)
    else
        kernel.term.setForegroundColor(255, 255, 255)
    end

    kernel.term.print(v)
end
