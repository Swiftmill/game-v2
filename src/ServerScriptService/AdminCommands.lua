local Players = game:GetService('Players')
local TextChatService = game:GetService('TextChatService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local WeaponService = require(script.Parent.WeaponService)
local DataService = require(script.Parent.DataService)
local WeaponsConfig = require(ReplicatedStorage.Modules.WeaponsConfig)

local AdminCommands = {}
local GENERAL_CHANNEL = 'RBXGeneral'

local function systemMessage(text)
    local channel = TextChatService:FindFirstChild('TextChannels') and TextChatService.TextChannels:FindFirstChild(GENERAL_CHANNEL)
    if channel then
        channel:DisplaySystemMessage(text)
    end
end

local function isAdmin(player)
    return player.UserId == game.CreatorId or player:GetRankInGroup(0) >= 255
end

local function grantWeapon(targetPlayer, weaponName)
    local state = DataService:GetState(targetPlayer) or DataService.LoadPlayer(targetPlayer)
    state.currentWeapon = weaponName
    state.currentSkin = WeaponsConfig.DefaultSkinName
    WeaponService:GiveWeapon(targetPlayer, weaponName, WeaponsConfig.DefaultSkinName)
end

local function grantCustom(targetPlayer, customName)
    local state = DataService:GetState(targetPlayer) or DataService.LoadPlayer(targetPlayer)
    local custom = WeaponsConfig.CustomSkins[customName]
    if not custom then
        return
    end
    state.unlockedCustoms[customName] = true
    state.currentWeapon = custom.weaponType
    state.currentSkin = custom.skinName
    WeaponService:GiveWeapon(targetPlayer, custom.weaponType, custom.skinName)
    systemMessage(('%s a donné le custom "%s" à %s — Bravo !!'):format('SERVER', customName, targetPlayer.Name))
end

local function handleCommand(player, message)
    if not isAdmin(player) then
        return false
    end
    local args = message:split(' ')
    if args[1] == '-give' and args[2] and args[3] then
        local targetName, weaponName = args[2], args[3]
        local target = Players:FindFirstChild(targetName)
        if target then
            grantWeapon(target, weaponName)
            systemMessage(('%s a donné %s à %s — Bravo !!'):format(player.Name, weaponName, target.Name))
        end
        return true
    end
    if args[1] == '/givecustom' and args[2] and args[3] then
        local targetName, customName = args[2], table.concat(args, ' ', 3)
        local target = Players:FindFirstChild(targetName)
        if target then
            grantCustom(target, customName)
        end
        return true
    end
    if args[1] == '/crucible' then
        grantWeapon(player, 'Crucible')
        return true
    end
    return false
end

TextChatService.OnIncomingMessage = function(message)
    local props = Instance.new('TextChatMessageProperties')
    if message.TextSource then
        local player = Players:GetPlayerByUserId(message.TextSource.UserId)
        if player then
            local blocked = handleCommand(player, message.Text)
            if blocked then
                props.ShouldDeliver = false
                return props
            end
        end
    end
end

return AdminCommands
