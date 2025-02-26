local ESP = {}

function ESP.Init(config, workspace, players, runService, userInputService, localPlayer, camera)
    -- ESP settings
    local settings = config

    -- Drawing Functions
    local function NewLine()
        local line = Drawing.new("Line")
        line.Visible = false
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(1, 1)
        line.Color = settings.BoxColor
        line.Thickness = settings.BoxThickness
        line.Transparency = settings.BoxTransparency
        return line
    end

    local function NewText()
        local text = Drawing.new("Text")
        text.Visible = false
        text.Center = true
        text.Outline = true
        text.Color = settings.TextColor
        text.Size = 13
        text.Font = Drawing.Fonts.Monospace
        return text
    end

    local function NewCircle()
        local circle = Drawing.new("Circle")
        circle.Visible = false
        circle.Radius = 3
        circle.Color = settings.BoxColor
        circle.Thickness = 1
        circle.Filled = true
        return circle
    end

    local function NewSkeletonLine()
        local line = Drawing.new("Line")
        line.Visible = false
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(1, 1)
        line.Color = settings.BoxColor
        line.Thickness = 1.5
        line.Transparency = 1
        return line
    end

    -- ESP Function
    local function CreateESP(plr)
        local highlight = Instance.new("Highlight")
        highlight.FillColor = settings.OutlineColor
        highlight.OutlineColor = settings.OutlineColor
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.Enabled = false

        local lines = {
            line1 = NewLine(),
            line2 = NewLine(),
            line3 = NewLine(),
            line4 = NewLine(),
            line5 = NewLine(),
            line6 = NewLine(),
            line7 = NewLine(),
            line8 = NewLine(),
            text = NewText(),
            headDot = NewCircle(),
            healthBar = NewLine(),
            armorBar = NewLine(),
            itemText = NewText(),
            healthBarBackground = NewLine(),
            armorBarBackground = NewLine(),
            skeletonNeck = NewSkeletonLine(),
            skeletonSpineUpper = NewSkeletonLine(),
            skeletonSpineLower = NewSkeletonLine(),
            skeletonLeftUpperArm = NewSkeletonLine(),
            skeletonLeftLowerArm = NewSkeletonLine(),
            skeletonRightUpperArm = NewSkeletonLine(),
            skeletonRightLowerArm = NewSkeletonLine(),
            skeletonLeftUpperLeg = NewSkeletonLine(),
            skeletonLeftLowerLeg = NewSkeletonLine(),
            skeletonRightUpperLeg = NewSkeletonLine(),
            skeletonRightLowerLeg = NewSkeletonLine(),
            skeletonHead = NewSkeletonLine(),
            skeletonLeftShoulder = NewSkeletonLine(),
            skeletonRightShoulder = NewSkeletonLine(),
            skeletonLeftHip = NewSkeletonLine(),
            skeletonRightHip = NewSkeletonLine(),
        }

        local function UpdateSkeleton(character, onScreen)
            local function getJointPosition(part)
                if part and part:IsA("BasePart") then
                    local pos = part.Position
                    local screenPos, isOnScreen = camera:WorldToViewportPoint(pos)
                    if isOnScreen then
                        return Vector2.new(screenPos.X, screenPos.Y)
                    end
                end
                return nil
            end

            local function updateLine(line, from, to)
                if from and to then
                    line.From = from
                    line.To = to
                    line.Color = settings.SkeletonColor
                    line.Thickness = 1.5
                    line.Transparency = 1
                    line.Visible = onScreen
                else
                    line.Visible = false
                end
            end

            -- Get all joint positions
            local head = getJointPosition(character:FindFirstChild("Head"))
            local upperTorso = getJointPosition(character:FindFirstChild("UpperTorso"))
            local lowerTorso = getJointPosition(character:FindFirstChild("LowerTorso"))
            local torso = getJointPosition(character:FindFirstChild("Torso")) -- R6 fallback

            -- Arms
            local leftUpperArm = getJointPosition(character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"))
            local leftLowerArm = getJointPosition(character:FindFirstChild("LeftLowerArm"))
            local leftHand = getJointPosition(character:FindFirstChild("LeftHand"))
            
            local rightUpperArm = getJointPosition(character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"))
            local rightLowerArm = getJointPosition(character:FindFirstChild("RightLowerArm"))
            local rightHand = getJointPosition(character:FindFirstChild("RightHand"))

            -- Legs
            local leftUpperLeg = getJointPosition(character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"))
            local leftLowerLeg = getJointPosition(character:FindFirstChild("LeftLowerLeg"))
            local leftFoot = getJointPosition(character:FindFirstChild("LeftFoot"))
            
            local rightUpperLeg = getJointPosition(character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"))
            local rightLowerLeg = getJointPosition(character:FindFirstChild("RightLowerLeg"))
            local rightFoot = getJointPosition(character:FindFirstChild("RightFoot"))

            -- Reference points
            local mainTorso = upperTorso or torso
            local bottomTorso = lowerTorso or torso

            -- Draw complete skeleton
            -- Head and Torso
            updateLine(lines.skeletonHead, head, mainTorso)
            updateLine(lines.skeletonSpineUpper, upperTorso, lowerTorso)

            -- Left Arm
            updateLine(lines.skeletonLeftShoulder, mainTorso, leftUpperArm)
            updateLine(lines.skeletonLeftUpperArm, leftUpperArm, leftLowerArm)
            updateLine(lines.skeletonLeftLowerArm, leftLowerArm, leftHand)

            -- Right Arm
            updateLine(lines.skeletonRightShoulder, mainTorso, rightUpperArm)
            updateLine(lines.skeletonRightUpperArm, rightUpperArm, rightLowerArm)
            updateLine(lines.skeletonRightLowerArm, rightLowerArm, rightHand)

            -- Left Leg
            updateLine(lines.skeletonLeftHip, bottomTorso, leftUpperLeg)
            updateLine(lines.skeletonLeftUpperLeg, leftUpperLeg, leftLowerLeg)
            updateLine(lines.skeletonLeftLowerLeg, leftLowerLeg, leftFoot)

            -- Right Leg
            updateLine(lines.skeletonRightHip, bottomTorso, rightUpperLeg)
            updateLine(lines.skeletonRightUpperLeg, rightUpperLeg, rightLowerLeg)
            updateLine(lines.skeletonRightLowerLeg, rightLowerLeg, rightFoot)
        end

        local function UpdateESP()
            local connection
            connection = runService.RenderStepped:Connect(function()
                if not settings.Enabled then
                    for _, drawing in pairs(lines) do
                        drawing.Visible = false
                    end
                    return
                end

                if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
                    local humanoid = plr.Character.Humanoid
                    local rootPart = plr.Character.HumanoidRootPart
                    local head = plr.Character:FindFirstChild("Head")

                    if not head then return end

                    local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                    local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

                    if onScreen and distance <= settings.Distance then
                        local size = Vector2.new(2000 / distance, 2000 / distance)
                        local screenSize = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

                        -- Team Check
                        if settings.TeamCheck and plr.Team == localPlayer.Team then
                            for _, drawing in pairs(lines) do
                                drawing.Visible = false
                            end
                            return
                        end

                        -- Self ESP Check
                        if not settings.SelfESP and plr == localPlayer then
                            for _, drawing in pairs(lines) do
                                drawing.Visible = false
                            end
                            return
                        end

                        -- Box ESP
                        if settings.ShowBoxes then
                            local boxSize = Vector2.new(size.X * 2, size.Y * 3)
                            local boxPosition = Vector2.new(screenPos.X - size.X, screenPos.Y - size.Y * 1.5)

                            if settings.BoxType == "Corners" then
                                -- Draw corner box
                                local cornerSize = boxSize.X * 0.2

                                -- Top left
                                lines.line1.From = boxPosition
                                lines.line1.To = boxPosition + Vector2.new(cornerSize, 0)
                                lines.line2.From = boxPosition
                                lines.line2.To = boxPosition + Vector2.new(0, cornerSize)

                                -- Top right
                                lines.line3.From = boxPosition + Vector2.new(boxSize.X, 0)
                                lines.line3.To = boxPosition + Vector2.new(boxSize.X - cornerSize, 0)
                                lines.line4.From = boxPosition + Vector2.new(boxSize.X, 0)
                                lines.line4.To = boxPosition + Vector2.new(boxSize.X, cornerSize)

                                -- Bottom left
                                lines.line5.From = boxPosition + Vector2.new(0, boxSize.Y)
                                lines.line5.To = boxPosition + Vector2.new(cornerSize, boxSize.Y)
                                lines.line6.From = boxPosition + Vector2.new(0, boxSize.Y)
                                lines.line6.To = boxPosition + Vector2.new(0, boxSize.Y - cornerSize)

                                -- Bottom right
                                lines.line7.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
                                lines.line7.To = boxPosition + Vector2.new(boxSize.X - cornerSize, boxSize.Y)
                                lines.line8.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
                                lines.line8.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y - cornerSize)

                                for i = 1, 8 do
                                    lines["line"..i].Visible = true
                                    lines["line"..i].Color = settings.BoxColor
                                    lines["line"..i].Thickness = settings.BoxThickness
                                    lines["line"..i].Transparency = 1
                                end
                            else
                                -- Draw full box
                                lines.line1.From = boxPosition
                                lines.line1.To = boxPosition + Vector2.new(boxSize.X, 0)
                                lines.line2.From = boxPosition + Vector2.new(boxSize.X, 0)
                                lines.line2.To = boxPosition + boxSize
                                lines.line3.From = boxPosition + boxSize
                                lines.line3.To = boxPosition + Vector2.new(0, boxSize.Y)
                                lines.line4.From = boxPosition
                                lines.line4.To = boxPosition + Vector2.new(0, boxSize.Y)

                                for i = 1, 4 do
                                    lines["line"..i].Visible = true
                                    lines["line"..i].Color = settings.BoxColor
                                    lines["line"..i].Thickness = settings.BoxThickness
                                    lines["line"..i].Transparency = 1
                                end
                                for i = 5, 8 do
                                    lines["line"..i].Visible = false
                                end
                            end
                        else
                            for i = 1, 8 do
                                lines["line"..i].Visible = false
                            end
                        end

                        -- Outline ESP
                        if settings.Outline then
                            if plr.Character then
                                highlight.Parent = plr.Character
                                highlight.Enabled = true
                                highlight.FillColor = settings.OutlineColor
                                highlight.OutlineColor = settings.OutlineColor
                            end
                        else
                            highlight.Enabled = false
                            highlight.Parent = nil
                        end

                        -- Name ESP
                        if settings.ShowNames then
                            lines.text.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y * 2)
                            lines.text.Text = plr.Name
                            lines.text.Color = settings.NameColor
                            lines.text.Visible = true
                        else
                            lines.text.Visible = false
                        end

                        -- Head Dot
                        if settings.ShowHeadDot and head then
                            local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                            if onScreen then
                                local headSize = head.Size.Y
                                local distance = (camera.CFrame.Position - head.Position).Magnitude
                                local screenSize = headSize * 1000 / distance
                                
                                lines.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                                lines.headDot.Radius = screenSize / 2
                                lines.headDot.Visible = true
                                lines.headDot.Color = settings.HeadDotColor
                                lines.headDot.Filled = false
                                lines.headDot.Thickness = 1.5
                            else
                                lines.headDot.Visible = false
                            end
                        else
                            lines.headDot.Visible = false
                        end

                        -- Health Bar
                        if settings.ShowHealthBars then
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            local barPos = Vector2.new(screenPos.X - size.X - 5, screenPos.Y - size.Y * 1.5)
                            local barSize = Vector2.new(0, size.Y * 3)
                        
                            -- Background bar
                            lines.healthBarBackground.From = barPos
                            lines.healthBarBackground.To = barPos + Vector2.new(0, barSize.Y)
                            lines.healthBarBackground.Color = Color3.fromRGB(25, 25, 25)
                            lines.healthBarBackground.Thickness = 4
                            lines.healthBarBackground.Visible = true
                        
                            -- Health bar
                            local healthBarStart = barPos
                            local healthBarEnd = barPos + Vector2.new(0, barSize.Y)
                            local currentHeight = barSize.Y * (1 - healthPercent)
                            lines.healthBar.From = healthBarStart + Vector2.new(0, currentHeight)
                            lines.healthBar.To = healthBarEnd
                            
                            if healthPercent > 0.75 then
                                lines.healthBar.Color = Color3.fromRGB(0, 255, 0)
                            elseif healthPercent > 0.5 then
                                lines.healthBar.Color = Color3.fromRGB(255, 255, 0)
                            else
                                lines.healthBar.Color = Color3.fromRGB(255, 0, 0)
                            end
                            
                            lines.healthBar.Thickness = 2
                            lines.healthBar.Visible = true
                        else
                            lines.healthBarBackground.Visible = false
                            lines.healthBar.Visible = false
                        end

                        -- Armor Bar
                        if settings.ShowArmorBar then
                            -- Implement armor bar logic here if the game has an armor system
                            -- This is a placeholder as not all games have armor
                            lines.armorBar.Visible = false
                            lines.armorBarBackground.Visible = false
                        end

                        -- Distance
                        if settings.ShowDistance then
                            local distanceText = string.format("%.1f m", distance)
                            lines.itemText.Text = distanceText
                            lines.itemText.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y * 1.5)
                            lines.itemText.Color = settings.DistanceColor
                            lines.itemText.Visible = true
                        else
                            lines.itemText.Visible = false
                        end

                        -- Skeleton ESP
                        if settings.ShowSkeleton then
                            UpdateSkeleton(plr.Character, onScreen)
                        else
                            for _, line in pairs({
                                lines.skeletonHead, lines.skeletonSpineUpper, lines.skeletonSpineLower,
                                lines.skeletonLeftUpperArm, lines.skeletonLeftLowerArm,
                                lines.skeletonRightUpperArm, lines.skeletonRightLowerArm,
                                lines.skeletonLeftUpperLeg, lines.skeletonLeftLowerLeg,
                                lines.skeletonRightUpperLeg, lines.skeletonRightLowerLeg,
                                lines.skeletonLeftShoulder, lines.skeletonRightShoulder,
                                lines.skeletonLeftHip, lines.skeletonRightHip
                            }) do
                                line.Visible = false
                            end
                        end
                    else
                        for _, drawing in pairs(lines) do
                            drawing.Visible = false
                        end
                    end
                else
                    for _, drawing in pairs(lines) do
                        drawing.Visible = false
                    end
                end
            end)
        end

        UpdateESP()
    end

    -- Initialize ESP for all players
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= localPlayer then
            CreateESP(plr)
        end
    end

    -- Connect player added event
    players.PlayerAdded:Connect(function(plr)
        CreateESP(plr)
    end)
end

return ESP
