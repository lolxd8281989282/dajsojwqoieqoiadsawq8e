-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Base URL for direct file access
local BASE_URL = "https://dracula.lol/lua"

-- Load other modules
local function loadModule(name)
    if not name then return nil end
    
    local success, result = pcall(function()
        local content = game:HttpGet(BASE_URL .. "/" .. name .. ".lua")
        if not content then
            error("Empty content received")
        end
        return loadstring(content)()
    end)
    
    if success then
        print("Successfully loaded module: " .. name)
        return result
    else
        warn("Failed to load module: " .. name .. " | Error: " .. tostring(result))
        return nil
    end
end

-- Load settings and configuration
local Config = loadModule("settings_config")
if not Config then
    warn("Failed to load configuration")
    return
end

-- Load ESP core
local ESP = loadModule("esp_core")
if not ESP then
    warn("Failed to load ESP core")
    return
end

-- Load Aimbot core
local Aimbot = loadModule("aimbot_core")
if not Aimbot then
    warn("Failed to load Aimbot core")
    return
end

-- Load GUI creation
local GUI = loadModule("gui_creation")
if not GUI then
    warn("Failed to load GUI creation")
    return
end

-- Initialize the system
if Config and ESP and Aimbot and GUI then
    pcall(function()
        Config.Init()
        ESP.Init(Config.ESP, workspace, players, runService, userInputService, player, camera)
        Aimbot.Init(Config.Aimbot, workspace, players, runService, userInputService, player, camera)
        GUI.Create(Config, ESP, Aimbot)
        print("ESP and Aimbot system loaded successfully!")
    end)
else
    warn("Failed to load one or more modules")
end
