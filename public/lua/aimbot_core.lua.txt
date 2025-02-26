local Aimbot = {}

function Aimbot.Init(config, workspace, players, runService, userInputService, localPlayer, camera)
    -- Aimbot settings
    local settings = config

    -- Aimbot Functions
    local function IsPartVisible(part)
        local character = localPlayer.Character
        if not character or not character:FindFirstChild("Head") then return false end
        
        local rayOrigin = character.Head.Position
        local rayDirection = (part.Position - rayOrigin).Unit
        local rayDistance = (part.Position - rayOrigin).Magnitude
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local raycastResult = workspace:Raycast(rayOrigin, rayDirection * rayDistance, raycastParams)
        return raycastResult == nil
    end

    local function GetTargetPart(character)
        if not character then return nil end
        
        local targetParts = {}
        if settings.Hitboxes.head and character:FindFirstChild("Head") then
            table.insert(targetParts, character.Head)
        end
        if settings.Hitboxes.torso and character:FindFirstChild("UpperTorso") then
            table.insert(targetParts, character.UpperTorso)
        elseif settings.Hitboxes.torso and character:FindFirstChild("Torso") then
            table.insert(targetParts, character.Torso)
        end
        if settings.Hitboxes.arms then
            if character:FindFirstChild("LeftUpperArm") then table.insert(targetParts, character.LeftUpperArm) end
            if character:FindFirstChild("RightUpperArm") then table.insert(targetParts, character.RightUpperArm) end
        end
        if settings.Hitboxes.legs then
            if character:FindFirstChild("LeftUpperLeg") then table.insert(targetParts, character.LeftUpperLeg) end
            if character:FindFirstChild("RightUpperLeg") then table.insert(targetParts, character.RightUpperLeg) end
        end
        
        -- Sort parts by priority (head > torso > limbs)
        table.sort(targetParts, function(a, b)
            if a.Name == "Head" then return true end
            if b.Name == "Head" then return false end
            if a.Name:find("Torso") then return true end
            if b.Name:find("Torso") then return false end
            return false
        end)
        
        for _, part in ipairs(targetParts) do
            if not settings.VisibilityCheck or IsPartVisible(part) then
                return part
            end
        end
        
        return nil
    end

    local function PredictPosition(part)
        if not settings.Prediction then return part.Position end
        
        local velocity = part.Velocity
        local distance = (part.Position - camera.CFrame.Position).Magnitude
        local timeToTarget = distance / settings.CalculationSpeed
        
        if settings.AutoPrediction then
            timeToTarget = distance / 1000
        end
        
        return part.Position + (velocity * timeToTarget)
    end

    local function GetClosestPlayerWithChecks()
        local closestPlayer = nil
        local shortestDistance = math.huge
        local mousePos = userInputService:GetMouseLocation()
        
        for _, plr in pairs(players:GetPlayers()) do
            if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and 
               plr.Character.Humanoid.Health > 0 then
                
                -- Team Check
                if settings.TeamCheck and plr.Team == localPlayer.Team then
                    continue
                end
                
                local targetPart = GetTargetPart(plr.Character)
                if not targetPart then continue end
                
                local predictedPos = PredictPosition(targetPart)
                local screenPos, onScreen = camera:WorldToViewportPoint(predictedPos)
                if not onScreen then continue end
                
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if distance <= settings.FOV and distance < shortestDistance then
                    closestPlayer = {
                        Player = plr,
                        Part = targetPart,
                        Position = predictedPos,
                        Distance = distance
                    }
                    shortestDistance = distance
                end
            end
        end
        
        return closestPlayer
    end

    -- Smoothing Functions
    local function LinearSmoothing(current, target, factor)
        return current + (target - current) * factor
    end

    local function ExponentialSmoothing(current, target, factor)
        return current + (target - current) * (1 - math.exp(-factor))
    end

    local function SineSmoothing(current, target, factor)
        return current + (target - current) * math.sin(factor * math.pi / 2)
    end

    local function ApplySmoothing(current, target)
        local startFactor = settings.StartSmoothing / 100
        local endFactor = settings.EndSmoothing / 100
        local distance = (target - current).Magnitude
        local factor = startFactor + (endFactor - startFactor) * (distance / settings.FOV)
        
        if settings.SmoothingAnimation == "exponential" then
            return ExponentialSmoothing(current, target, factor)
        elseif settings.SmoothingAnimation == "sine" then
            return SineSmoothing(current, target, factor)
        else
            return LinearSmoothing(current, target, factor)
        end
    end

    -- Aimbot Logic
    local lastTarget = nil
    local isAiming = false
    local targetLockTime = 0
    local aimToggled = false

    -- Handle toggle key
    userInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and 
           input.KeyCode.Name == settings.ToggleKey then
            aimToggled = not aimToggled
            print("Aimbot " .. (aimToggled and "enabled" or "disabled"))
        end
    end)

    -- Improved aimbot logic
    runService.RenderStepped:Connect(function()
        if not settings.Enabled or not aimToggled then
            isAiming = false
            lastTarget = nil
            targetLockTime = 0
            return
        end
        
        local mousePressed = false
        if settings.AimKey == "MouseButton1" then
            mousePressed = userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        elseif settings.AimKey == "MouseButton2" then
            mousePressed = userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        else
            mousePressed = userInputService:IsKeyDown(Enum.KeyCode[settings.AimKey])
        end
        
        if not mousePressed and not settings.StickyAim then
            isAiming = false
            lastTarget = nil
            targetLockTime = 0
            return
        end
        
        -- Check if we should keep current target
        if settings.LockTarget and lastTarget and lastTarget.Player.Character then
            local lastTargetPart = GetTargetPart(lastTarget.Player.Character)
            if lastTargetPart and lastTarget.Player.Character.Humanoid.Health > 0 then
                if targetLockTime < settings.MaxLockTime then
                    local screenPos, onScreen = camera:WorldToViewportPoint(PredictPosition(lastTargetPart))
                    if onScreen then
                        lastTarget.Part = lastTargetPart
                        lastTarget.Position = PredictPosition(lastTargetPart)
                        targetLockTime = targetLockTime + runService.RenderStepped:Wait()
                    else
                        lastTarget = nil
                        targetLockTime = 0
                    end
                else
                    lastTarget = nil
                    targetLockTime = 0
                end
            else
                lastTarget = nil
                targetLockTime = 0
            end
        end
        
        -- Get new target if needed
        if not lastTarget then
            local target = GetClosestPlayerWithChecks()
            if target then
                lastTarget = target
                targetLockTime = 0
            end
        end
        
        -- Apply aim
        if lastTarget then
            isAiming = true
            
            local targetScreenPos = camera:WorldToViewportPoint(lastTarget.Position)
            local mousePos = userInputService:GetMouseLocation()
            local targetPos = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
            
            if settings.UseMouseSensitivity then
                local sensitivity = userInputService.MouseDeltaSensitivity
                targetPos = targetPos * sensitivity
            end
            
            -- Improved smoothing with initial snap
            local smoothedPos
            if targetLockTime < settings.SnapSpeed then
                -- Fast initial snap
                smoothedPos = targetPos
            else
                -- Smooth tracking
                smoothedPos = ApplySmoothing(mousePos, targetPos)
            end
            
            local delta = smoothedPos - mousePos
            mousemoverel(delta.X, delta.Y)
        else
            isAiming = false
        end
    end)
end

return Aimbot
