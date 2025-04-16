-- this script made for head players how it look at
local Settings = {
    ViewAngle = true,
    ViewAngle_Thickness = 2,
    MaxDistance = 1000
}

local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera

local function NewLine(thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function CreateViewAngle(plr)
    local line = NewLine(Settings.ViewAngle_Thickness)

    game:GetService("RunService").RenderStepped:Connect(function()
        if not plr.Character or not plr.Character:FindFirstChild("Head") or plr == player then
            line.Visible = false
            return
        end

        local head = plr.Character.Head
        local headPos = head.Position
        local lookVec = head.CFrame.LookVector
        local endPos = headPos + (lookVec * 5)

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - headPos).Magnitude
            if dist > Settings.MaxDistance then
                line.Visible = false
                return
            end

            if dist <= 100 then
                line.Color = Color3.fromRGB(0, 255, 0) -- เขียว
            elseif dist <= 300 then
                line.Color = Color3.fromRGB(255, 255, 0) -- เหลือง
            else
                line.Color = Color3.fromRGB(255, 0, 0) -- แดง
            end
        end

        local screenStart, onScreen1 = camera:WorldToViewportPoint(headPos)
        local screenEnd, onScreen2 = camera:WorldToViewportPoint(endPos)

        if onScreen1 and onScreen2 then
            line.From = Vector2.new(screenStart.X, screenStart.Y)
            line.To = Vector2.new(screenEnd.X, screenEnd.Y)
            line.Visible = true
        else
            line.Visible = false
        end
    end)
end

for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= player then
        CreateViewAngle(v)
    end
end

game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        CreateViewAngle(plr)
    end
end)
