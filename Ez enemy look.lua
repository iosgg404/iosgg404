local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local TeamCheck = true -- true = แสดงเฉพาะศัตรู

local function NewViewLine()
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = Color3.fromRGB(0, 255, 255)
    line.Transparency = 1
    line.Visible = false
    return line
end

local ViewLines = {}

local function AddPlayer(player)
    if player == LocalPlayer then return end

    local line = NewViewLine()
    ViewLines[player] = line

    RunService.RenderStepped:Connect(function()
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            if TeamCheck and player.Team == LocalPlayer.Team then
                line.Visible = false
                return
            end

            local origin = head.Position
            local look = head.CFrame.LookVector * 10
            local destination = origin + look

            local origin2D, onScreen1 = Camera:WorldToViewportPoint(origin)
            local dest2D, onScreen2 = Camera:WorldToViewportPoint(destination)

            if onScreen1 and onScreen2 then
                line.From = Vector2.new(origin2D.X, origin2D.Y)
                line.To = Vector2.new(dest2D.X, dest2D.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    AddPlayer(plr)
end

Players.PlayerAdded:Connect(AddPlayer)
Players.PlayerRemoving:Connect(function(plr)
    if ViewLines[plr] then
        ViewLines[plr]:Remove()
        ViewLines[plr] = nil
    end
end)
