--[[
  Aimbot Universal GUI - Ayka Script | Feito por Aykad-7p
  Versão com Aimbot melhorado e áudio nas interações
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- CONFIGS
local Settings = {
    Aimbot = false,
    TeamCheck = false,
    FOV = 100,
    Part = "Head",
    FOVVisible = true,
    RGB = true,
    AimStrength = 0.4,  -- Aimbot ajustado para maior precisão
    Prediction = 0.15, -- Removido a previsão
}

-- CARREGAR ÁUDIOS
local menuSound = Instance.new("Sound")
menuSound.SoundId = "rbxassetid://2556932492" -- Áudio de abrir o menu (ID fornecida)
menuSound.Parent = SoundService -- Colocar no serviço de som para funcionar corretamente

local toggleSound = Instance.new("Sound")
toggleSound.SoundId = "rbxassetid://2556932492" -- Áudio para ativar/desativar a opção (ID fornecida)
toggleSound.Parent = SoundService -- Colocar no serviço de som para funcionar corretamente

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton")
openBtn.Text = "Open Ayka Menu"
openBtn.Size = UDim2.new(0, 140, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -100)
openBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Parent = ScreenGui
openBtn.Active = true
openBtn.Draggable = true

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 250, 0, 300)
menu.Position = UDim2.new(0.5, -125, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menu.Visible = false
menu.Parent = ScreenGui

local base = Instance.new("TextLabel")
base.Text = "Aykad-7p"
base.Font = Enum.Font.SourceSans
base.TextSize = 24
base.TextColor3 = Color3.fromHSV(0, 1, 1)  -- Inicia em uma cor RGB
base.Position = UDim2.new(0.5, -60, 0, 10)
base.Parent = menu

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", scroll)
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

function createToggle(name, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = name..": "..(default and "ON" or "OFF")
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = scroll

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name..": "..(state and "ON" or "OFF")
        callback(state)
        toggleSound:Play()  -- Reproduzir o som quando ativar/desativar a opção
    end)
end

function createOption(name, options, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = scroll

    local index = 1
    btn.Text = name..": "..options[index]

    btn.MouseButton1Click:Connect(function()
        index = index % #options + 1
        btn.Text = name..": "..options[index]
        callback(options[index])
        toggleSound:Play()  -- Reproduzir o som quando selecionar uma opção
    end)
end

function createFOVButtons()
    local fovDown = Instance.new("TextButton")
    local fovUp = Instance.new("TextButton")
    
    fovDown.Size = UDim2.new(0.45, -5, 0, 30)
    fovUp.Size = UDim2.new(0.45, -5, 0, 30)

    fovDown.Position = UDim2.new(0, 5, 0, 0)
    fovUp.Position = UDim2.new(0.5, 5, 0, 0)

    fovDown.Text = "- FOV"
    fovUp.Text = "+ FOV"

    for _, btn in ipairs({fovDown, fovUp}) do
        btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = scroll
    end

    fovDown.MouseButton1Click:Connect(function()
        Settings.FOV = math.max(10, Settings.FOV - 10)
        toggleSound:Play()  -- Som para aumentar ou diminuir o FOV
    end)
    fovUp.MouseButton1Click:Connect(function()
        Settings.FOV = math.min(1000, Settings.FOV + 10)
        toggleSound:Play()  -- Som para aumentar ou diminuir o FOV
    end)
end

-- Botões do menu
createToggle("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
createToggle("Team Check", Settings.TeamCheck, function(v) Settings.TeamCheck = v end)
createToggle("FOV Visible", Settings.FOVVisible, function(v) Settings.FOVVisible = v end)
createToggle("RGB FOV", Settings.RGB, function(v) Settings.RGB = v end)
createOption("Target Part", {"Head", "Torso"}, function(v) Settings.Part = v end)
createFOVButtons()

openBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    menuSound:Play()  -- Reproduzir som quando abrir o menu
end)

-- FOV círculo
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Filled = false
fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

local hue = 0
RunService.RenderStepped:Connect(function()
    fovCircle.Visible = Settings.FOVVisible
    fovCircle.Radius = Settings.FOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if Settings.RGB then
        hue = (hue + 1) % 360
        fovCircle.Color = Color3.fromHSV(hue/360, 1, 1)
    else
        fovCircle.Color = Color3.fromRGB(255,255,255)
    end
end)

-- Função alvo
function getClosest()
    local closest, dist = nil, Settings.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if Settings.TeamCheck and p.Team == LocalPlayer.Team then continue end
            local part = p.Character:FindFirstChild(Settings.Part)
            if not part then continue end
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Camera.ViewportSize/2).Magnitude
            if distance < dist then
                closest = part
                dist = distance
            end
        end
    end
    return closest
end

-- Aimbot sem previsão
RunService.RenderStepped:Connect(function()
    if not Settings.Aimbot then return end
    local target = getClosest()
    if target then
        local direction = (target.Position - Camera.CFrame.Position).Unit
        local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Settings.AimStrength)
    end
end)

-- Atualização do nome em RGB
RunService.RenderStepped:Connect(function()
    if Settings.RGB then
        hue = (hue + 1) % 360
        base.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
    else
        base.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)
