local args = {...}
local cwd = shell.getCWD()

if #args == 0 then
	kernel.term.print("Usage: delete [file or dir]")
end

if kernel.fs.exists(kernel.fs.sanitizePath(cwd.."/"..args[1])) then
    kernel.fs.delete(kernel.fs.sanitizePath(cwd.."/"..args[1]))
else
    kernel.term.print("File/dir does not exist")
end
