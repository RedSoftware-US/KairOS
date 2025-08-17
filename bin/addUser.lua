local uid = kernel.scheduler.getEUID()

if uid ~= 0 then
	kernel.term.print("Must be root. Use sudo.")
    return
end

local args = {...}

if not (#args >= 2) then
	kernel.term.print("Usage: addUser [username] [password]")
    return
end

kernel.addUser(args[1], kernel.hashlib.encode(args[2]))

kernel.term.print("User created.")
