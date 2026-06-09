local utils = require 'mp.utils'

-- Folder where CRT shaders are stored
local shader_folder = "~~/shaders/crt/"

function get_shader_list()
    local path = mp.command_native({"expand-path", shader_folder})
    local files = utils.readdir(path, "files")
    local shaders = {}
    
    if files then
        for _, f in ipairs(files) do
            if f:match("%.glsl$") then
                table.insert(shaders, shader_folder .. f)
            end
        end
    end
    
    table.sort(shaders, function(a, b)
        local function pad(n) return ("%05d"):format(tonumber(n)) end
        return a:gsub("(%d+)", pad) < b:gsub("(%d+)", pad)
    end)
    return shaders
end

function disable_shaders()
    local shaders = get_shader_list()
    for _, shader in ipairs(shaders) do
        mp.commandv("change-list", "glsl-shaders", "remove", shader)
    end
    mp.osd_message("CRT Shaders: Off")
end

function cycle_shaders()
    local shaders = get_shader_list()
    if #shaders == 0 then
        mp.osd_message("No CRT shaders found in " .. shader_folder)
        return
    end

    local current = mp.get_property("glsl-shaders", "")
    local found_index = 0
    
    for i, shader in ipairs(shaders) do
        local filename = shader:match("([^/]+)$")
        if current:find(filename, 1, true) then
            found_index = i
            break
        end
    end
    
    for _, shader in ipairs(shaders) do
        mp.commandv("change-list", "glsl-shaders", "remove", shader)
    end
    
    local next_index = found_index + 1
    if next_index <= #shaders then
        local next_shader = shaders[next_index]
        mp.commandv("change-list", "glsl-shaders", "append", next_shader)
        local name = next_shader:match("([^/]+)%.glsl$")
        mp.osd_message("CRT Shader: " .. name)
    else
        disable_shaders()
    end
end

function cycle_shaders_reverse()
    local shaders = get_shader_list()
    if #shaders == 0 then
        mp.osd_message("No CRT shaders found in " .. shader_folder)
        return
    end

    local current = mp.get_property("glsl-shaders", "")
    local found_index = 0
    
    for i, shader in ipairs(shaders) do
        local filename = shader:match("([^/]+)$")
        if current:find(filename, 1, true) then
            found_index = i
            break
        end
    end
    
    for _, shader in ipairs(shaders) do
        mp.commandv("change-list", "glsl-shaders", "remove", shader)
    end
    
    local prev_index = 0
    if found_index == 0 then
        prev_index = #shaders
    else
        prev_index = found_index - 1
    end

    if prev_index > 0 then
        local prev_shader = shaders[prev_index]
        mp.commandv("change-list", "glsl-shaders", "append", prev_shader)
        local name = prev_shader:match("([^/]+)%.glsl$")
        mp.osd_message("CRT Shader: " .. name)
    else
        disable_shaders()
    end
end

mp.register_script_message("cycle-crt-shaders", cycle_shaders)
mp.register_script_message("cycle-crt-shaders-reverse", cycle_shaders_reverse)
mp.register_script_message("disable-crt-shaders", disable_shaders)
