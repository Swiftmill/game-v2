local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteNames = {"ShopSelect",
"RequestEquipState",
"RequestAttack",
"RequestBlockState",
"RequestKick",
"RequestDash",
"PlayKillEffect",
}

for _, name in ipairs(remoteNames) do
local existing = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
existing.Name = "Remotes"
existing.Parent = ReplicatedStorage
local found = existing:FindFirstChild(name)
if not found then
local event = Instance.new("RemoteEvent")
event.Name = name
event.Parent = existing
end
end

return {}
