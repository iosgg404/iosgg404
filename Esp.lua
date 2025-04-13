local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom", -- Middle หรือ Bottom (หาก FollowMouse เปิด อันนี้จะไม่สำคัญ)
    Tracer_FollowMouse = false,
    Tracers = true,
    Skeleton = true
}

local Team_Check = {
    TeamCheck = false,
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0)
}

local TeamColor = true

local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()
local black = Color3.fromRGB(0, 0, 0)

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = thickness
    line.Color = color
    line.Transparency = 1
    return line
end

local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.Thickness = thickness
    quad.Filled = false
    quad.Color = color
    quad.Transparency = 1
    return quad
end

local function NewSkeletonLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 1
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Transparency = 1
    return line
end

local function Visibility(state, lib)
    for _, v in pairs(lib) do
        if typeof(v) == "table" then
            for _, x in pairs(v) do
                x.Visible = state
            end
        else
            v.Visible = state
        end
    end
end

local function ESP(plr)
    local library = {
        blacktracer = NewLine(Settings.Tracer_Thickness * 2, black),
        tracer = NewLine(Settings.Tracer_Thickness, Settings.Tracer_Color),
        black = NewQuad(Settings.Box_Thickness * 2, black),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),
        healthbar = NewLine(3, black),
        greenhealth = NewLine(1.5, black),
        name = Drawing.new("Text"),
        skeleton = {
            HeadToTorso = NewSkeletonLine(),
            TorsoToLeftArm = NewSkeletonLine(),
            TorsoToRightArm = NewSkeletonLine(),
            TorsoToLeftLeg = NewSkeletonLine(),
            TorsoToRightLeg = NewSkeletonLine()
        }
    }

    library.name.Size = 13
    library.name.Center = true
    library.name.Outline = true
    library.name.Font = 2
    library.name.Visible = false
    library.name.Text = plr.Name
    library.name.Color = Color3.new(1, 1, 1)

    local function Colorize(color)
        for k, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black and k ~= "name" and k ~= "skeleton" then
                x.Color = color
            end
        end
    end

    coroutine.wrap(function()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char.Humanoid.Health > 0 then
                local HumPos, OnScreen = camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                local head = camera:WorldToViewportPoint(char.Head.Position)
                if OnScreen then
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
                        local origin = Settings.Tracer_FollowMouse and Vector2.new(mouse.X, mouse.Y + 36) or (Settings.Tracer_Origin == "Middle" and camera.ViewportSize * 0.5 or Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y))
                        library.tracer.From = origin
                        library.blacktracer.From = origin
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY * 2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY * 2)
                    else
                        library.tracer.Visible = false
                        library.blacktracer.Visible = false
                    end

                    -- Health bar
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude
                    local healthoffset = char.Humanoid.Health / char.Humanoid.MaxHealth * d
                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)
                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)
                    library.greenhealth.Color = Color3.fromRGB(255,0,0):lerp(Color3.fromRGB(0,255,0), char.Humanoid.Health / char.Humanoid.MaxHealth)

                    -- Name
                    library.name.Position = Vector2.new(head.X, head.Y - 20)
                    library.name.Visible = true

                    -- Skeleton
                    if Settings.Skeleton then
                        local function getVec(part)
                            local pos, visible = camera:WorldToViewportPoint(part.Position)
                            return Vector2.new(pos.X, pos.Y), visible
                        end
                        local joints = {
                            HeadToTorso = {char.Head, char.HumanoidRootPart},
                            TorsoToLeftArm = {char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"), char.HumanoidRootPart},
                            TorsoToRightArm = {char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"), char.HumanoidRootPart},
                            TorsoToLeftLeg = {char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"), char.HumanoidRootPart},
                            TorsoToRightLeg = {char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"), char.HumanoidRootPart}
                        }
                        for name, parts in pairs(joints) do
                            local a, b = parts[1], parts[2]
                            if a and b then
                                local aVec, _ = getVec(a)
                                local bVec, _ = getVec(b)
                                library.skeleton[name].From = aVec
                                library.skeleton[name].To = bVec
                                library.skeleton[name].Visible = true
                            end
                        end
                    end

                    -- สีทีม
                    if Team_Check.TeamCheck then
                        if plr.TeamColor == player.TeamColor then
                            Colorize(Team_Check.Green)
                        else
                            Colorize(Team_Check.Red)
                        end
                    elseif TeamColor then
                        Colorize(plr.TeamColor.Color)
                    else
                        Colorize(Settings.Box_Color)
                    end

                    Visibility(true, library)
                else
                    Visibility(false, library)
                end
            else
                Visibility(false, library)
                if not game.Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
                end
            end
        end)
    end)()
end

for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= player then
        ESP(v)
    end
end

game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        ESP(plr)
    end
end)
