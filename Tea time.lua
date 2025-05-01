local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Bakery", "DarkTheme")

local CookieTab = Window:NewTab("Cookies")
local CakeTab = Window:NewTab("Cakes")
local MadeleinesTab = Window:NewTab("Madeleines")
local FoodTab = Window:NewTab("2.5k Food")
local FeuilleMeringueTab = Window:NewTab("Feuille & Meringue")
local PastriesTab = Window:NewTab("Pastries")
local TartsTab = Window:NewTab("Tarts")
local MacaronsTab = Window:NewTab("Macarons")
local BreadTab = Window:NewTab("Assorted & Bread")
local ChurrosTab = Window:NewTab("Churros")
local a = Window:NewTab(".")
local b = Window:NewTab(".")
local c = Window:NewTab(".")
local d = Window:NewTab(".")
local e = Window:NewTab(".")
local f = Window:NewTab(".")

local CookieSection = CookieTab:NewSection("Cookies")
local CakeSection = CakeTab:NewSection("Cakes")
local MadeleinesSection = MadeleinesTab:NewSection("Madeleines")
local FoodSection = FoodTab:NewSection("2.5k Food")
local FeuilleMeringueSection = FeuilleMeringueTab:NewSection("Feuille & Meringue")
local PastriesSection = PastriesTab:NewSection("Pastries")
local TartsSection = TartsTab:NewSection("Tarts")
local MacaronsSection = MacaronsTab:NewSection("Macarons")
local BreadSection = BreadTab:NewSection("Assorted & Bread")
local ChurrosSection = ChurrosTab:NewSection("Churros")
local a = aTab:NewSection(".")
local b = bTab:NewSection(".")
local c = cTab:NewSection(".")
local d = dTab:NewSection(".")
local e = eTab:NewSection(".")
local f = fTab:NewSection(".")

local cookies = {
    "Tea Cookies", "Chocolate Chlp Cookies", "Checkerboard Cookies",
    "Chocolate Cannoli", "Almond Cannoli", "Pistachio Cannoli",
    "Chocolate Biscotti", "Almond Biscotti", "Cranberry Biscotti",
    "Chocolate Wafers", "Vanilla Wafers", "Strawberry Wafers",
    "Shortbread", "Peanut Butter Cookies", "Stroopwafel",
    "Peanut Blossom Cookies", "Matcha Blossom Cookies", "Chocolate Blossom Cookies",
    "Chocolate Butter Cookies", "Butter Cookies", "Caramel Butter cookie", ".", ".", ".", "."
}

local cakes =  {
    "Lemon Cake", "Vanilla Swiss Roll", "Strawberry Swiss Roll", "Chocolate Swiss Roll",
    "Battenberg Cake", "Marble Cake", "Pound Cake", "Coffee Cake", "Strawberry Cake",
    "Chocolate Cake", "Red Velvet Cake", "Carrot Cake", "Matcha Mille Crepe", "Vanilla Mille Crepe",
    "Chocolate Mille Crepe", "Chocolate Bundt Cake", "Strawberry Bundt Cake", "Vanilla Bundt Cake",
    "New York Cheesecake", "Blueberry Cheesecake", "Raspberry Cheesecake", "Vanilla Cake",
    "Matcha Cake", "Fruit Cake", ".", ".", ".", "."
}

local madeleines = {
    "Vanilla Madeleines", "Chocolate Madeleines", "Strawberry Madeleines", ".", ".", ".", "."
}

local petitFours = {
    "Petit Fours", "Chocolate Sticks", "White Chocolate Sticks", "Strawberry Stick",
    "Chestnut Mont Blanc", "Chocolate Mont Blanc", "Strawberry Mont Blanc", ".", ".", ".", "."
}

local pannaCotta = {
    "Panna Cotta", "Chocolate Panna Cotta", "Creme Brulee", ".", ".", ".", "."
}

local feuilleMeringue = {
    "Berries Mille Feuille", "Chocolate Mille Feuille", "Strawberry Meringue",
    "Mango Meringue", "Blueberry Meringue", ".", ".", ".", "."
}

local pastries = {
    "Cinnamon Roll", "Scones", "Pretzel", "Belgian Waffle", "Eclairs",
    "Cream Puff", "Pain au chocolat", "Croissant", ".", ".", ".", "."
}

local tarts = {
    "Blueberry Tart", "Lemon Tart", "Strawberry Tart", "Cranberry Tart",
    "Matcha Tart", "Chocolate Tart", ".", ".", ".", "."
}

local macarons = {
    "Red Velvet Macarons", "Honey Lavender Macarons", "Salted Caramel Macarons",
    "Lemon Macarons", "Chocolate Macarons", "Pistachio Macarons",
    "Vanilla Macarons", "Strawberry Macarons", "Coffee Macarons", ".", ".", ".", "."
}

local assortedBread = {
    "Cherry Pie", "Pumpkin Pie", "Blueberry Pie", "Mini Sausage Rolls",
    "Brownies", "Blondies", "Red Velvet Brownies", "Vanilla Muffin",
    "Chocolate Muffin", "Cinnamon Muffin", "Pink Concha", "White Concha",
    "Chocolate Concha", "Pink Iced Bun", "Vanilla Iced Bun", "Chocolate Iced Bun",
    "Italian Sandwich", "Egg & Cucumber Sandwich", "Smoked Salmon Sandwich", ".", ".", ".", "."
}

local churros = {
    "Churros", "Chocolate Churros", "Red Velvet Churros", ".", ".", ".", ".",
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

for _, name in ipairs(tarts) do
    createButton(TartsSection, name)
end

for _, name in ipairs(macarons) do
    createButton(MacaronsSection, name)
end

for _, name in ipairs(assortedBread) do
    createButton(BreadSection, name)
end

for _, name in ipairs(churros) do
    createButton(ChurrosSection, name)
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
