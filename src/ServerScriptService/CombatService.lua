local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local WeaponsConfig = require(ReplicatedStorage.Modules.WeaponsConfig)
local DataService = require(script.Parent.DataService)
local WeaponService = require(script.Parent.WeaponService)
local KillEffectService = require(script.Parent.KillEffectService)

local remotes = ReplicatedStorage:WaitForChild("Remotes")

local CombatService = {}

local function getState(player)
return DataService:GetState(player) or DataService.LoadPlayer(player)
end

local function getHumanoid(player)
local character = player.Character
return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot(character)
return character and character:FindFirstChild("HumanoidRootPart")
end

local function withinRange(attacker, target, maxDistance)
local aRoot = getRoot(attacker.Character)
local tRoot = getRoot(target.Character)
if not aRoot or not tRoot then
return false
end
return (aRoot.Position - tRoot.Position).Magnitude <= maxDistance
end

local function stun(player, duration)
local state = getState(player)
state:Stun(duration)
end

local function killTarget(attacker, target)
local targetHumanoid = getHumanoid(target)
if not targetHumanoid then
return
end
targetHumanoid.Health = 0
local attackerState = getState(attacker)
KillEffectService:Play(attacker, target, attackerState.currentWeapon, attackerState.currentSkin)
end

local function chipDamage(target, amount)
local humanoid = getHumanoid(target)
if humanoid then
humanoid.Health = math.max(0, humanoid.Health - amount)
end
end

local function handleAttack(player)
local state = getState(player)
local now = tick()
if state:IsStunned() then
return
end
if not state.equipped then
return
end
if now - state.lastAttackTime < WeaponsConfig.AttackCooldown then
return
end
local timeSinceLast = now - state.lastAttackTime
state.lastAttackTime = now
if timeSinceLast > 1.2 then
state.comboIndex = 0
end
state.comboIndex = (state.comboIndex % 4) + 1

for _, target in ipairs(Players:GetPlayers()) do
if target ~= player and target.Character and target.Character:FindFirstChildOfClass("Humanoid") and target.Character.Humanoid.Health > 0 then
if withinRange(player, target, 7) then
local targetState = getState(target)
if targetState.blocking then
targetState.lastBlockPress = targetState.lastBlockPress or 0
local delta = now - targetState.lastBlockPress
if delta <= WeaponsConfig.PerfectBlockWindow then
stun(player, WeaponsConfig.PerfectBlockStunDuration)
else
chipDamage(target, 5)
stun(player, WeaponsConfig.BlockStunDuration)
end
else
killTarget(player, target)
end
end
end
end
end

local function handleBlock(player, isBlocking)
local state = getState(player)
state.blocking = isBlocking
if isBlocking then
state.lastBlockPress = tick()
end
end

local function handleKick(player)
local state = getState(player)
local now = tick()
if now - state.lastKick < WeaponsConfig.KickCooldown or state:IsStunned() then
return
end
state.lastKick = now
for _, target in ipairs(Players:GetPlayers()) do
if target ~= player and withinRange(player, target, 6) then
local targetState = getState(target)
local delta = now - (targetState.lastBlockPress or 0)
if targetState.blocking and delta <= WeaponsConfig.PerfectBlockWindow then
stun(player, WeaponsConfig.PerfectBlockStunDuration)
elseif targetState.blocking then
targetState.blocking = false
stun(target, WeaponsConfig.KickStunDuration)
chipDamage(target, 10)
else
stun(target, WeaponsConfig.KickStunDuration)
chipDamage(target, 20)
end
end
end
end

local function handleDash(player, direction)
local state = getState(player)
local now = tick()
if now - state.lastDash < WeaponsConfig.DashCooldown then
return
end
state.lastDash = now
local character = player.Character
local root = getRoot(character)
if not root then
return
end
local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(1, 0, 1) * 1e5
bodyVel.Velocity = direction * WeaponsConfig.DashForce
bodyVel.Parent = root
Debris:AddItem(bodyVel, WeaponsConfig.DashDuration)
end

local function handleEquipState(player, equip)
local state = getState(player)
local now = tick()
if now - state.lastEquipToggle < WeaponsConfig.EquipCooldown then
return
end
state.lastEquipToggle = now
state.equipped = equip
end

local function handleShopSelect(player, weaponType, skinName)
local state = getState(player)
local weaponInfo = WeaponsConfig:GetWeaponInfo(weaponType)
if not weaponInfo then
return
end
local skinInfo = WeaponsConfig:GetSkinInfo(weaponType, skinName)
if not skinInfo then
skinName = weaponInfo.skins[1].name
end
if weaponInfo.customOnly then
local allowed = state.unlockedCustoms[skinName] or state.unlockedCustoms[weaponType] or false
if not allowed then
return
end
end
state.currentWeapon = weaponType
state.currentSkin = skinName
WeaponService:GiveWeapon(player, weaponType, skinName)
end

remotes.RequestAttack.OnServerEvent:Connect(handleAttack)
remotes.RequestBlockState.OnServerEvent:Connect(function(player, isBlocking)
if typeof(isBlocking) ~= "boolean" then
return
end
handleBlock(player, isBlocking)
end)
remotes.RequestKick.OnServerEvent:Connect(handleKick)
remotes.RequestDash.OnServerEvent:Connect(function(player, direction)
if typeof(direction) ~= "Vector3" then
return
end
handleDash(player, direction)
end)
remotes.RequestEquipState.OnServerEvent:Connect(function(player, equip)
if typeof(equip) ~= "boolean" then
return
end
handleEquipState(player, equip)
end)
remotes.ShopSelect.OnServerEvent:Connect(function(player, weaponType, skinName)
handleShopSelect(player, weaponType, skinName)
end)

return CombatService
