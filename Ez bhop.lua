local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local normalWalkSpeed = 16 -- normal walkspeed
local jumpSpeed = 50 -- change jump speed
local isJumping = false

local function onJumpRequest()
    if not isJumping then
        isJumping = true
        humanoid.WalkSpeed = jumpSpeed
    end
end

local function onTouchGround()
    if isJumping then
        isJumping = false
        humanoid.WalkSpeed = normalWalkSpeed
    end
end

humanoid.Jumping:Connect(onJumpRequest)

humanoid.FreeFalling:Connect(function(isFalling)
    if not isFalling then
        onTouchGround()
    end
end)

humanoid.WalkSpeed = normalWalkSpeed
