local GUI = {}

function GUI.Create(Config, ESP, Aimbot)
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
    local VisualsPage = Instance.new("Frame")
    VisualsPage.Size = UDim2.new(1, 0, 1, 0)
    VisualsPage.BackgroundTransparency = 1
    VisualsPage.Visible = true
    VisualsPage.Parent = Container

    local AimingPage = Instance.new("Frame")
    AimingPage.Size = UDim2.new(1, 0, 1, 0)
    AimingPage.BackgroundTransparency = 1
    AimingPage.Visible = false
    AimingPage.Parent = Container

    local MiscPage = Instance.new("Frame")
    MiscPage.Size = UDim2.new(1, 0, 1, 0)
    MiscPage.BackgroundTransparency = 1
    MiscPage.Visible = false
    MiscPage.Parent = Container

    local OutputPage = Instance.new("Frame")
    OutputPage.Size = UDim2.new(1, 0, 1, 0)
    OutputPage.BackgroundTransparency = 1
    OutputPage.Visible = false
    OutputPage.Parent = Container

    local PlayerListPage = Instance.new("Frame")
    PlayerListPage.Size = UDim2.new(1, 0, 1, 0)
    PlayerListPage.BackgroundTransparency = 1
    PlayerListPage.Visible = false
    PlayerListPage.Parent = Container

    local SettingsPage = Instance.new("Frame")
    SettingsPage.Size = UDim2.new(1, 0, 1, 0)
    SettingsPage.BackgroundTransparency = 1
    SettingsPage.Visible = false
    SettingsPage.Parent = Container

    -- Function to update nav colors
    local function updateNavColors()
        for name, button in pairs(navButtons) do
            button.TextColor3 = name == Config.CurrentPage and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
        end
    end

    -- Create nav buttons
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
            Config.CurrentPage = name
            updateNavColors()
            
            VisualsPage.Visible = name == "visual"
            AimingPage.Visible = name == "aiming"
            MiscPage.Visible = name == "misc"
            OutputPage.Visible = name == "output"
            PlayerListPage.Visible = name == "player-list"
            SettingsPage.Visible = name == "settings"

            if name == "player-list" then
                -- updatePlayerList()
            end
            print("Switched to " .. name .. " page")
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

    local function createToggle(name, parent, position, setting)
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
            indicator.BackgroundTransparency = Config.ESP[setting] and 0 or 1
        end

        updateToggle()
        button.MouseButton1Click:Connect(function()
            Config.ESP[setting] = not Config.ESP[setting]
            updateToggle()
            print(name .. " toggled " .. (Config.ESP[setting] and "on" or "off"))
        end)

        return toggleFrame
    end

    local function createDropdown(name, parent, position, options, setting)
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
        button.Text = Config.ESP[setting]
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
                Config.ESP[setting] = option
                button.Text = option
                optionsFrame.Visible = false
                print(name .. " set to " .. option)
            end)
        end

        button.MouseButton1Click:Connect(function()
            optionsFrame.Visible = not optionsFrame.Visible
        end)

        return dropdownFrame
    end

    local function createSlider(name, parent, position, setting, min, max)
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
        sliderFill.Size = UDim2.new((Config.ESP[setting] - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBG

        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 10, 0, 10)
        sliderButton.Position = UDim2.new((Config.ESP[setting] - min) / (max - min), -5, 0.5, -5)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.Parent = sliderBG

        local sliderButtonCorner = Instance.new("UICorner")
        sliderButtonCorner.CornerRadius = UDim.new(0, 5)
        sliderButtonCorner.Parent = sliderButton

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Text = tostring(Config.ESP[setting])
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
                print(name .. " set to " .. Config.ESP[setting])
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = (input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X
                pos = math.clamp(pos, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                Config.ESP[setting] = value
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                sliderButton.Position = UDim2.new(pos, -5, 0.5, -5)
                valueLabel.Text = tostring(value)
            end
        end)

        return sliderFrame
    end

    -- Create Visual Page
    local LeftColumn = Instance.new("Frame")
    LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Parent = VisualsPage

    local RightColumn = Instance.new("Frame")
    RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
    RightColumn.BackgroundTransparency = 1
    RightColumn.Parent = VisualsPage

    -- ESP Section
    local espContent, updateESPHeight = createSection("ESP", LeftColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Enabled", espContent, UDim2.new(0, 0, 0, 0), "Enabled")
    createToggle("Team Check", espContent, UDim2.new(0, 0, 0, 25), "TeamCheck")
    createToggle("Outline", espContent, UDim2.new(0, 0, 0, 50), "Outline")
    createToggle("Self ESP", espContent, UDim2.new(0, 0, 0, 75), "SelfESP")
    createSlider("Distance", espContent, UDim2.new(0, 0, 0, 100), "Distance", 0, 2000)
    updateESPHeight()

    -- Box Settings Section
    local boxContent, updateBoxHeight = createSection("Box", LeftColumn, UDim2.new(0, 0, 0, 200))
    createToggle("Enabled", boxContent, UDim2.new(0, 0, 0, 0), "ShowBoxes")
    createToggle("Fill Box", boxContent, UDim2.new(0, 0, 0, 25), "FillBox")
    createDropdown("Box Type", boxContent, UDim2.new(0, 0, 0, 50), {"Corners", "Full"}, "BoxType")
    updateBoxHeight()

    -- Name Settings Section
    local nameContent, updateNameHeight = createSection("Name", RightColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Enabled", nameContent, UDim2.new(0, 0, 0, 0), "ShowNames")
    updateNameHeight()

    -- Other Settings Section
    local otherContent, updateOtherHeight = createSection("Other", RightColumn, UDim2.new(0, 0, 0, 50))
    createToggle("Equipped Item", otherContent, UDim2.new(0, 0, 0, 0), "ShowEquippedItem")
    createToggle("Skeleton", otherContent, UDim2.new(0, 0, 0, 25), "ShowSkeleton")
    createToggle("Head Dot", otherContent, UDim2.new(0, 0, 0, 50), "ShowHeadDot")
    createToggle("Distance", otherContent, UDim2.new(0, 0, 0, 75), "ShowDistance")
    createToggle("Armor Bar", otherContent, UDim2.new(0, 0, 0, 100), "ShowArmorBar")
    updateOtherHeight()

    -- Create Aiming Page
    local AimingLeftColumn = Instance.new("Frame")
    AimingLeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    AimingLeftColumn.BackgroundTransparency = 1
    AimingLeftColumn.Parent = AimingPage

    local AimingRightColumn = Instance.new("Frame")
    AimingRightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    AimingRightColumn.Position = UDim2.new(0.5, 5, 0, 0)
    AimingRightColumn.BackgroundTransparency = 1
    AimingRightColumn.Parent = AimingPage

    -- Aimbot Main Section
    local aimbotContent, updateAimbotHeight = createSection("Aimbot", AimingLeftColumn, UDim2.new(0, 0, 0, 0))

    -- Create toggle and keybind container
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(1, 0, 0, 25)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = aimbotContent

    -- Create toggle
    local enabledToggle = createToggle("Enabled", toggleContainer, UDim2.new(0, 0, 0, 0), "Enabled")
    enabledToggle.Size = UDim2.new(0.7, 0, 1, 0)

    -- Create keybind button
    local toggleKeybind = Instance.new("TextButton")
    toggleKeybind.Size = UDim2.new(0.25, 0, 1, 0)
    toggleKeybind.Position = UDim2.new(0.75, 0, 0, 0)
    toggleKeybind.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleKeybind.Text = "[ " .. Config.Aimbot.ToggleKey .. " ]"
    toggleKeybind.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleKeybind.TextSize = 12
    toggleKeybind.Font = Enum.Font.Gotham
    toggleKeybind.Parent = toggleContainer

    local toggleKeybindCorner = Instance.new("UICorner")
    toggleKeybindCorner.CornerRadius = UDim.new(0, 4)
    toggleKeybindCorner.Parent = toggleKeybind

    local toggleListening = false

    toggleKeybind.MouseButton1Click:Connect(function()
        if not toggleListening then
            toggleListening = true
            toggleKeybind.Text = "[ ... ]"
            
            local connection
            connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Config.Aimbot.ToggleKey = input.KeyCode.Name
                    toggleKeybind.Text = "[ " .. Config.Aimbot.ToggleKey .. " ]"
                    toggleListening = false
                    connection:Disconnect()
                    print("Aimbot toggle key set to " .. Config.Aimbot.ToggleKey)
                end
            end)
        end
    end)

    createToggle("Team Check", aimbotContent, UDim2.new(0, 0, 0, 25), "TeamCheck")
    createToggle("Visibility Check", aimbotContent, UDim2.new(0, 0, 0, 50), "VisibilityCheck")
    createToggle("Wall Check", aimbotContent, UDim2.new(0, 0, 0, 75), "WallCheck")
    createToggle("Lock Target", aimbotContent, UDim2.new(0, 0, 0, 100), "LockTarget")
    createToggle("Sticky Aim", aimbotContent, UDim2.new(0, 0, 0, 125), "StickyAim")
    createSlider("FOV", aimbotContent, UDim2.new(0, 0, 0, 150), "FOV", 0, 360)
    updateAimbotHeight()

    -- Target Selection Section
    local targetContent, updateTargetHeight = createSection("Target Selection", AimingLeftColumn, UDim2.new(0, 0, 0, 220))
    createToggle("Head", targetContent, UDim2.new(0, 0, 0, 0), "Hitboxes.head")
    createToggle("Torso", targetContent, UDim2.new(0, 0, 0, 25), "Hitboxes.torso")
    createToggle("Arms", targetContent, UDim2.new(0, 0, 0, 50), "Hitboxes.arms")
    createToggle("Legs", targetContent, UDim2.new(0, 0, 0, 75), "Hitboxes.legs")
    updateTargetHeight()

    -- Smoothing Section
    local smoothingContent, updateSmoothingHeight = createSection("Smoothing", AimingRightColumn, UDim2.new(0, 0, 0, 0))
    createToggle("Use Mouse Sensitivity", smoothingContent, UDim2.new(0, 0, 0, 0), "UseMouseSensitivity")
    createSlider("Start", smoothingContent, UDim2.new(0, 0, 0, 25), "StartSmoothing", 1, 100)
    createSlider("End", smoothingContent, UDim2.new(0, 0, 0, 70), "EndSmoothing", 1, 100)
    createSlider("Delay", smoothingContent, UDim2.new(0, 0, 0, 115), "SmoothingDelay", 1, 1000)
    createDropdown("Animation", smoothingContent, UDim2.new(0, 0, 0, 160), {"linear", "exponential", "sine"}, "SmoothingAnimation")
    updateSmoothingHeight()

    -- Prediction Section
    local predictionContent, updatePredictionHeight = createSection("Prediction", AimingRightColumn, UDim2.new(0, 0, 0, 250))
    createToggle("Enabled", predictionContent, UDim2.new(0, 0, 0, 0), "Prediction")
    createToggle("Auto Prediction", predictionContent, UDim2.new(0, 0, 0, 25), "AutoPrediction")
    createToggle("Custom Calculation", predictionContent, UDim2.new(0, 0, 0, 50), "CustomCalculation")
    createSlider("Calculation Speed", predictionContent, UDim2.new(0, 0, 0, 75), "CalculationSpeed", 100, 2000)
    updatePredictionHeight()

    -- Keybind Section
    local keybindContent, updateKeybindHeight = createSection("Keybind", AimingRightColumn, UDim2.new(0, 0, 0, 400))

    -- Create keybind button
    local keybindButton = Instance.new("TextButton")
    keybindButton.Size = UDim2.new(1, 0, 0, 30)
    keybindButton.Position = UDim2.new(0, 0, 0, 0)
    keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keybindButton.Text = "[ " .. Config.Aimbot.AimKey .. " ]"
    keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindButton.TextSize = 14
    keybindButton.Font = Enum.Font.Gotham
    keybindButton.Parent = keybindContent

    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 4)
    keybindCorner.Parent = keybindButton

    local listening = false

    keybindButton.MouseButton1Click:Connect(function()
        if not listening then
            listening = true
            keybindButton.Text = "[ ... ]"
            
            local connection
            connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Config.Aimbot.AimKey = input.KeyCode.Name
                    keybindButton.Text = "[ " .. Config.Aimbot.AimKey .. " ]"
                    listening = false
                    connection:Disconnect()
                    print("Aimbot key set to " .. Config.Aimbot.AimKey)
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Config.Aimbot.AimKey = "MouseButton1"
                    keybindButton.Text = "[ MB1 ]"
                    listening = false
                    connection:Disconnect()
                    print("Aimbot key set to MouseButton1")
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Config.Aimbot.AimKey = "MouseButton2"
                    keybindButton.Text = "[ MB2 ]"
                    listening = false
                    connection:Disconnect()
                    print("Aimbot key set to MouseButton2")
                end
            end)
        end
    end)

    updateKeybindHeight()

    -- FOV Circle
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 100
    FOVCircle.Radius = 0
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.ZIndex = 999
    FOVCircle.Transparency = 1
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)

    -- Update FOV Circle
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Aimbot.Enabled then
            FOVCircle.Position = Vector2.new(game:GetService("Workspace").CurrentCamera.ViewportSize.X / 2, game:GetService("Workspace").CurrentCamera.ViewportSize.Y / 2)
            FOVCircle.Radius = Config.Aimbot.FOV
            FOVCircle.Visible = true
        else
            FOVCircle.Visible = false
        end
    end)
end

return GUI