local Config = {
    ESP = {
        Enabled = false,
        TeamCheck = false,
        Outline = false,
        SelfESP = false,
        ShowNames = true,
        ShowBoxes = true,
        ShowHealthBars = true,
        ShowEquippedItem = false,
        ShowSkeleton = false,
        ShowArmorBar = false,
        ShowHeadDot = false,
        FillBox = false,
        ShowDistance = false,
        OutlineColor = Color3.new(1, 1, 1),
        OutlineThickness = 3,
        BoxColor = Color3.fromRGB(255, 255, 255),
        BoxThickness = 1.4,
        BoxTransparency = 1,
        TextColor = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Distance = 1000,
        BoxType = "Corners",
        ArmorBarColor = Color3.fromRGB(0, 150, 255),
        NameColor = Color3.fromRGB(255, 255, 255),
        EquippedItemColor = Color3.fromRGB(255, 255, 255),
        SkeletonColor = Color3.fromRGB(255, 255, 255),
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        DistanceColor = Color3.fromRGB(255, 255, 255),
    },
    Aimbot = {
        Enabled = false,
        ToggleKey = "E",
        AimKey = "MouseButton2",
        FOV = 100,
        TeamCheck = true,
        VisibilityCheck = true,
        WallCheck = true,
        StickyAim = true,
        Hitboxes = {head = true, torso = false, arms = false, legs = false},
        UseMouseSensitivity = false,
        StartSmoothing = 20,
        EndSmoothing = 40,
        SmoothingDelay = 50,
        SmoothingAnimation = "exponential",
        Prediction = true,
        AutoPrediction = true,
        CustomCalculation = false,
        CalculationSpeed = 1000,
        LockTarget = true,
        MaxLockTime = 5,
        SnapSpeed = 0.2,
    },
    CurrentPage = "visual"
}

function Config.Init()
    -- Any initialization logic can go here
    print("Configuration initialized")
end

return Config
