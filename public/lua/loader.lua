-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Base URL for GitHub raw content
local BASE_URL = "https://raw.githubusercontent.com/lolxd8281989282/dajsojwqoieqoiadsawq8e/master/public/lua"

-- Load other modules
local function loadModule(name)
    if not name then return nil end
    
    local url = BASE_URL .. "/" .. name .. ".lua"
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("Failed to fetch module " .. name .. ": " .. tostring(content))
        return nil
    end
    
    -- Try to load the code
    local fn, loadError = loadstring(content)
    if not fn then
        warn("Failed to parse module " .. name .. ": " .. tostring(loadError))
        return nil
    end
    
    -- Try to execute the code
    local success, result = pcall(fn)
    if not success then
        warn("Failed to execute module " .. name .. ": " .. tostring(result))
        return nil
    end
    
    if type(result) ~= "table" then
        warn("Module " .. name .. " did not return a table")
        return nil
    end
    
    print("Successfully loaded module: " .. name)
    return result
end

-- Load all modules first
print("Loading modules...")
local Config = loadModule("settings_config")
local ESP = loadModule("esp_core")
local Aimbot = loadModule("aimbot_core")
local GUI = loadModule("gui_creation")

-- Initialize the system
if Config and ESP and Aimbot and GUI then
    print("All modules loaded, initializing system...")
    
    local success, error = pcall(function()
        if Config.Init then Config.Init() end
        if ESP.Init then ESP.Init(Config.ESP, workspace, players, runService, userInputService, player, camera) end
        if Aimbot.Init then Aimbot.Init(Config.Aimbot, workspace, players, runService, userInputService, player, camera) end
        if GUI.Create then GUI.Create(Config, ESP, Aimbot) end
    end)
    
    if success then
        print("ESP and Aimbot system loaded successfully!")
    else
        warn("Failed to initialize system: " .. tostring(error))
    end
else
    warn("Failed to load one or more modules")
end
