local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponsConfig = require(ReplicatedStorage.Modules.WeaponsConfig)

local KillEffectService = {}
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayKillEffect")

local function resolveKillEffect(weaponType, skinName)
local weaponInfo = WeaponsConfig:GetWeaponInfo(weaponType)
local skinInfo = WeaponsConfig:GetSkinInfo(weaponType, skinName)
return (skinInfo and skinInfo.killEffect) or (weaponInfo and weaponInfo.killEffect) or "DefaultSlash"
end

function KillEffectService:Play(attacker, victim, weaponType, skinName)
local effectName = resolveKillEffect(weaponType, skinName)
remote:FireAllClients(attacker, victim, effectName)
end

return KillEffectService
