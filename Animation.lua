--[[ Made by MRGLUCKINGBALL & R_MP6 ]]
 
------------------- SETTINGS -------------------
 
local KEY_MOVESET1 = Enum.KeyCode.Z
 
local IdleAnimId = "rbxassetid://91348372558295"
local WalkAnimId = "rbxassetid://134010853417610"
local Move1AnimId = "rbxassetid://129469072457859"
 
local Move1Cooldown = 3
 
-- Move1 timing
local MOVE1_START_TIME = 6
local MOVE1_FIRST_DURATION = 2
local MOVE1_SECOND_DURATION = 6

-- Fast walk settings
local WALK_SPEED = 16
local FAST_WALK_SPEED = 28

-- NEW: animation speed settings
local WALK_ANIM_SPEED = 1
local FAST_WALK_ANIM_SPEED = 1.6
 
------------------------------------------------
 
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
 
local player = Players.LocalPlayer
 
------------------------------------------------
-- SETUP FUNCTION
------------------------------------------------
 
local function Setup(char)
    local humanoid = char:WaitForChild("Humanoid")
 
    task.wait(0.2)
    local animate = char:FindFirstChild("Animate")
    if animate then animate.Disabled = true end
 
    ------------------------------------------------
    -- BASE ANIMATIONS
    ------------------------------------------------
 
    local idle = Instance.new("Animation")
    idle.AnimationId = IdleAnimId
    local idleTrack = humanoid:LoadAnimation(idle)
    idleTrack.Looped = true
    idleTrack.Priority = Enum.AnimationPriority.Movement
 
    local walk = Instance.new("Animation")
    walk.AnimationId = WalkAnimId
    local walkTrack = humanoid:LoadAnimation(walk)
    walkTrack.Looped = true
    walkTrack.Priority = Enum.AnimationPriority.Movement

    -- default anim speed
    walkTrack.Speed = WALK_ANIM_SPEED
 
    local customMovementEnabled = true

    -- walk speed state
    humanoid.WalkSpeed = WALK_SPEED
    local isFastWalking = false
 
    ------------------------------------------------
    -- CUSTOM MOVEMENT FUNCTIONS
    ------------------------------------------------
 
    local function enableCustomMovement()
        customMovementEnabled = true
        idleTrack:Play()

        humanoid.WalkSpeed = isFastWalking and FAST_WALK_SPEED or WALK_SPEED
        walkTrack.Speed = isFastWalking and FAST_WALK_ANIM_SPEED or WALK_ANIM_SPEED

        if animate then animate.Disabled = true end
    end
 
    local function disableCustomMovement()
        customMovementEnabled = false
        idleTrack:Stop()
        walkTrack:Stop()
        if animate then animate.Disabled = false end
    end
 
    enableCustomMovement()
 
    humanoid.Running:Connect(function(speed)
        if not customMovementEnabled then return end
        if speed > 1 then
            if not walkTrack.IsPlaying then
                idleTrack:Stop()
                walkTrack:Play()
            end
        else
            if not idleTrack.IsPlaying then
                walkTrack:Stop()
                idleTrack:Play()
            end
        end
    end)
 
    ------------------------------------------------
    -- MOVE1 ANIMATION
    ------------------------------------------------
 
    local move1 = Instance.new("Animation")
    move1.AnimationId = Move1AnimId
    local move1Track = humanoid:LoadAnimation(move1)
    move1Track.Priority = Enum.AnimationPriority.Action
 
    local move1Ready = true
    local move1Toggled = false
    local isUsingMove = false
 
    local function PlayMove1()
        if not move1Ready or isUsingMove then return end
        isUsingMove = true
        move1Ready = false
 
        task.delay(Move1Cooldown, function()
            move1Ready = true
        end)
 
        move1Track:Stop()
        move1Track:Play()
        RunService.Heartbeat:Wait()
 
        if not move1Toggled then
            -- FIRST PRESS
            move1Track.TimePosition = MOVE1_START_TIME
            disableCustomMovement()
            move1Toggled = true
 
            task.delay(MOVE1_FIRST_DURATION, function()
                if move1Track.IsPlaying then
                    move1Track:Stop()
                end
                isUsingMove = false
            end)
        else
            -- SECOND PRESS
            move1Track.TimePosition = 0
 
            task.delay(0.05, function()
                enableCustomMovement()
                move1Toggled = false
            end)
 
            task.delay(MOVE1_SECOND_DURATION, function()
                if move1Track.IsPlaying then
                    move1Track:Stop()
                end
                isUsingMove = false
            end)
        end
    end
 
    ------------------------------------------------
    -- INPUT (KEYBOARD)
    ------------------------------------------------
 
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == KEY_MOVESET1 then
            PlayMove1()
        end
    end)

    ------------------------------------------------
    -- FAST WALK TOGGLE BUTTON (SIMPLE)
    ------------------------------------------------

    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FastWalkGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local fastBtn = Instance.new("TextButton")
    fastBtn.Size = UDim2.fromScale(0.15, 0.08)
    fastBtn.Position = UDim2.fromScale(0.8, 0.8)
    fastBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    fastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fastBtn.TextScaled = true
    fastBtn.Font = Enum.Font.GothamBold
    fastBtn.Text = "RUN"
    fastBtn.Parent = screenGui

    local function toggleFastWalk()
        isFastWalking = not isFastWalking

        if isFastWalking then
            humanoid.WalkSpeed = FAST_WALK_SPEED
            walkTrack.Speed = FAST_WALK_ANIM_SPEED
            fastBtn.Text = "WALK"
        else
            humanoid.WalkSpeed = WALK_SPEED
            walkTrack.Speed = WALK_ANIM_SPEED
            fastBtn.Text = "RUN"
        end
    end

    fastBtn.MouseButton1Click:Connect(toggleFastWalk)
end
 
------------------------------------------------
-- CHARACTER LOADING
------------------------------------------------
 
if player.Character then
    Setup(player.Character)
end
 
player.CharacterAdded:Connect(function(char)
    Setup(char)
end)
