local GUI = {}

function GUI.Create(Config, ESP, Aimbot)
    -- Add error checks
    if not Config then
        warn("Config is nil")
        return
    end
    
    if not Config.ESP then
        warn("Config.ESP is nil")
        return
    end
    
    if not Config.Aimbot then
        warn("Config.Aimbot is nil")
        return
    end
    
    if not Config.Misc then
        warn("Config.Misc is nil")
        return
    }
    
    if not Config.CurrentPage then
        Config.CurrentPage = "visual"  -- Set default page
    end

    print("Creating GUI with Config:", Config)
    print("Current page:", Config.CurrentPage)

    local ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "ESPConfiguration"
    ESPGui.Parent = game:GetService("CoreGui")

    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ESPGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MainFrame

    -- Create a horizontal container for title and nav
    local TopContainer = Instance.new("Frame")
    TopContainer.Size = UDim2.new(1, -20, 0, 25)
    TopContainer.Position = UDim2.new(0, 10, 0, 5)
    TopContainer.BackgroundTransparency = 1
    TopContainer.Parent = MainFrame

    -- Title
    local Title = Instance.new("TextLabel")
    Title.RichText = true
    Title.Text = '<font color="rgb(180,180,180)">dracula</font><font color="rgb(100,100,100)">.lol</font>'
    Title.Size = UDim2.new(0, 82, 1, 0)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextSize = 13
    Title.Font = Enum.Font.Gotham
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopContainer

    -- Separator
    local Separator = Instance.new("TextLabel")
    Separator.Text = "|"
    Separator.Size = UDim2.new(0, 10, 1, 0)
    Separator.Position = UDim2.new(0, 58.5, 0, 0)
    Separator.BackgroundTransparency = 1
    Separator.TextColor3 = Color3.fromRGB(100, 100, 100)
    Separator.TextSize = 14
    Separator.Font = Enum.Font.Gotham
    Separator.Parent = TopContainer

    -- Navigation
    local NavFrame = Instance.new("Frame")
    NavFrame.Size = UDim2.new(1, -100, 1, 0)
    NavFrame.Position = UDim2.new(0, 70, 0, 0)
    NavFrame.BackgroundTransparency = 1
    NavFrame.Parent = TopContainer

    local navItems = {
        "visual",
        "aiming",
        "misc",
        "output",
        "player-list",
        "settings"
    }

    local navButtons = {}
    local currentX = 0

    -- Content Container
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    -- Create Pages
    local pages = {
        VisualsPage = Instance.new("Frame"),
        AimingPage = Instance.new("Frame"),
        MiscPage = Instance.new("Frame"),
        OutputPage = Instance.new("Frame"),
        PlayerListPage = Instance.new("Frame"),
        SettingsPage = Instance.new("Frame")
    }

    for name, page in pairs(pages) do
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = Container
        print("Created page:", name)
    end

    pages.VisualsPage.Visible = Config.CurrentPage == "visual"
    print("Set VisualsPage visibility to:", pages.VisualsPage.Visible)

    local function updateNavColors()
        for name, button in pairs(navButtons) do
            button.TextColor3 = name == Config.CurrentPage and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
        end
    end

    for _, name in ipairs(navItems) do
        local button = Instance.new("TextButton")
        button.Text = name
        button.Size = UDim2.new(0, 0, 1, 0)
        button.AutomaticSize = Enum.AutomaticSize.X
        button.Position = UDim2.new(0, currentX, 0, 0)
        button.BackgroundTransparency = 1
        button.TextColor3 = name == Config.CurrentPage and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
        button.TextSize = 12
        button.Font = Enum.Font.Gotham
        button.Parent = NavFrame
        
        currentX = currentX + button.TextBounds.X + 15
        
        navButtons[name] = button
        
        button.MouseButton1Click:Connect(function()
            print("Switching to page:", name)
            Config.CurrentPage = name
            updateNavColors()
            
            for pageName, page in pairs(pages) do
                local shouldBeVisible = (pageName:lower():gsub("page", "") == name)
                page.Visible = shouldBeVisible
                print(pageName, "visibility set to", shouldBeVisible)
            end
        end)
    end

    -- Make GUI draggable
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TopContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    TopContainer.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    TopContainer.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Helper functions for creating UI elements
    local function createSection(name, parent, position)
        local sectionContainer = Instance.new("Frame")
        sectionContainer.Size = UDim2.new(1, 0, 0, 0)
        sectionContainer.Position = position
        sectionContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sectionContainer.BorderSizePixel = 0
        sectionContainer.Parent = parent

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 4)
        containerCorner.Parent = sectionContainer

        local label = Instance.new("TextLabel")
        label.Text = name
        label.Size = UDim2.new(1, -16, 0, 20)
        label.Position = UDim2.new(0, 8, 0, 8)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sectionContainer

        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, -16, 0, 0)
        content.Position = UDim2.new(0, 8, 0, 36)
        content.BackgroundTransparency = 1
        content.Parent = sectionContainer

        local function updateHeight()
            local contentHeight = 0
            for _, child in pairs(content:GetChildren()) do
                contentHeight = math.max(contentHeight, child.Position.Y.Offset + child.Size.Y.Offset)
            end
            sectionContainer.Size = UDim2.new(1, 0, 0, contentHeight + 44)
        end

        return content, updateHeight, sectionContainer
    end

    local function createToggle(name, parent, position, setting, configTable)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 20)
        toggleFrame.Position = position
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = parent

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 16, 0, 16)
        button.Position = UDim2.new(0, 0, 0.5, -8)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = toggleFrame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 2)
        buttonCorner.Parent = button

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 10, 0, 10)
        indicator.Position = UDim2.new(0.5, -5, 0.5, -5)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.BackgroundTransparency = 1
        indicator.BorderSizePixel = 0
        indicator.Parent = button

        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 2)
        indicatorCorner.Parent = indicator

        local label = Instance.new("TextLabel")
        label.Text = name
        label.Size = UDim2.new(1, -24, 1, 0)
        label.Position = UDim2.new(0, 24, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame

        local function updateToggle()
            indicator.BackgroundTransparency = configTable[setting] and 0 or 1
        end

        updateToggle()
        button.MouseButton1Click:Connect(function()
            configTable[setting] = not configTable[setting]
            updateToggle()
            print(name, "set to", configTable[setting])
        end)

        return toggleFrame
    end

    local function createDropdown(name, parent, position, options, setting, configTable)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 45)
        dropdownFrame.Position = position
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.Parent = parent

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = name
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = dropdownFrame

        local button = Instance.new("TextButton")
        button.Text = configTable[setting]
        button.Size = UDim2.new(1, 0, 0, 20)
        button.Position = UDim2.new(0, 0, 0, 25)
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.TextSize = 12
        button.Font = Enum.Font.Gotham
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.BorderSizePixel = 0
        button.Parent = dropdownFrame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = button

        local optionsFrame = Instance.new("Frame")
        optionsFrame.Size = UDim2.new(1, 0, 0, #options * 20)
        optionsFrame.Position = UDim2.new(0, 0, 1, 0)
        optionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        optionsFrame.BorderSizePixel = 0
        optionsFrame.Visible = false
        optionsFrame.ZIndex = 10
        optionsFrame.Parent = button

        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, 4)
        optionsCorner.Parent = optionsFrame

        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Text = option
            optionButton.Size = UDim2.new(1, 0, 0, 20)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 20)
            optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            optionButton.TextSize = 12
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.BorderSizePixel = 0
            optionButton.ZIndex = 10
            optionButton.Parent = optionsFrame

            optionButton.MouseButton1Click:Connect(function()
                configTable[setting] = option
                button.Text = option
                optionsFrame.Visible = false
                print(name, "set to", option)
            end)
        end

        button.MouseButton1Click:Connect(function()
            optionsFrame.Visible = not optionsFrame.Visible
        end)

        return dropdownFrame
    end

    local function createSlider(name, parent, position, setting, min, max, configTable)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 25)
        sliderFrame.Position = position
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = name
        nameLabel.Size = UDim2.new(0.5, -5, 1, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = sliderFrame

        local sliderBG = Instance.new("Frame")
        sliderBG.Size = UDim2.new(0.5, -35, 0, 3)
        sliderBG.Position = UDim2.new(0.5, 0, 0.5, -1)
        sliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBG.BorderSizePixel = 0
        sliderBG.Parent = sliderFrame

        local sliderBGCorner = Instance.new("UICorner")
        sliderBGCorner.CornerRadius = UDim.new(0, 2)
        sliderBGCorner.Parent = sliderBG

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((configTable[setting] - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBG

        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 10, 0, 10)
        sliderButton.Position = UDim2.new((configTable[setting] - min) / (max - min), -5, 0.5, -5)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.Parent = sliderBG

        local sliderButtonCorner = Instance.new("UICorner")
        sliderButtonCorner.CornerRadius = UDim.new(0, 5)
        sliderButtonCorner.Parent = sliderButton

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Text = tostring(configTable[setting])
        valueLabel.Size = UDim2.new(0, 30, 1, 0)
        valueLabel.Position = UDim2.new(1, -30, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        valueLabel.TextSize = 14
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame

        local dragging = false

        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        sliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = (input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X
                pos = math.clamp(pos, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                configTable[setting] = value
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                sliderButton.Position = UDim2.new(pos, -5, 0.5, -5)
                valueLabel.Text = tostring(value)
                print(name, "set to", value)
            end
        end)

        return sliderFrame
    end

    -- Create Visual Page
    local LeftColumn = Instance.new("Frame")
    LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Parent = pages.VisualsPage

    local RightColumn = Instance.new("Frame")
    RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
    RightColumn.BackgroundTransparency = 1
    RightColumn.Parent = pages.VisualsPage

    -- ESP Section
    local espContent, updateESPHeight = createSection("ESP", LeftColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Enabled", espContent, UDim2.new(0, 0, 0, 0), "Enabled", Config.ESP)
    createToggle("Team Check", espContent, UDim2.new(0, 0, 0, 25), "TeamCheck", Config.ESP)
    createToggle("Outline", espContent, UDim2.new(0, 0, 0, 50), "Outline", Config.ESP)
    createToggle("Self ESP", espContent, UDim2.new(0, 0, 0, 75), "SelfESP", Config.ESP)
    createSlider("Distance", espContent, UDim2.new(0, 0, 0, 100), "Distance", 0, 2000, Config.ESP)
    updateESPHeight()

    -- Box Settings Section
    local boxContent, updateBoxHeight = createSection("Box", LeftColumn, UDim2.new(0, 0, 0, 200))
    createToggle("Enabled", boxContent, UDim2.new(0, 0, 0, 0), "ShowBoxes", Config.ESP)
    createToggle("Fill Box", boxContent, UDim2.new(0, 0, 0, 25), "FillBox", Config.ESP)
    createDropdown("Box Type", boxContent, UDim2.new(0, 0, 0, 50), {"Corners", "Full"}, "BoxType", Config.ESP)
    updateBoxHeight()

    -- Name Settings Section
    local nameContent, updateNameHeight = createSection("Name", RightColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Enabled", nameContent, UDim2.new(0, 0, 0, 0), "ShowNames", Config.ESP)
    updateNameHeight()

    -- Other Settings Section
    local otherContent, updateOtherHeight = createSection("Other", RightColumn, UDim2.new(0, 0, 0, 50))
    createToggle("Equipped Item", otherContent, UDim2.new(0, 0, 0, 0), "ShowEquippedItem", Config.ESP)
    createToggle("Skeleton", otherContent, UDim2.new(0, 0, 0, 25), "ShowSkeleton", Config.ESP)
    createToggle("Head Dot", otherContent, UDim2.new(0, 0, 0, 50), "ShowHeadDot", Config.ESP)
    createToggle("Distance", otherContent, UDim2.new(0, 0, 0, 75), "ShowDistance", Config.ESP)
    createToggle("Armor Bar", otherContent, UDim2.new(0, 0, 0, 100), "ShowArmorBar", Config.ESP)
    updateOtherHeight()

    -- Create Aiming Page
    local AimingLeftColumn = Instance.new("Frame")
    AimingLeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    AimingLeftColumn.BackgroundTransparency = 1
    AimingLeftColumn.Parent = pages.AimingPage

    local AimingRightColumn = Instance.new("Frame")
    AimingRightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    AimingRightColumn.Position = UDim2.new(0.5, 5, 0, 0)
    AimingRightColumn.BackgroundTransparency = 1
    AimingRightColumn.Parent = pages.AimingPage

    -- Aimbot Main Section
    local aimbotContent, updateAimbotHeight = createSection("Aimbot", AimingLeftColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Enabled", aimbotContent, UDim2.new(0, 0, 0, 0), "Enabled", Config.Aimbot)
    createToggle("Team Check", aimbotContent, UDim2.new(0, 0, 0, 25), "TeamCheck", Config.Aimbot)
    createToggle("Visibility Check", aimbotContent, UDim2.new(0, 0, 0, 50), "VisibilityCheck", Config.Aimbot)
    createToggle("Lock Target", aimbotContent, UDim2.new(0, 0, 0, 75), "LockTarget", Config.Aimbot)
    createToggle("Sticky Aim", aimbotContent, UDim2.new(0, 0, 0, 100), "StickyAim", Config.Aimbot)
    createSlider("FOV", aimbotContent, UDim2.new(0, 0, 0, 125), "FOV", 0, 360, Config.Aimbot)
    updateAimbotHeight()

    -- Create Misc Page
    local MiscLeftColumn = Instance.new("Frame")
    MiscLeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    MiscLeftColumn.BackgroundTransparency = 1
    MiscLeftColumn.Parent = pages.MiscPage

    local MiscRightColumn = Instance.new("Frame")
    MiscRightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    MiscRightColumn.Position = UDim2.new(0.5, 5, 0, 0)
    MiscRightColumn.BackgroundTransparency = 1
    MiscRightColumn.Parent = pages.MiscPage

    -- Camera Section
    local cameraContent, updateCameraHeight = createSection("Camera", MiscLeftColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Third Person", cameraContent, UDim2.new(0, 0, 0, 0), "ThirdPerson", Config.Misc)
    createSlider("FOV", cameraContent, UDim2.new(0, 0, 0, 25), "CameraFOV", 30, 120, Config.Misc)
    createSlider("Amount", cameraContent, UDim2.new(0, 0, 0, 70), "CameraAmount", 0, 100, Config.Misc)
    updateCameraHeight()

    -- Character Section
    local characterContent, updateCharacterHeight = createSection("Character", MiscLeftColumn, UDim2.new(0, 0, 0, 160))
    createToggle("Anti-Clipping", characterContent, UDim2.new(0, 0, 0, 0), "AntiClipping", Config.Misc)

    -- Create Sit Button
    local sitButton = Instance.new("TextButton")
    sitButton.Size = UDim2.new(1, 0, 0, 30)
    sitButton.Position = UDim2.new(0, 0, 0, 30)
    sitButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sitButton.Text = "Sit"
    sitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sitButton.TextSize = 14
    sitButton.Font = Enum.Font.Gotham
    sitButton.Parent = characterContent

    local sitCorner = Instance.new("UICorner")
    sitCorner.CornerRadius = UDim.new(0, 4)
    sitCorner.Parent = sitButton

    sitButton.MouseButton1Click:Connect(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.Sit = true
            print("Character sat down")
        end
    end)

    updateCharacterHeight()

    -- World Section
    local worldContent, updateWorldHeight = createSection("World", MiscRightColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Custom Fog", worldContent, UDim2.new(0, 0, 0, 0), "CustomFog", Config.Misc)
    createSlider("Distance", worldContent, UDim2.new(0, 0, 0, 25), "FogDistance", 0, 1000, Config.Misc)
    createToggle("Custom Brightness", worldContent, UDim2.new(0, 0, 0, 70), "CustomBrightness", Config.Misc)
    createSlider("Strength", worldContent, UDim2.new(0, 0, 0, 95), "BrightnessStrength", 0, 100, Config.Misc)
    updateWorldHeight()

    -- Movement Section
    local movementContent, updateMovementHeight = createSection("Movement", MiscRightColumn, UDim2.new(0, 0, 0, 160))
    createToggle("Speed", movementContent, UDim2.new(0, 0, 0, 0), "SpeedEnabled", Config.Misc)
    createSlider("Amount", movementContent, UDim2.new(0, 0, 0, 25), "SpeedAmount", 0, 100, Config.Misc)
    createToggle("Flight", movementContent, UDim2.new(0, 0, 0, 70), "FlightEnabled", Config.Misc)
    createSlider("Amount", movementContent, UDim2.new(0, 0, 0, 95), "FlightAmount", 0, 100, Config.Misc)
    updateMovementHeight()

    -- Create Output Page
    local ConsoleFrame = Instance.new("ScrollingFrame")
    ConsoleFrame.Size = UDim2.new(1, 0, 1, -40)
    ConsoleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ConsoleFrame.BorderSizePixel = 0
    ConsoleFrame.ScrollBarThickness = 4
    ConsoleFrame.Parent = pages.OutputPage

    local ConsoleCorner = Instance.new("UICorner")
    ConsoleCorner.CornerRadius = UDim.new(0, 8)
    ConsoleCorner.Parent = ConsoleFrame

    local ConsoleLayout = Instance.new("UIListLayout")
    ConsoleLayout.Padding = UDim.new(0, 5)
    ConsoleLayout.Parent = ConsoleFrame

    local ConsolePadding = Instance.new("UIPadding")
    ConsolePadding.PaddingLeft = UDim.new(0, 10)
    ConsolePadding.PaddingRight = UDim.new(0, 10)
    ConsolePadding.PaddingTop = UDim.new(0, 10)
    ConsolePadding.PaddingBottom = UDim.new(0, 10)
    ConsolePadding.Parent = ConsoleFrame

    -- Create button container
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 30)
    ButtonContainer.Position = UDim2.new(0, 0, 1, -30)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = pages.OutputPage

    -- Create Clear Console button
    local ClearButton = Instance.new("TextButton")
    ClearButton.Size = UDim2.new(0, 100, 1, 0)
    ClearButton.Position = UDim2.new(0, 0, 0, 0)
    ClearButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ClearButton.Text = "Clear Output"
    ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearButton.TextSize = 14
    ClearButton.Font = Enum.Font.Gotham
    ClearButton.BorderSizePixel = 0
    ClearButton.Parent = ButtonContainer

    local ClearCorner = Instance.new("UICorner")
    ClearCorner.CornerRadius = UDim.new(0, 4)
    ClearCorner.Parent = ClearButton

    -- Create Copy GameId button
    local CopyButton = Instance.new("TextButton")
    CopyButton.Size = UDim2.new(0, 100, 1, 0)
    CopyButton.Position = UDim2.new(0, 110, 0, 0)
    CopyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CopyButton.Text = "Copy GameId"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = 14
    CopyButton.Font = Enum.Font.Gotham
    CopyButton.BorderSizePixel = 0
    CopyButton.Parent = ButtonContainer

    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 4)
    CopyCorner.Parent = CopyButton

    -- Console functionality
    local function addConsoleMessage(message)
        local timestamp = os.date("%H:%M:%S")
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 0, 16)
        text.BackgroundTransparency = 1
        text.Text = string.format("[%s] : %s", timestamp, message)
        text.TextColor3 = Color3.fromRGB(200, 200, 200)
        text.TextSize = 11
        text.Font = Enum.Font.SourceSans
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = ConsoleFrame

        ConsoleFrame.CanvasSize = UDim2.new(0, 0, 0, ConsoleLayout.AbsoluteContentSize.Y)
        ConsoleFrame.CanvasPosition = Vector2.new(0, ConsoleFrame.CanvasSize.Y.Offset)
    end

    -- Button functionality
    ClearButton.MouseButton1Click:Connect(function()
        for _, child in pairs(ConsoleFrame:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        ConsoleFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        addConsoleMessage("Console cleared")
    end)

    CopyButton.MouseButton1Click:Connect(function()
        setclipboard(tostring(game.GameId))
        addConsoleMessage("Copied GameId to clipboard: " .. tostring(game.GameId))
    end)

    -- Initial console messages
    addConsoleMessage("gameid -> " .. tostring(game.GameId))
    addConsoleMessage("initialized")

    -- Create Player List Page
    local PlayerListScrollFrame = Instance.new("ScrollingFrame")
    PlayerListScrollFrame.Size = UDim2.new(0.5, -5, 1, 0)
    PlayerListScrollFrame.Position = UDim2.new(0, 0, 0, 0)
    PlayerListScrollFrame.BackgroundTransparency = 1
    PlayerListScrollFrame.ScrollBarThickness = 4
    PlayerListScrollFrame.Parent = pages.PlayerListPage

    local PlayerInfoFrame = Instance.new("Frame")
    PlayerInfoFrame.Size = UDim2.new(0.5, -5, 1, 0)
    PlayerInfoFrame.Position = UDim2.new(0.5, 5, 0, 0)
    PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    PlayerInfoFrame.BorderSizePixel = 0
    PlayerInfoFrame.Parent = pages.PlayerListPage

    local PlayerInfoCorner = Instance.new("UICorner")
    PlayerInfoCorner.CornerRadius = UDim.new(0, 4)
    PlayerInfoCorner.Parent = PlayerInfoFrame

    -- Player List Functions
    local function updatePlayerList()
        -- Clear existing entries
        for _, child in pairs(PlayerListScrollFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end

        -- Create list layout
        if not PlayerListScrollFrame:FindFirstChild("UIListLayout") then
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 5)
            listLayout.Parent = PlayerListScrollFrame
        end

        -- Add players
        for _, plr in pairs(game.Players:GetPlayers()) do
            local button = Instance.new("TextButton")
            button.Name = plr.Name .. "_Button"
            button.Size = UDim2.new(1, -8, 0, 30)
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            button.Text = plr.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.AutoButtonColor = true
            button.Parent = PlayerListScrollFrame

            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 8)
            padding.Parent = button

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = button

            button.MouseButton1Click:Connect(function()
                -- Clear previous info
                for _, child in pairs(PlayerInfoFrame:GetChildren()) do
                    if child:IsA("GuiObject") and child.Name ~= "UICorner" then
                        child:Destroy()
                    end
                end

                -- Create info container
                local container = Instance.new("Frame")
                container.Name = "InfoContainer"
                container.Size = UDim2.new(1, -20, 1, -20)
                container.Position = UDim2.new(0, 10, 0, 10)
                container.BackgroundTransparency = 1
                container.Parent = PlayerInfoFrame

                -- Add player info
                local function addInfo(text, value, yPos)
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 0, 25)
                    label.Position = UDim2.new(0, 0, 0, yPos)
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.Gotham
                    label.TextSize = 14
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Text = text .. ": " .. tostring(value)
                    label.Parent = container
                    return yPos + 30
                end

                local yPos = 0
                yPos = addInfo("Username", plr.Name, yPos)
                yPos = addInfo("Display Name", plr.DisplayName, yPos)
                yPos = addInfo("User ID", plr.UserId, yPos)
                yPos = addInfo("Account Age", plr.AccountAge .. " days", yPos)
                yPos = addInfo("Team", plr.Team and plr.Team.Name or "None", yPos)
                
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    yPos = addInfo("Health", math.floor(plr.Character.Humanoid.Health) .. "/" .. math.floor(plr.Character.Humanoid.MaxHealth), yPos)
                end

                -- Add buttons
                local function createButton(text, yPos, callback)
                    local button = Instance.new("TextButton")
                    button.Size = UDim2.new(1, 0, 0, 30)
                    button.Position = UDim2.new(0, 0, 0, yPos)
                    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    button.Text = text
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextSize = 14
                    button.Font = Enum.Font.Gotham
                    button.Parent = container

                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, 4)
                    corner.Parent = button

                    button.MouseButton1Click:Connect(callback)
                    return yPos + 35
                end

                yPos = yPos + 20  -- Add some spacing
                yPos = createButton("Spectate", yPos, function()
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
                        addConsoleMessage("Spectating " .. plr.Name)
                    end
                end)

                yPos = createButton("Unspectate", yPos, function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
                        addConsoleMessage("Stopped spectating")
                    end
                end)

                yPos = createButton("Teleport", yPos, function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and 
                       game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                        addConsoleMessage("Teleported to " .. plr.Name)
                    end
                end)

                addConsoleMessage("Viewing info for " .. plr.Name)
            end)
        end

        -- Update canvas size
        local listLayout = PlayerListScrollFrame:FindFirstChild("UIListLayout")
        if listLayout then
            PlayerListScrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        end

        addConsoleMessage("Player list updated")
    end

    -- Initialize player list
    updatePlayerList()

    -- Connect PlayerAdded and PlayerRemoving events
    game.Players.PlayerAdded:Connect(function(plr)
        updatePlayerList()
        addConsoleMessage(plr.Name .. " joined the game")
    end)

    game.Players.PlayerRemoving:Connect(function(plr)
        updatePlayerList()
        addConsoleMessage(plr.Name .. " left the game")
    end)

    -- Create Settings Page
    local settingsContainer = Instance.new("Frame")
    settingsContainer.Size = UDim2.new(1, 0, 1, 0)
    settingsContainer.BackgroundTransparency = 1
    settingsContainer.Parent = pages.SettingsPage

    -- Config section
    local configSection = Instance.new("Frame")
    configSection.Size = UDim2.new(0.5, -10, 0, 200)
    configSection.Position = UDim2.new(0.5, 5, 0, 5)
    configSection.BackgroundTransparency = 1
    configSection.Parent = settingsContainer

    -- Config List
    local configList = Instance.new("ScrollingFrame")
    configList.Size = UDim2.new(1, 0, 1, -60)
    configList.Position = UDim2.new(0, 0, 0, 60)
    configList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    configList.BorderSizePixel = 0
    configList.ScrollBarThickness = 4
    configList.Parent = configSection

    -- Config system setup
    local configFolder = "Dracula/Configs"

    -- Create config folder if it doesn't exist
    if not isfolder(configFolder) then
        makefolder(configFolder)
    end

    -- Config functions
    local function saveConfig(name)
        local config = {}
        for setting, value in pairs(Config) do
            config[setting] = value
        end
        
        local success, err = pcall(function()
            writefile(configFolder .. "/" .. name .. ".cfg", game:GetService("HttpService"):JSONEncode(config))
        end)
        
        if success then
            addConsoleMessage("Saved config: " .. name)
        else
            addConsoleMessage("Failed to save config: " .. err)
        end
    end

    local function loadConfig(name)
        local success, content = pcall(function()
            return readfile(configFolder .. "/" .. name .. ".cfg")
        end)
        
        if success then
            local config = game:GetService("HttpService"):JSONDecode(content)
            for setting, value in pairs(config) do
                Config[setting] = value
            end
            addConsoleMessage("Loaded config: " .. name)
            -- Update UI to reflect loaded settings
            updateAllUI()
        else
            addConsoleMessage("Failed to load config")
        end
    end

    local function getConfigList()
        local files = listfiles(configFolder)
        local configs = {}
        for _, file in pairs(files) do
            local name = string.match(file, "([^/]+)%.cfg$")
            if name then
                table.insert(configs, name)
            end
        end
        return configs
    end

    -- Config Buttons
    local function createConfigButton(text, position, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.3, -5, 0, 25)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Parent = configSection
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        return button
    end

    createConfigButton("Load", UDim2.new(0, 5, 0, 5), function()
        local selected = configList:FindFirstChild("Selected")
        if selected then
            loadConfig(selected.Text)
        end
    end)

    createConfigButton("Save", UDim2.new(0.33, 5, 0, 5), function()
        local name = "config" .. #getConfigList() + 1
        saveConfig(name)
        updateConfigList()
    end)

    createConfigButton("Open Folder", UDim2.new(0.66, 5, 0, 5), function()
        if isfolder(configFolder) then
            os.execute('explorer.exe "' .. game:GetService("PathService"):ParsePath(configFolder) .. '"')
            addConsoleMessage("Opened config folder")
        end
    end)

    -- Function to update config list
    local function updateConfigList()
        for _, child in pairs(configList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local yPos = 5
        for _, configName in pairs(getConfigList()) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -10, 0, 25)
            item.Position = UDim2.new(0, 5, 0, yPos)
            item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            item.Text = configName
            item.TextColor3 = Color3.fromRGB(200, 200, 200)
            item.Font = Enum.Font.Gotham
            item.TextSize = 14
            item.Parent = configList
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = item
            
            item.MouseButton1Click:Connect(function()
                for _, other in pairs(configList:GetChildren()) do
                    if other:IsA("TextButton") then
                        other.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    end
                end
                item.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                item.Name = "Selected"
            end)
            
            yPos = yPos + 30
        end
    end

    -- Initial config list update
    updateConfigList()

    -- Function to update all UI elements
    function updateAllUI()
        -- Update all toggles, sliders, and dropdowns here
        -- This function should be called after loading a config
        for _, page in pairs(pages) do
            for _, child in pairs(page:GetDescendants()) do
                if child:IsA("Frame") and child:FindFirstChild("Content") then
                    for _, element in pairs(child.Content:GetChildren()) do
                        if element:IsA("Frame") then
                            local setting = element.Name
                            if element:FindFirstChild("TextButton") then
                                -- Update toggle
                                local button = element:FindFirstChild("TextButton")
                                local indicator = button:FindFirstChild("Frame")
                                if indicator then
                                    if Config.ESP[setting] ~= nil then
                                        indicator.BackgroundTransparency = Config.ESP[setting] and 0 or 1
                                    elseif Config.Aimbot[setting] ~= nil then
                                        indicator.BackgroundTransparency = Config.Aimbot[setting] and 0 or 1
                                    elseif Config.Misc[setting] ~= nil then
                                        indicator.BackgroundTransparency = Config.Misc[setting] and 0 or 1
                                    end
                                end
                            elseif element:FindFirstChild("TextLabel") and element:FindFirstChild("Frame") then
                                -- Update slider
                                local sliderBG = element:FindFirstChild("Frame")
                                local sliderFill = sliderBG:FindFirstChild("Frame")
                                local sliderButton = sliderBG:FindFirstChild("TextButton")
                                local valueLabel = element:FindFirstChild("TextLabel")
                                if sliderFill and sliderButton and valueLabel then
                                    local value, min, max
                                    if Config.ESP[setting] ~= nil then
                                        value, min, max = Config.ESP[setting], 0, 2000
                                    elseif Config.Aimbot[setting] ~= nil then
                                        value, min, max = Config.Aimbot[setting], 0, 360
                                    elseif Config.Misc[setting] ~= nil then
                                        value, min, max = Config.Misc[setting], 0, 100
                                    end
                                    if value and min and max then
                                        local pos = (value - min) / (max - min)
                                        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                                        sliderButton.Position = UDim2.new(pos, -5, 0.5, -5)
                                        valueLabel.Text = tostring(value)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Add hover effects for all buttons
    local function addButtonHoverEffect(button)
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)

        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)
    end

    -- Apply hover effects to all buttons
    for _, button in pairs(ButtonContainer:GetChildren()) do
        if button:IsA("TextButton") then
            addButtonHoverEffect(button)
        end
    end

    print("GUI creation completed")
end

return GUI
