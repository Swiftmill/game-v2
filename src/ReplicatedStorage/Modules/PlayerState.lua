local PlayerState = {}
PlayerState.__index = PlayerState

function PlayerState.new()
local self = setmetatable({}, PlayerState)
self.equipped = false
self.blocking = false
self.stunnedUntil = 0
self.lastAttackTime = 0
self.comboIndex = 0
self.lastEquipToggle = 0
self.lastDash = 0
self.lastKick = 0
self.lastJump = 0
self.lastBlockPress = 0
self.equipping = false
self.currentWeapon = nil
self.currentSkin = nil
self.unlockedCustoms = {}
self.souls = 0
return self
end

function PlayerState:IsStunned()
return tick() < self.stunnedUntil
end

function PlayerState:Stun(duration)
self.stunnedUntil = tick() + duration
end

return PlayerState
