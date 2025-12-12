local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimationUtil = {}

function AnimationUtil.loadAnimation(humanoid, animation)
if not humanoid or not animation then
return nil
end
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
animator.Parent = humanoid
return animator:LoadAnimation(animation)
end

function AnimationUtil.getAnimation(folderPath)
local anim = ReplicatedStorage:FindFirstChild(folderPath)
if anim and anim:IsA("Animation") then
return anim
end
return nil
end

return AnimationUtil
