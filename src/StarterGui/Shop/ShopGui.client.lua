local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local WeaponsConfig = require(ReplicatedStorage.Modules.WeaponsConfig)
local remotes = ReplicatedStorage:WaitForChild('Remotes')

local player = Players.LocalPlayer

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'WeaponShop'
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild('PlayerGui')

local frame = Instance.new('Frame')
frame.Size = UDim2.new(0, 400, 0, 260)
frame.Position = UDim2.new(0.5, -200, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = 'Weapon Shop (B to close)'
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local scrolling = Instance.new('ScrollingFrame')
scrolling.Size = UDim2.new(1, -10, 1, -40)
scrolling.Position = UDim2.new(0, 5, 0, 35)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 800)
scrolling.BackgroundTransparency = 1
scrolling.BorderSizePixel = 0
scrolling.Parent = frame

local layout = Instance.new('UIListLayout')
layout.Padding = UDim.new(0, 6)
layout.Parent = scrolling

local function createButton(text)
    local button = Instance.new('TextButton')
    button.Size = UDim2.new(1, -10, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.Text = text
    button.AutoButtonColor = true
    button.Parent = scrolling
    return button
end

for weaponType, info in pairs(WeaponsConfig.Weapons) do
    local header = createButton('[' .. weaponType .. '] souls: ' .. info.price)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.MouseButton1Click:Connect(function()
        remotes.ShopSelect:FireServer(weaponType, info.skins[1].name)
    end)
    for _, skin in ipairs(info.skins) do
        local skinButton = createButton('  - ' .. skin.name .. ' souls: ' .. skin.price)
        skinButton.MouseButton1Click:Connect(function()
            remotes.ShopSelect:FireServer(weaponType, skin.name)
        end)
    end
end

local open = false
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.B then
        open = not open
        frame.Visible = open
    end
end)
