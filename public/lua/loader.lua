-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Base URL for your Vercel deployment
local BASE_URL = "https://dracula.lol/api/lua"

-- Load other modules
local function loadModule(name)
    local success, result = pcall(function()
        return game:HttpGet(BASE_URL .. "/" .. name)
    end)
    
    if success then
        return loadstring(result)()
    else
        warn("Failed to load module: " .. name)
        return nil
    end
end

-- Load settings and configuration
local Config = loadModule("settings_config")

-- Load ESP core
local ESP = loadModule("esp_core")

-- Load Aimbot core
local Aimbot = loadModule("aimbot_core")

-- Load GUI creation
local GUI = loadModule("gui_creation")

-- Initialize the system
if Config and ESP and Aimbot and GUI then
    Config.Init()
    ESP.Init(Config.ESP, workspace, players, runService, userInputService, player, camera)
    Aimbot.Init(Config.Aimbot, workspace, players, runService, userInputService, player, camera)
    GUI.Create(Config, ESP, Aimbot)
    print("ESP and Aimbot system loaded successfully!")
else
    warn("Failed to load one or more modules")
end
