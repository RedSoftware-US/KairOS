local systemRegistry, _ = kernel.readTableFile("system:registry/system.reg")

kernel.term.write("sudo: root password: ")
local password = kernel.term.input("*")
kernel.term.write("\n")

local args = {...}

if kernel.hashlib.compare(password,systemRegistry.USERS["0"].hash) then
    local old_euid = kernel.scheduler.getEUID()
	kernel.scheduler.setEUID(0)

    shell.run(table.concat(args, " "))

    kernel.scheduler.setEUID(old_euid)
else
    sleep(1)
    kernel.term.print("Incorrect password")
end
