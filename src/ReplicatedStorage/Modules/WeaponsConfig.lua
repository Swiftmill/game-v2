-- Defines weapon metadata, skins, pricing, and kill effects.
-- Models and animations must be manually imported following the checklist in README-style notes below.

local WeaponsConfig = {
DefaultWeaponType = "Katana",
DefaultSkinName = "Steel",
CurrencyName = "Souls",
PerfectBlockWindow = 0.2,
BlockStunDuration = 1,
PerfectBlockStunDuration = 2,
KickStunDuration = 1.25,
DashCooldown = 1.25,
KickCooldown = 3,
EquipCooldown = 0.6,
AttackCooldown = 0.3,
DashForce = 80,
DashDuration = 0.18,
JumpCooldown = 0.6,

Weapons = {
Katana = {
price = 0,
killEffect = "DefaultSlash",
skins = {
{ name = "Steel", price = 0, killEffect = "DefaultSlash" },
{ name = "Oni", price = 450, killEffect = "RedSlash" },
{ name = "Blossom", price = 650, killEffect = "PetalBurst" },
},
},
Naginata = {
price = 1200,
killEffect = "WideSweep",
skins = {
{ name = "Warrior", price = 0 },
{ name = "Lotus", price = 800, killEffect = "PetalBurst" },
},
},
Kanabo = {
price = 1500,
killEffect = "ImpactBurst",
skins = {
{ name = "Iron", price = 0 },
{ name = "OniBreaker", price = 900 },
},
},
Tanto = {
price = 700,
killEffect = "DefaultSlash",
skins = {
{ name = "Night", price = 0 },
{ name = "Ivory", price = 400 },
},
},
Odachi = {
price = 2000,
killEffect = "WideSweep",
skins = {
{ name = "Storm", price = 0 },
{ name = "Midnight", price = 1200, killEffect = "RedSlash" },
},
},
Scythe = {
price = 2500,
killEffect = "Reap",
skins = {
{ name = "Bone", price = 0 },
{ name = "Phantom", price = 1500, killEffect = "GhostBurst" },
},
},
Kusarigama = {
price = 1800,
killEffect = "Whirl",
skins = {
{ name = "Chain", price = 0 },
{ name = "Ember", price = 950, killEffect = "RedSlash" },
},
},
Caestus = {
price = 900,
killEffect = "ImpactBurst",
skins = {
{ name = "Bronze", price = 0 },
{ name = "Crimson", price = 600 },
},
},
Crucible = {
price = 0,
killEffect = "Inferno",
skins = {
{ name = "Inferno", price = 0, killEffect = "Inferno" }
},
customOnly = true,
},
},

CustomSkins = {
["Blade of Oni"] = { weaponType = "Katana", skinName = "Oni", killEffect = "RedSlash" },
["Lotus Storm"] = { weaponType = "Naginata", skinName = "Lotus", killEffect = "PetalBurst" },
},
}

function WeaponsConfig:GetWeaponInfo(weaponType)
return self.Weapons[weaponType]
end

function WeaponsConfig:GetSkinInfo(weaponType, skinName)
local weapon = self.Weapons[weaponType]
if not weapon then
return nil
end
for _, skin in ipairs(weapon.skins or {}) do
if skin.name == skinName then
return skin
end
end
return nil
end

return WeaponsConfig
