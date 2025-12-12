local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponsConfig = require(ReplicatedStorage.Modules.WeaponsConfig)
local DataService = require(script.Parent.DataService)

local WeaponService = {}

local function ensureMotor6D(part0, part1, name)
local joint = part0:FindFirstChild(name)
if not joint then
joint = Instance.new("Motor6D")
joint.Name = name
joint.Part0 = part0
joint.Part1 = part1
joint.Parent = part0
else
joint.Part0 = part0
joint.Part1 = part1
end
return joint
end

local function clearOld(character)
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Tool") then
child:Destroy()
end
end
local holster = character:FindFirstChild("HolsterModel")
if holster then
holster:Destroy()
end
end

local function attachHolster(character, weaponType)
local weaponFolder = ReplicatedStorage:WaitForChild("Weapons"):FindFirstChild(weaponType)
if not weaponFolder then
return
end
local holsterModel = weaponFolder:FindFirstChild("HolsterModel")
if not holsterModel then
return
end
local clone = holsterModel:Clone()
clone.Name = "HolsterModel"
clone.Parent = character
local root = character:WaitForChild("HumanoidRootPart")
if clone.PrimaryPart then
ensureMotor6D(root, clone.PrimaryPart, "HolsterJoint")
end
end

function WeaponService:GiveWeapon(player, weaponType, skinName)
local character = player.Character
if not character then
return
end
clearOld(character)
local weaponFolder = ReplicatedStorage:WaitForChild("Weapons"):FindFirstChild(weaponType)
if not weaponFolder then
return
end
local skinsFolder = weaponFolder:FindFirstChild("Skins")
local skin = skinName or WeaponsConfig.DefaultSkinName
local selectedFolder = skinsFolder and skinsFolder:FindFirstChild(skin)
if not selectedFolder then
selectedFolder = skinsFolder and skinsFolder:FindFirstChild(WeaponsConfig.DefaultSkinName)
end
if not selectedFolder then
return
end
local toolTemplate = selectedFolder:FindFirstChild("Tool")
if not toolTemplate or not toolTemplate:IsA("Tool") then
return
end
local tool = toolTemplate:Clone()
tool.CanBeDropped = false
tool.RequiresHandle = false
tool.Name = weaponType
tool.Parent = character
player:SetAttribute("EquippedWeaponType", weaponType)
player:SetAttribute("EquippedSkinName", skin)
local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
if rightHand then
local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if handle then
handle.Anchored = false
ensureMotor6D(rightHand, handle, "WeaponJoint")
end
end
attachHolster(character, weaponType)
end

function WeaponService:EquipLastSaved(player)
local state = DataService:GetState(player) or DataService.LoadPlayer(player)
self:GiveWeapon(player, state.currentWeapon or WeaponsConfig.DefaultWeaponType, state.currentSkin or WeaponsConfig.DefaultSkinName)
end

Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function()
WeaponService:EquipLastSaved(player)
end)
end)

return WeaponService
