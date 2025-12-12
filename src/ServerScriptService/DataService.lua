local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local WeaponsConfig = require(game:GetService("ReplicatedStorage").Modules.WeaponsConfig)
local PlayerState = require(game:GetService("ReplicatedStorage").Modules.PlayerState)

local DataService = {}
local store = DataStoreService:GetDataStore("ZOStyleData")
local profileTemplate = {
equippedWeaponType = WeaponsConfig.DefaultWeaponType,
equippedSkinName = WeaponsConfig.DefaultSkinName,
souls = 0,
unlockedCustoms = {},
}

local playerStates = {}

function DataService:GetState(player)
return playerStates[player] or nil
end

local function loadPlayer(player)
local success, data = pcall(function()
return store:GetAsync("player_" .. player.UserId)
end)
local profile = profileTemplate
if success and data then
profile = data
end
local state = PlayerState.new()
state.currentWeapon = profile.equippedWeaponType
state.currentSkin = profile.equippedSkinName
state.souls = profile.souls or 0
state.unlockedCustoms = profile.unlockedCustoms or {}
playerStates[player] = state
return state
end

local function savePlayer(player)
local state = playerStates[player]
if not state then
return
end
local payload = {
equippedWeaponType = state.currentWeapon or WeaponsConfig.DefaultWeaponType,
equippedSkinName = state.currentSkin or WeaponsConfig.DefaultSkinName,
souls = state.souls or 0,
unlockedCustoms = state.unlockedCustoms or {},
}
pcall(function()
store:SetAsync("player_" .. player.UserId, payload)
end)
end

Players.PlayerAdded:Connect(loadPlayer)
Players.PlayerRemoving:Connect(savePlayer)
game:BindToClose(function()
for _, player in ipairs(Players:GetPlayers()) do
savePlayer(player)
end
end)

DataService.LoadPlayer = loadPlayer
DataService.SavePlayer = savePlayer

return DataService
