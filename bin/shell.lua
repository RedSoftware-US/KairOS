local systemRegistry, _ = kernel.readTableFile("system:registry/system.reg")
local currentDirectory = ""

local exitShell = false

local internal_commands = {
    cd = function(args)
        if args[1] then
            currentDirectory = kernel.fs.sanitizePath(currentDirectory.."/"..args[1])
        end
    end,
    exit = function(args)
        exitShell = true
    end,
    logout = function(args)
        exitShell = true
    end,
    pwd = function(args)
        kernel.term.print("/"..currentDirectory)
    end
}

local shell = {}

function shell.getCWD()
    return "system:"..currentDirectory
end

function shell.run(command)
    kernel.term.setBackgroundColor(0, 0, 0)
    kernel.term.setForegroundColor(255, 255, 255)

    if exitShell == true then return end

    local tokens = {}
    for word in string.gmatch(command, '%S+') do
        table.insert(tokens, word)
    end

    if internal_commands[tokens[1]] then
        internal_commands[table.remove(tokens, 1)](tokens)
    else
        local shellreg = kernel.readTableFile("system:etc/shell/shell.reg")

        for k, v in pairs(shellreg.aliases) do
            if k == tokens[1] then tokens[1] = v end
            break
        end

        for _, path in ipairs(kernel.getPathFiles()) do
            local parts = {}

            for part in string.gmatch(path, "[^/]+") do
                table.insert(parts, part)
            end

            local filename = parts[#parts]
            local no_ext_file = filename:match("(.+)%..+$") or filename

            if no_ext_file == tokens[1] then
                table.remove(tokens, 1)
                local pid, err = kernel.scheduler.spawnFile(path, 0, tokens, {shell = shell})
                if err then print(err) end
                kernel.scheduler.waitPID(pid)
            end
        end
    end

    kernel.term.write("\n")
end

while true do
    kernel.term.setBackgroundColor(0, 0, 0)
    kernel.term.setForegroundColor(255, 255, 255)
    kernel.term.write(string.char(tonumber("da", 16), tonumber("c4", 16), tonumber("c4", 16), tonumber("c4", 16)))
    kernel.term.write("/"..currentDirectory)
    kernel.term.write("\n"..string.char(tonumber("c0", 16)))
    kernel.term.write(kernel.scheduler.getEUsername()..">")
    coroutine.yield()
    local usr_input = kernel.term.input()
    kernel.term.write("\n")

    shell.run(usr_input)

    if exitShell == true then break end
end
