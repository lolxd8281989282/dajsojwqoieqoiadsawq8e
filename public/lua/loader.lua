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
    
    local success, content = pcall(function()
        local response = game:HttpGet(BASE_URL .. "/" .. name .. ".lua")
        -- Validate content
        if response:match("^%s*<!DOCTYPE") or response:match("^%s*<html") then
            error("Received HTML instead of Lua code")
        end
        return response
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
    success, result = pcall(fn)
    if not success then
        warn("Failed to execute module " .. name .. ": " .. tostring(result))
        return nil
    end
    
    print("Successfully loaded module: " .. name)
    return result
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
    local success, error = pcall(function()
        Config.Init()
        ESP.Init(Config.ESP, workspace, players, runService, userInputService, player, camera)
        Aimbot.Init(Config.Aimbot, workspace, players, runService, userInputService, player, camera)
        GUI.Create(Config, ESP, Aimbot)
    end)
    
    if success then
        print("ESP and Aimbot system loaded successfully!")
    else
        warn("Failed to initialize system: " .. tostring(error))
    end
else
    warn("Failed to load one or more modules")
end
