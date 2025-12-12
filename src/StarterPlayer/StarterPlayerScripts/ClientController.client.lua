local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local ContextActionService = game:GetService('ContextActionService')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild('Remotes')
local animations = ReplicatedStorage:WaitForChild('Animations')

local humanoid
local root
local equipped = false
local blocking = false
local lastJump = 0
local currentTrack

local function playAnimation(path)
    if not humanoid then return end
    local anim = ReplicatedStorage:FindFirstChild(path)
    if anim and anim:IsA('Animation') then
        if currentTrack then
            currentTrack:Stop()
        end
        currentTrack = humanoid:LoadAnimation(anim)
        currentTrack:Play()
    end
end

local function loadAnimator()
    if player.Character then
        humanoid = player.Character:WaitForChild('Humanoid')
        root = player.Character:WaitForChild('HumanoidRootPart')
    end
end

player.CharacterAdded:Connect(loadAnimator)
if player.Character then
    loadAnimator()
end

local function toggleEquip()
    equipped = not equipped
    remotes.RequestEquipState:FireServer(equipped)
    local weaponType = player:GetAttribute('EquippedWeaponType') or 'Katana'
    local animPath = ('Animations/%s/%s'):format(weaponType, equipped and 'Equip' or 'Unequip')
    playAnimation(animPath)
end

local function startAttack()
    if currentTrack and currentTrack.IsPlaying then
        currentTrack:Stop()
    end
    remotes.RequestAttack:FireServer()
end

local function toggleBlock(actionName, inputState)
    if inputState == Enum.UserInputState.Begin then
        blocking = true
        remotes.RequestBlockState:FireServer(true)
    elseif inputState == Enum.UserInputState.End then
        blocking = false
        remotes.RequestBlockState:FireServer(false)
    end
end

local function performKick()
    remotes.RequestKick:FireServer()
end

local function performDash(inputObj, processed)
    if processed or not root then return end
    local direction = root.CFrame.LookVector
    if inputObj.KeyCode == Enum.KeyCode.A or inputObj.KeyCode == Enum.KeyCode.Left then
        direction = -root.CFrame.RightVector
    elseif inputObj.KeyCode == Enum.KeyCode.D or inputObj.KeyCode == Enum.KeyCode.Right then
        direction = root.CFrame.RightVector
    elseif inputObj.KeyCode == Enum.KeyCode.S then
        direction = -root.CFrame.LookVector
    end
    remotes.RequestDash:FireServer(direction)
end

local function onInputBegan(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.One then
        toggleEquip()
    elseif input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.A then
        equipped = false
        remotes.RequestEquipState:FireServer(false)
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        startAttack()
    elseif input.KeyCode == Enum.KeyCode.F then
        performKick()
    elseif input.KeyCode == Enum.KeyCode.B then
        remotes.ShopSelect:FireServer('open')
    end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.JumpRequest:Connect(function()
    local now = tick()
    if now - lastJump < 0.6 then
        if humanoid then
            humanoid.Jump = false
        end
        return
    end
    lastJump = now
end)

ContextActionService:BindAction('Block', toggleBlock, true, Enum.KeyCode.RightMouseButton)
ContextActionService:BindAction('Dash', performDash, false, Enum.KeyCode.LeftShift)

RunService.RenderStepped:Connect(function()
    if humanoid then
        if humanoid.MoveDirection.Magnitude > 0.2 then
            local runAnimFolder = animations:FindFirstChild('Shared')
            local runAnim = runAnimFolder and runAnimFolder:FindFirstChild('Run')
            if runAnim then
                local track = humanoid:LoadAnimation(runAnim)
                if not track.IsPlaying then track:Play() end
            end
        end
    end
end)
