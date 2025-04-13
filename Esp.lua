-- Settings for ESP
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom", 
    Tracer_FollowMouse = false,
    Tracers = true,
    Skeleton = true,  -- Add Skeleton option
    View_Angle = true,  -- Add View Angle option
}

local Team_Check = {
    TeamCheck = false,
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0)
}

local TeamColor = true

-- SEPARATION
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local mouse = player:GetMouse()

-- Function to create a Quad (Box)
local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0,0)
    quad.PointB = Vector2.new(0,0)
    quad.PointC = Vector2.new(0,0)
    quad.PointD = Vector2.new(0,0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

-- Function to create a Line (Tracer)
local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

-- Function to toggle visibility of library items
local function Visibility(state, lib)
    for u, x in pairs(lib) do
        x.Visible = state
    end
end

-- Function to convert color
local function ToColor3(col)
    local r = col.r
    local g = col.g
    local b = col.b
    return Color3.new(r,g,b)
end

-- Function to create ESP for a player
local function ESP(plr)
    local library = {
        blacktracer = NewLine(Settings.Tracer_Thickness*2, Color3.fromRGB(0, 0 ,0)),
        tracer = NewLine(Settings.Tracer_Thickness, Settings.Tracer_Color),
        black = NewQuad(Settings.Box_Thickness*2, Color3.fromRGB(0, 0 ,0)),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),
        healthbar = NewLine(3, Color3.fromRGB(0, 0 ,0)),
        greenhealth = NewLine(1.5, Color3.fromRGB(0, 0 ,0)),
        -- Skeleton lines
        skeleton = {
            NewLine(1, Color3.fromRGB(255, 255, 0)), -- Neck to torso
            NewLine(1, Color3.fromRGB(255, 255, 0)), -- Torso to legs
            NewLine(1, Color3.fromRGB(255, 255, 0)), -- Left arm
            NewLine(1, Color3.fromRGB(255, 255, 0)), -- Right arm
        },
        -- View Angle
        viewAngleLine = NewLine(2, Color3.fromRGB(255, 255, 255))  -- Line to represent view angle
    }

    local function Colorize(color)
        for u, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black and x ~= library.skeleton then
                x.Color = color
            end
        end
    end

    local function UpdateSkeleton()
        if Settings.Skeleton then
            local humanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")
            local head = plr.Character:FindFirstChild("Head")
            local torso = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("LowerTorso")
            local leftLeg = plr.Character:FindFirstChild("LeftLeg")
            local rightLeg = plr.Character:FindFirstChild("RightLeg")
            local leftArm = plr.Character:FindFirstChild("LeftUpperArm")
            local rightArm = plr.Character:FindFirstChild("RightUpperArm")
            
            if humanoidRootPart and head and torso and leftLeg and rightLeg and leftArm and rightArm then
                local headPos = camera:WorldToViewportPoint(head.Position)
                local torsoPos = camera:WorldToViewportPoint(torso.Position)
                local leftLegPos = camera:WorldToViewportPoint(leftLeg.Position)
                local rightLegPos = camera:WorldToViewportPoint(rightLeg.Position)
                local leftArmPos = camera:WorldToViewportPoint(leftArm.Position)
                local rightArmPos = camera:WorldToViewportPoint(rightArm.Position)

                -- Update skeleton lines (using lines to represent body parts)
                library.skeleton[1].From = Vector2.new(headPos.X, headPos.Y)
                library.skeleton[1].To = Vector2.new(torsoPos.X, torsoPos.Y)

                library.skeleton[2].From = Vector2.new(torsoPos.X, torsoPos.Y)
                library.skeleton[2].To = Vector2.new(leftLegPos.X, leftLegPos.Y)

                library.skeleton[3].From = Vector2.new(torsoPos.X, torsoPos.Y)
                library.skeleton[3].To = Vector2.new(leftArmPos.X, leftArmPos.Y)

                library.skeleton[4].From = Vector2.new(torsoPos.X, torsoPos.Y)
                library.skeleton[4].To = Vector2.new(rightArmPos.X, rightArmPos.Y)

                -- Make sure skeleton lines are visible
                for _, line in pairs(library.skeleton) do
                    line.Visible = true
                end
            end
        end
    end

    -- View Angle Update
    local function UpdateViewAngle()
        if Settings.View_Angle then
            local cameraDirection = camera.CFrame.LookVector  -- Get the camera's facing direction
            local cameraPosition = camera.CFrame.Position
            local targetPosition = cameraPosition + cameraDirection * 1000  -- Extend the direction to show a long line

            -- Convert world position to screen position
            local screenPos = camera:WorldToViewportPoint(targetPosition)
            library.viewAngleLine.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            library.viewAngleLine.To = Vector2.new(screenPos.X, screenPos.Y)

            -- Make sure the view angle line is visible
            library.viewAngleLine.Visible = true
        end
    end

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                    
                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                    end
                    Size(library.box)
                    Size(library.black)

                    if Settings.Tracers then
                        if Settings.Tracer_Origin == "Middle" then
                            library.tracer.From = camera.ViewportSize*0.5
                            library.blacktracer.From = camera.ViewportSize*0.5
                        elseif Settings.Tracer_Origin == "Bottom" then
                            library.tracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y) 
                            library.blacktracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y)
                        end
                        if Settings.Tracer_FollowMouse then
                            library.tracer.From = Vector2.new(mouse.X, mouse.Y+36)
                            library.blacktracer.From = Vector2.new(mouse.X, mouse.Y+36)
                        end
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    else 
                        library.tracer.From = Vector2.new(0, 0)
                        library.blacktracer.From = Vector2.new(0, 0)
                        library.tracer.To = Vector2.new(0, 0)
                        library.blacktracer.To = Vector2.new(0, 02)
                    end

                    -- Health Bar Update
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                    local healthoffset = plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth * d
                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)
                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)

                    -- Update Skeleton and View Angle
                    UpdateSkeleton()
                    UpdateViewAngle()

                    -- Make sure the library is visible
                    Visibility(true, library)
                else 
                    Visibility(false, library)
                end
            else 
                Visibility(false, library)
                if game.Players:FindFirstChild(plr.Name) == nil then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)
