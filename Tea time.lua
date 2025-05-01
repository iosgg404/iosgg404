local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Bakery", "DarkTheme")

local CookieTab = Window:NewTab("Cookies")
local CakeTab = Window:NewTab("Cakes")
local MadeleinesTab = Window:NewTab("Madeleines")
local FoodTab = Window:NewTab("2.5k Food")
local FeuilleMeringueTab = Window:NewTab("Feuille & Meringue")
local PastriesTab = Window:NewTab("Pastries")

local CookieSection = CookieTab:NewSection("Cookies")
local CakeSection = CakeTab:NewSection("Cakes")
local MadeleinesSection = MadeleinesTab:NewSection("Madeleines")
local FoodSection = FoodTab:NewSection("2.5k Food")
local FeuilleMeringueSection = FeuilleMeringueTab:NewSection("Feuille & Meringue")
local PastriesSection = PastriesTab:NewSection("Pastries")

local cookies = {
    "Tea Cookies", "Chocolate Chlp Cookies", "Checkerboard Cookies",
    "Chocolate Cannoli", "Almond Cannoli", "Pistachio Cannoli",
    "Chocolate Biscotti", "Almond Biscotti", "Cranberry Biscotti",
    "Chocolate Wafers", "Vanilla Wafers", "Strawberry Wafers",
    "Shortbread", "Peanut Butter Cookies", "Stroopwafel"
}

local cakes =  {
    "Lemon Cake", "Vanilla Swiss Roll", "Strawberry Swiss Roll", "Chocolate Swiss Roll",
    "Battenberg Cake", "Marble Cake", "Pound Cake", "Coffee Cake", "Strawberry Cake",
    "Chocolate Cake", "Red Velvet Cake", "Carrot Cake", "Matcha Mille Crepe", "Vanilla Mille Crepe",
    "Chocolate Mille Crepe", "Chocolate Bundt Cake", "Strawberry Bundt Cake", "Vanilla Bundt Cake",
    "New York Cheesecake", "Blueberry Cheesecake", "Raspberry Cheesecake", "Vanilla Cake",
    "Matcha Cake", "Fruit Cake"
}

local madeleines = {
    "Vanilla Madeleines", "Chocolate Madeleines", "Strawberry Madeleines"
}

local petitFours = {
    "Petit Fours", "Chocolate Sticks", "White Chocolate Sticks", "Strawberry Stick",
    "Chestnut Mont Blanc", "Chocolate Mont Blanc", "Strawberry Mont Blanc"
}

local pannaCotta = {
    "Panna Cotta", "Chocolate Panna Cotta", "Creme Brulee"
}

local feuilleMeringue = {
    "Berries Mille Feuille", "Chocolate Mille Feuille", "Strawberry Meringue",
    "Mango Meringue", "Blueberry Meringue"
}

local pastries = {
    "Cinnamon Roll", "Scones", "Pretzel", "Belgian Waffle",
    "Eclairs", "Cream Puff", "Pain au chocolat", "Croissant"
}

local function createButton(section, name)
    section:NewButton(name, "", function()
        local args = {
            [1] = name
        }
        game:GetService("ReplicatedStorage")
            .Packages._Index["sleitnick_knit@1.7.0"].knit
            .Services.IngredientService.RF.AddToPlate:InvokeServer(unpack(args))
    end)
end

for _, name in ipairs(cookies) do
    createButton(CookieSection, name)
end

for _, name in ipairs(cakes) do
    createButton(CakeSection, name)
end

for _, name in ipairs(madeleines) do
    createButton(MadeleinesSection, name)
end

for _, name in ipairs(petitFours) do
    createButton(FoodSection, name)
end

for _, name in ipairs(pannaCotta) do
    createButton(FoodSection, name)
end

for _, name in ipairs(feuilleMeringue) do
    createButton(FeuilleMeringueSection, name)
end

for _, name in ipairs(pastries) do
    createButton(PastriesSection, name)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton")
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Position = UDim2.new(0, 10, 0.5, -25)
Toggle.Size = UDim2.new(0, 100, 0, 50)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.Text = "☕"
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.TextSize = 40
Toggle.Draggable = true

local UICorner = Instance.new("UICorner", Toggle)
UICorner.CornerRadius = UDim.new(0, 12)

Toggle.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)
