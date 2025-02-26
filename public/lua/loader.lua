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
    print("Fetching module from:", url)
    
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("Failed to fetch module " .. name .. ": " .. tostring(content))
        return nil
    end
    
    -- Check if content is HTML (error page)
    if content:match("<!DOCTYPE") or content:match("<html") then
        warn("Received HTML instead of Lua for module: " .. name)
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
    
    print("Successfully loaded module: " .. name)
    return result
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
    local success, error = pcall(function()
        -- Initialize Config (if needed)
        if Config.Init then
            Config.Init()
        end

        -- Initialize ESP
        ESP.Init(Config.ESP, workspace, players, runService, userInputService, player, camera)

        -- Initialize Aimbot
        Aimbot.Init(Config.Aimbot, workspace, players, runService, userInputService, player, camera)

        -- Create GUI
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

-- Main loop with optimizations
local lastUpdate = tick()
local updateInterval = 1/60  -- Cap at 60 FPS

runService.RenderStepped:Connect(function()
    -- Throttle updates to prevent lag
    local currentTime = tick()
    if currentTime - lastUpdate < updateInterval then
        return
    end
    lastUpdate = currentTime

    if Config and Config.Misc then
        -- Camera FOV
        if Config.Misc.ThirdPerson and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.CameraOffset = Vector3.new(0, 0, Config.Misc.CameraAmount / 10)
            end
        end
        
        -- World settings
        if Config.Misc.CustomFog then
            game.Lighting.FogEnd = Config.Misc.FogDistance
        end
        
        if Config.Misc.CustomBrightness then
            game.Lighting.Brightness = Config.Misc.BrightnessStrength / 50
        end
        
        -- Movement settings
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            
            if Config.Misc.SpeedEnabled then
                humanoid.WalkSpeed = 16 + (Config.Misc.SpeedAmount / 2)
            else
                humanoid.WalkSpeed = 16
            end
            
            if Config.Misc.FlightEnabled then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.Velocity = rootPart.Velocity + Vector3.new(0, Config.Misc.FlightAmount / 10, 0)
                end
            end
        end
    end
end)

print("Loader execution completed")
