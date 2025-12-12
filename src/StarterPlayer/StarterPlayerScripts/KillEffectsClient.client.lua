local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')

local remotes = ReplicatedStorage:WaitForChild('Remotes')
local effectsFolder = ReplicatedStorage:WaitForChild('KillEffects')

local function playEffect(attacker, victim, effectName)
    if not victim or not victim.Character then return end
    local root = victim.Character:FindFirstChild('HumanoidRootPart')
    local humanoid = victim.Character:FindFirstChildOfClass('Humanoid')
    if humanoid then
        humanoid.BreakJointsOnDeath = false
    end
    if root then
        local template = effectsFolder:FindFirstChild(effectName) or effectsFolder:FindFirstChild('DefaultSlash')
        if template then
            local clone = template:Clone()
            clone.CFrame = root.CFrame
            clone.Parent = workspace
            for _, emitter in ipairs(clone:GetDescendants()) do
                if emitter:IsA('ParticleEmitter') then
                    emitter:Emit(emitter.Rate > 0 and emitter.Rate or 15)
                elseif emitter:IsA('Sound') then
                    emitter:Play()
                end
            end
            game:GetService('Debris'):AddItem(clone, 1)
        end
        local fade = TweenService:Create(root, TweenInfo.new(0.4), {Transparency = 1})
        fade:Play()
    end
    if attacker and attacker == Players.LocalPlayer then
        local cam = workspace.CurrentCamera
        if cam then
            cam:ApplyImpulse(Vector3.new(0, 0, 0))
        end
    end
end

remotes.PlayKillEffect.OnClientEvent:Connect(playEffect)
