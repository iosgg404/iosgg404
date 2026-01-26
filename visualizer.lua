--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--// Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

--// Camera
local Camera = workspace.CurrentCamera
local camShakePower = 0.7

--// Sound
local sound = workspace:WaitForChild("equinox")

--// Settings
local orbitRadius = 20
local baseSize = 10
local maxGrow = 10
local maxLoudness = 600
local baseSpeed = 0.8
local maxSpeed = 4
local auraEnabled = true

--// Color Switch
local switchInterval = 0.35
local lastSwitch = tick()
local isWhite = true

--// GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AuraGui"

local button = Instance.new("TextButton")
button.Size = UDim2.fromScale(0.15, 0.06)
button.Position = UDim2.fromScale(0.02, 0.05)
button.Text = "Aura: ON"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.BorderSizePixel = 0
button.Parent = gui

--// Create Orb
local function createOrb(name, color)
	local orb = Instance.new("Part")
	orb.Name = name
	orb.Shape = Enum.PartType.Ball
	orb.Size = Vector3.new(baseSize, baseSize, baseSize)
	orb.Material = Enum.Material.Neon
	orb.Color = color
	orb.Transparency = 0.25
	orb.CanCollide = false
	orb.Anchored = true
	orb.Parent = character

	local att0 = Instance.new("Attachment", orb)
	att0.Position = Vector3.new(0, 0, -baseSize/2)

	local att1 = Instance.new("Attachment", orb)
	att1.Position = Vector3.new(0, 0, baseSize/2)

	local trail = Instance.new("Trail")
	trail.Attachment0 = att0
	trail.Attachment1 = att1
	trail.Lifetime = 0.25
	trail.MinLength = 0.1
	trail.FaceCamera = true
	trail.Color = ColorSequence.new(color)
	trail.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.05),
		NumberSequenceKeypoint.new(1, 1)
	})
	trail.Parent = orb

	return orb, trail
end

local orb1, trail1 = createOrb("Orb1", Color3.new(1,1,1))
local orb2, trail2 = createOrb("Orb2", Color3.new(0,0,0))

--// Explosion Effect
local function explodeAt(position, color, size)
	local blast = Instance.new("Part")
	blast.Shape = Enum.PartType.Ball
	blast.Anchored = true
	blast.CanCollide = false
	blast.Material = Enum.Material.Neon
	blast.Color = color
	blast.Transparency = 0.4
	blast.Size = Vector3.new(1,1,1)
	blast.CFrame = CFrame.new(position)
	blast.Parent = workspace

	local tween = TweenService:Create(blast,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(size,size,size), Transparency = 1}
	)
	tween:Play()
	tween.Completed:Connect(function()
		blast:Destroy()
	end)
end

--// Sound
if not sound.IsPlaying then
	sound:Play()
end

--// Toggle Button
button.MouseButton1Click:Connect(function()
	auraEnabled = not auraEnabled
	button.Text = auraEnabled and "Aura: ON" or "Aura: OFF"
	button.TextColor3 = auraEnabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,80,80)

	if auraEnabled then
		if not sound.IsPlaying then sound:Play() end
	else
		sound:Stop()
	end

	orb1.Transparency = auraEnabled and 0.25 or 1
	orb2.Transparency = auraEnabled and 0.25 or 1
	trail1.Enabled = auraEnabled
	trail2.Enabled = auraEnabled
end)

--// Loop
local angle = 0
local shakeOffset = Vector3.zero

RunService.RenderStepped:Connect(function(dt)
	if not auraEnabled then return end
	if not root or not root.Parent then return end

	local amp = math.clamp(sound.PlaybackLoudness / maxLoudness, 0, 1)

	-- Orbit speed
	local rotateSpeed = baseSpeed + (amp * (maxSpeed - baseSpeed))
	angle += dt * rotateSpeed

	-- Size
	local size = baseSize + (amp * maxGrow)
	orb1.Size = Vector3.new(size, size, size)
	orb2.Size = Vector3.new(size, size, size)

	-- Trail
	local trailLife = 0.15 + (amp * 0.35)
	trail1.Lifetime = trailLife
	trail2.Lifetime = trailLife

	-- Position
	local offset1 = Vector3.new(math.cos(angle), 0, math.sin(angle)) * orbitRadius
	local offset2 = Vector3.new(math.cos(angle + math.pi), 0, math.sin(angle + math.pi)) * orbitRadius
	orb1.CFrame = root.CFrame + offset1
	orb2.CFrame = root.CFrame + offset2

	-- Camera Shake
	local targetShake = Vector3.new(
		(math.random()-0.5)*2,
		(math.random()-0.5)*2,
		(math.random()-0.5)*2
	) * amp * camShakePower
	shakeOffset = shakeOffset:Lerp(targetShake, 0.15)
	Camera.CFrame = Camera.CFrame * CFrame.new(shakeOffset)

	-- Switch Color + Explosion
	if tick() - lastSwitch >= switchInterval then
		isWhite = not isWhite

		if isWhite then
			orb1.Color = Color3.new(1,1,1)
			orb2.Color = Color3.new(0,0,0)
		else
			orb1.Color = Color3.new(0,0,0)
			orb2.Color = Color3.new(1,1,1)
		end

		-- Sync Trail Color
		trail1.Color = ColorSequence.new(orb1.Color)
		trail2.Color = ColorSequence.new(orb2.Color)

		-- Explosion ครอบลูกบอล
		explodeAt(orb1.Position, orb1.Color, size*2)
		explodeAt(orb2.Position, orb2.Color, size*2)

		lastSwitch = tick()
	end
end)
